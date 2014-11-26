Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaKZJIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:08:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:54557 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKZJIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:08:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,461,1413270000"; 
   d="scan'208";a="638296351"
Date: Wed, 26 Nov 2014 16:47:57 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
Message-ID: <20141126084757.GA1042@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <20141125101331.GA28985@kernel>
 <54745BB0.8080304@redhat.com>
 <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com>
 <54748F70.70402@redhat.com>
 <DEE91387-BFE2-4F83-9711-25B2B65CF655@gmail.com>
 <20141126012439.GA20090@kernel>
 <D53D39D4-3880-4633-B3B5-5EE16D7F2E0B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D53D39D4-3880-4633-B3B5-5EE16D7F2E0B@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,
On Wed, Nov 26, 2014 at 11:00:34AM +0200, Nadav Amit wrote:
>Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
>
>> Hi all,
>> On Tue, Nov 25, 2014 at 04:50:06PM +0200, Nadav Amit wrote:
>>>> On Nov 25, 2014, at 16:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>> 
>>>> 
>>>> 
>>>> On 25/11/2014 15:05, Nadav Amit wrote:
>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>> index 373b0ab9a32e..ca26681455c2 100644
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
>>>>>> 		return err;
>>>>>> 
>>>>>> 	fpu_finit(&vcpu->arch.guest_fpu);
>>>>>> +	if (cpu_has_xsaves)
>>>>>> +		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
>>>>>> +			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>>>>>> 
>>>>>> 	/*
>>>>>> 	 * Ensure guest xcr0 is valid for loading
>>>>> 
>>>>> The second version works for me (w/qemu v2.1.0; Linux 3.13 guest). I
>> 
>> Could you try 3.17 guest which has xsaves enabled? Because I'm not sure if 
>> the below codes from Paolo is enough to mask XSAVES, should we also add 
>> F(XSAVES)?
>I guess this paragraph is intended for me. As I said before, I got limited
>access to the machine - I will not be able to run these experiments before
>Sunday, and I am not sure that I will have time to fully debug it. If you
>insist, the very least please run some experiments running a 3.16 (or older)
>guest kernel and running 3.17 with ‘noxsaves’ kernel parameter.
>
>> +       const u32 kvm_supported_word10_x86_features =
>> +               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
>> +
>> 
>> In addition, the 3.17 guest is still hang as I mentioned even if I add the 
>> F(XSAVES) to the kvm_supported_word10_x86_features.
>> 
>>>>> did not need to apply this patch on top. [although I am not sure whether
>>>>> relying on userspace to call KVM_SET_XSAVE early enough is a good practice].
>>>> 
>>>> Did you actually try the patch? :)  If it works, I'm tempted to apply it
>>>> anyway.
>>> Yes, I tried it both with and without this patch.
>>> Due to time constraints I only tested minimal functionality (Linux boot).
>>> I will run more tests in the near future. Anyhow, you can put the:
>>> 
>>> Tested-by: Nadav Amit <namit@cs.technion.ac.il>
>>> 
>>>>> One disclaimer: Since I got limited time with the machine, I executed
>>>>> a slightly modified kernel/qemu, and not the latest version.
>>>>> Anyhow, I don’t think these differences can have any impact.
>>>> 
>>>> Yes, that is no problem.
>>> 
>>> I am just worried that Wanpeng reported it fails, while I report it works...
>> 
>> I have another patch which enable xsaves in KVM and the patch is still
>> under debug with Paolo's patch "KVM: x86: support XSAVES usage in the host",
>> so the 1/2 patch from Paolo can be dropped if my patch is ready. Anyway,
>> a quick fix is needed before enable xsaves in kvm. 
>xsaves is already enabled in KVM (the host) since 3.17. It just didn’t work…
>

Not yet, it is enabled in native currrently instead of vmx and my patch
is still under debug.

Regards,
Wanpeng Li 

>Nadav
