Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKYOuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:50:13 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48106 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKYOuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:50:11 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <54748F70.70402@redhat.com>
Date: Tue, 25 Nov 2014 16:50:06 +0200
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        hpa@linux.intel.com
Content-Transfer-Encoding: 8BIT
Message-Id: <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <20141125101331.GA28985@kernel> <54745BB0.8080304@redhat.com> <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com> <54748F70.70402@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Nov 25, 2014, at 16:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> 
> 
> On 25/11/2014 15:05, Nadav Amit wrote:
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 373b0ab9a32e..ca26681455c2 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
>>> 		return err;
>>> 
>>> 	fpu_finit(&vcpu->arch.guest_fpu);
>>> +	if (cpu_has_xsaves)
>>> +		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
>>> +			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>> 
>>> 	/*
>>> 	 * Ensure guest xcr0 is valid for loading
>> 
>> The second version works for me (w/qemu v2.1.0; Linux 3.13 guest). I
>> did not need to apply this patch on top. [although I am not sure whether
>> relying on userspace to call KVM_SET_XSAVE early enough is a good practice].
> 
> Did you actually try the patch? :)  If it works, I'm tempted to apply it
> anyway.
Yes, I tried it both with and without this patch.
Due to time constraints I only tested minimal functionality (Linux boot).
I will run more tests in the near future. Anyhow, you can put the:

Tested-by: Nadav Amit <namit@cs.technion.ac.il>

> 
>> One disclaimer: Since I got limited time with the machine, I executed
>> a slightly modified kernel/qemu, and not the latest version.
>> Anyhow, I don’t think these differences can have any impact.
> 
> Yes, that is no problem.

I am just worried that Wanpeng reported it fails, while I report it works...

Nadav

