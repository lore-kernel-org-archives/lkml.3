Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaHROjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:39:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaHROjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:39:49 -0400
Message-ID: <53F2101C.4090707@redhat.com>
Date: Mon, 18 Aug 2014 16:39:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, "gleb@kernel.org" <gleb@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Increase the number of fixed MTRR regs to 10
References: <1403101279-23759-1-git-send-email-namit@cs.technion.ac.il> <20140818021715.GA7019@kernel> <BA71F1A6-1DF2-4683-9207-2305D1155239@gmail.com> <20140818081115.GA26307@kernel> <A04378F6-A6B1-46B8-B306-A9A2115F54C7@gmail.com> <D020ADA9-A9D5-4F29-911A-4742E64E4DEC@gmail.com>
In-Reply-To: <D020ADA9-A9D5-4F29-911A-4742E64E4DEC@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 16:31, Nadav Amit ha scritto:
> The cause for the blue-screen appears to be seabios, which leaves only 0x20 slots for “smp_mtrr”s.
> Apparently, the increase in the variable range MTRR count caused it to exhaust the available slots.
> As a result, some MSRs are not initialised by the BIOS (specifically, 3.5-4GB are not marked as UC), and cause Windows to panic.
> 
> Once we increase the size of the array smp_mtrr in seabios, Windows boots.
> 
> Paolo, you may wish to revert the patch. Please note that it was applied to some stable branches.

Thanks.  I'll post a patch to SeaBIOS too, since this should happen on
bare metal too.

Paolo
