Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaFRRvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:51:15 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61934 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbaFRRvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:51:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider cs.l
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <53A1B921.1050108@redhat.com>
Date: Wed, 18 Jun 2014 20:51:06 +0300
Cc: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E364EC9D-EC0D-43BC-B946-473CBFCAFAC1@gmail.com>
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il> <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il> <53A1B33A.3080509@redhat.com> <53A1B7EE.7070800@gmail.com> <53A1B921.1050108@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 18, 2014, at 7:06 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 18/06/2014 18:01, Nadav Amit ha scritto:
>>> 
>> 
>> Perhaps I am missing something, but I don't see where my mistake is.
>> The VMREAD source operand is always read as 64-bits and I made no
>> changes there. Therefore, if bits 63:32 are not zero, the instruction
>> should fail when attempting to access the field.
> 
> In 32-bit mode, it should be read as 32 bits: "Outside IA-32e mode, the source operand has 32 bits, regardless of the value of CS.D" (so it's never 16 bits, but it's also never 64 bits).

Oh. I now get it. I misunderstood what the SDM said, as I was thinking that 62:32 will lead to failure also on 32-bit mode.
If you fix it, please fix both VMREAD and VMWRITE. If not, I would resubmit.

Thanks,
Nadav