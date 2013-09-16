Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3IPItK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:49:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47818 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IPItI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:49:08 -0400
Message-ID: <5236C5FF.5060301@arm.com>
Date: Mon, 16 Sep 2013 09:49:03 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Andrew Jones <drjones@redhat.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 2/3] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
References: <1379160656-28050-1-git-send-email-drjones@redhat.com> <1379160656-28050-3-git-send-email-drjones@redhat.com> <20130915093002.GX17294@redhat.com> <5236BCB7.9080102@arm.com> <20130916083221.GI17294@redhat.com>
In-Reply-To: <20130916083221.GI17294@redhat.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 16 Sep 2013 08:49:04.0678 (UTC) FILETIME=[990CF460:01CEB2B9]
X-MC-Unique: 113091609490601801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/13 09:32, Gleb Natapov wrote:
> On Mon, Sep 16, 2013 at 09:09:27AM +0100, Marc Zyngier wrote:
>> On 15/09/13 10:30, Gleb Natapov wrote:
>>> On Sat, Sep 14, 2013 at 02:10:55PM +0200, Andrew Jones wrote:
>>>> Drop the _ARM_ part of the name. We can then introduce a config option
>>>> like this to aarch64 and other arches using the same name - allowing
>>>> grep to show them all. Also update the help text to describe the option
>>>> more completely.
>>>>
>>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>>> ---
>>>>  arch/arm/include/asm/kvm_host.h | 4 ++--
>>>>  arch/arm/kvm/Kconfig            | 8 ++++----
>>>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>> index 7d22517d80711..c614d3eb176c6 100644
>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>> @@ -25,8 +25,8 @@
>>>>  #include <asm/fpstate.h>
>>>>  #include <kvm/arm_arch_timer.h>
>>>>  
>>>> -#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
>>>> -#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>>>> +#if defined(CONFIG_KVM_MAX_VCPUS)
>>>> +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
>>>>  #else
>>>>  #define KVM_MAX_VCPUS 0
>>>>  #endif
>>>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>>>> index ebf5015508b52..de63bfccb3eb5 100644
>>>> --- a/arch/arm/kvm/Kconfig
>>>> +++ b/arch/arm/kvm/Kconfig
>>>> @@ -40,16 +40,16 @@ config KVM_ARM_HOST
>>>>  	---help---
>>>>  	  Provides host support for ARM processors.
>>>>  
>>>> -config KVM_ARM_MAX_VCPUS
>>>> +config KVM_MAX_VCPUS
>>>>  	int "Number maximum supported virtual CPUs per VM"
>>>>  	depends on KVM_ARM_HOST
>>>>  	default 4
>>>>  	help
>>>>  	  Static number of max supported virtual CPUs per VM.
>>>>  
>>>> -	  If you choose a high number, the vcpu structures will be quite
>>>> -	  large, so only choose a reasonable number that you expect to
>>>> -	  actually use.
>>> I do no see why on ARM vcpu structure size depends on KVM_ARM_MAX_VCPUS.
>>> Can somebody point me to it.
>>
>> There's a number of indirections, but here you go:
>> arch/arm/include/asm/kvm_host.h:#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
>>
>> include/kvm/arm_vgic.h:#define VGIC_MAX_CPUS            KVM_MAX_VCPUS
>>
>> include/kvm/arm_vgic.h:#if (VGIC_MAX_CPUS > 8)
>> include/kvm/arm_vgic.h: } percpu[VGIC_MAX_CPUS];
>> include/kvm/arm_vgic.h: u32 percpu[VGIC_MAX_CPUS][VGIC_NR_PRIVATE_IRQS / 4];
>> include/kvm/arm_vgic.h: u8                      irq_sgi_sources[VGIC_MAX_CPUS][VGIC_NR_SGIS];
>> include/kvm/arm_vgic.h: struct vgic_bitmap      irq_spi_target[VGIC_MAX_CPUS];
>>
>> Basically, the GIC emulation data structures are sized on the number of VCPUs
>> (as well as the number of supported interrupts).
>>
> But vgic is per VM though, not per cpu as far as I can see, so the
> overhead is also per VM, no? Is VGIC_MAX_CPUS limit architectural or
> juts an implementation detail?

Indeed, the MAX_VCPU overhead is per VM. The MAX_IRQS overhead is both
per-vm and per-vcpu.

The GICv2 architecture has a limit of 8 CPUs - not at all an
implementation detail. GICv3 remove this limitation.

	M.
-- 
Jazz is not dead. It just smells funny...

