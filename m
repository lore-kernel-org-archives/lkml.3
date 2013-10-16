Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458Ab3JPS6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:58:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41155 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3JPS6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:58:10 -0400
Message-ID: <525EE1BC.3050605@arm.com>
Date: Wed, 16 Oct 2013 19:58:04 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Jonathan Austin <Jonathan.Austin@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree
References: <1381949500-501-1-git-send-email-treding@nvidia.com> <1381949500-501-3-git-send-email-treding@nvidia.com>
In-Reply-To: <1381949500-501-3-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 16 Oct 2013 18:57:57.0360 (UTC) FILETIME=[A09E5700:01CECAA1]
X-MC-Unique: 113101619580701601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/13 19:51, Thierry Reding wrote:
> Today's linux-next merge of the kvm-arm tree got conflicts in
> 
> 	arch/arm/kvm/reset.c
> 
> caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and ac570e0
> (ARM: kvm: rename cpu_reset to avoid name clash).
> 
> I've fixed them up (see below). Please verify that the resolution looks
> good.

Looks good to me (I have the same resolution in my own tree).

Thanks Thierry.

	M.

> Thanks,
> Thierry
> ---
> diff --cc arch/arm/kvm/reset.c
> index c02ba4a,d9bbd83..d153e64
> --- a/arch/arm/kvm/reset.c
> +++ b/arch/arm/kvm/reset.c
> @@@ -62,12 -62,13 +62,13 @@@ int kvm_reset_vcpu(struct kvm_vcpu *vcp
>   	const struct kvm_irq_level *cpu_vtimer_irq;
>   
>   	switch (vcpu->arch.target) {
> + 	case KVM_ARM_TARGET_CORTEX_A7:
>   	case KVM_ARM_TARGET_CORTEX_A15:
> - 		if (vcpu->vcpu_id > a15_max_cpu_idx)
> + 		if (vcpu->vcpu_id > cortexa_max_cpu_idx)
>   			return -EINVAL;
> - 		reset_regs = &a15_regs_reset;
>  -		cpu_reset = &cortexa_regs_reset;
> ++		reset_regs = &cortexa_regs_reset;
>   		vcpu->arch.midr = read_cpuid_id();
> - 		cpu_vtimer_irq = &a15_vtimer_irq;
> + 		cpu_vtimer_irq = &cortexa_vtimer_irq;
>   		break;
>   	default:
>   		return -ENODEV;
> 


-- 
Jazz is not dead. It just smells funny...

