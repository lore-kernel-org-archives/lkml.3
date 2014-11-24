Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaKXPyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:54:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbaKXPyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:54:45 -0500
Message-ID: <547354B3.4070908@redhat.com>
Date: Mon, 24 Nov 2014 16:54:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [CFT PATCH 0/2] KVM: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <DE9192FA-6A22-4AEB-88C2-AE17DA503685@gmail.com> <547318E5.8070408@redhat.com> <DAC65E0B-06CC-4B34-85B2-72AD5F86826B@gmail.com>
In-Reply-To: <DAC65E0B-06CC-4B34-85B2-72AD5F86826B@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 16:28, Nadav Amit wrote:
> Since kvm_load_guest_fpu is called before the guest_fpu is ever stored, there are 2 more problems that currently cause #GP:
> 1. XCOMP_BV[63] = 0
> 2. XSTATE_BV sets a bit (including bit 63) that is not set in XCOMP_BV (XCOMP_BV is initialised to zero).
> 
> [see SDM 13.11 "OPERATION OF XRSTORS”]
> 
> Once I initialise XCOMP_BV to (1ull << 63) | XSTATE_BV, the guest runs successfully.
> I have not checked any other qemu functionality that might be affected by the patch.

Ah, so the problem is with KVM_SET_XSAVE.  Thanks!

Paolo
