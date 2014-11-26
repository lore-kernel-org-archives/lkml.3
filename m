Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaKZBpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:45:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:26016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaKZBpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628315046"
Date: Wed, 26 Nov 2014 09:24:39 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>, namit@cs.technion.ac.il,
        hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
Message-ID: <20141126012439.GA20090@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <20141125101331.GA28985@kernel>
 <54745BB0.8080304@redhat.com>
 <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com>
 <54748F70.70402@redhat.com>
 <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
On Tue, Nov 25, 2014 at 04:50:06PM +0200, Nadav Amit wrote:
>
>> On Nov 25, 2014, at 16:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> 
>> 
>> 
>> On 25/11/2014 15:05, Nadav Amit wrote:
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 373b0ab9a32e..ca26681455c2 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
>>>> 		return err;
>>>> 
>>>> 	fpu_finit(&vcpu->arch.guest_fpu);
>>>> +	if (cpu_has_xsaves)
>>>> +		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
>>>> +			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>>> 
>>>> 	/*
>>>> 	 * Ensure guest xcr0 is valid for loading
>>> 
>>> The second version works for me (w/qemu v2.1.0; Linux 3.13 guest). I

Could you try 3.17 guest which has xsaves enabled? Because I'm not sure if 
the below codes from Paolo is enough to mask XSAVES, should we also add 
F(XSAVES)?

+       const u32 kvm_supported_word10_x86_features =
+               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+

In addition, the 3.17 guest is still hang as I mentioned even if I add the 
F(XSAVES) to the kvm_supported_word10_x86_features.

>>> did not need to apply this patch on top. [although I am not sure whether
>>> relying on userspace to call KVM_SET_XSAVE early enough is a good practice].
>> 
>> Did you actually try the patch? :)  If it works, I'm tempted to apply it
>> anyway.
>Yes, I tried it both with and without this patch.
>Due to time constraints I only tested minimal functionality (Linux boot).
>I will run more tests in the near future. Anyhow, you can put the:
>
>Tested-by: Nadav Amit <namit@cs.technion.ac.il>
>
>> 
>>> One disclaimer: Since I got limited time with the machine, I executed
>>> a slightly modified kernel/qemu, and not the latest version.
>>> Anyhow, I don’t think these differences can have any impact.
>> 
>> Yes, that is no problem.
>
>I am just worried that Wanpeng reported it fails, while I report it works...
>

I have another patch which enable xsaves in KVM and the patch is still
under debug with Paolo's patch "KVM: x86: support XSAVES usage in the host",
so the 1/2 patch from Paolo can be dropped if my patch is ready. Anyway,
a quick fix is needed before enable xsaves in kvm. 

Regards,
Wanpeng Li 

>Nadav
