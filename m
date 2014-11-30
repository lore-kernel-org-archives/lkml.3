Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaK3DSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 22:18:48 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54908 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaK3DSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 22:18:46 -0500
Message-ID: <547A8E1F.60900@gmail.com>
Date: Sun, 30 Nov 2014 11:25:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] virt: kvm: arm: vgic: Process the failure case when
 kvm_register_device_ops() fails
References: <54661D5F.3060304@gmail.com> <546625F8.6060900@arm.com> <54662E13.2010507@gmail.com>
In-Reply-To: <54662E13.2010507@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainers:

Is this discussion OK? If necessary, I shall send patch v3 according to
your taste.

Thanks.

On 11/15/14 00:30, Chen Gang wrote:
> 
> According to your taste, we need improve 2 contents below:
> 
> On 11/14/2014 11:55 PM, Marc Zyngier wrote:
>>
>> No. This is completely overdesigned, and fixes something that really
>> cannot happen. What is wrong with:
>>
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 3aaca49..b7dffa80 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -2465,13 +2465,17 @@ int kvm_vgic_hyp_init(void)
>>  		goto out_free_irq;
>>  	}
>>  
>> +	ret = kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>> +				       KVM_DEV_TYPE_ARM_VGIC_V2);
>> +	if (ret)
>> +		goto out_free_irq;
>> +
> 
> Need call __unregister_cpu_notifier(), since __register_cpu_notifier()
> is already successfully called.
> 
> Need print some information for failure via kvm_err().
> 
> Thanks.
>>  	/* Callback into for arch code for setup */
>>  	vgic_arch_setup(vgic);
>>  
>>  	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
>>  
>> -	return kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>> -				       KVM_DEV_TYPE_ARM_VGIC_V2);
>> +	return 0;
>>  
>>  out_free_irq:
>>  	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
>>
>> This achieves the exact same effect.
>>
>> Thanks,
>>
>> 	M.
>>
> 
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
