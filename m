Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3JYNHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:07:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54994 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3JYNHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:07:46 -0400
Message-ID: <526A6D1D.8080504@arm.com>
Date: Fri, 25 Oct 2013 14:07:41 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Jonathan Austin <Jonathan.Austin@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree
References: <1382632289-18523-1-git-send-email-treding@nvidia.com> <1382706224-8859-1-git-send-email-treding@nvidia.com> <1382706224-8859-5-git-send-email-treding@nvidia.com>
In-Reply-To: <1382706224-8859-5-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 25 Oct 2013 13:07:36.0014 (UTC) FILETIME=[2CA33EE0:01CED183]
X-MC-Unique: 113102514074406401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/13 14:03, Thierry Reding wrote:
> Today's linux-next merge of the kvm-arm tree got a conflict in
> 
> 	arch/arm/kvm/reset.c
> 
> caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and 7999b4d
> (ARM: KVM: drop limitation to 4 CPU VMs).
> 
> I fixed it up (see below). Please verify that the resolution looks good.

Looks good. Thanks Thierry.

	M.

> Thanks,
> Thierry
> ---
> diff --cc arch/arm/kvm/reset.c
> index d153e64,2c5add0..f558c07
> --- a/arch/arm/kvm/reset.c
> +++ b/arch/arm/kvm/reset.c
> @@@ -64,9 -62,7 +62,7 @@@ int kvm_reset_vcpu(struct kvm_vcpu *vcp
>   	switch (vcpu->arch.target) {
>   	case KVM_ARM_TARGET_CORTEX_A7:
>   	case KVM_ARM_TARGET_CORTEX_A15:
> - 		if (vcpu->vcpu_id > cortexa_max_cpu_idx)
> - 			return -EINVAL;
>  -		cpu_reset = &cortexa_regs_reset;
>  +		reset_regs = &cortexa_regs_reset;
>   		vcpu->arch.midr = read_cpuid_id();
>   		cpu_vtimer_irq = &cortexa_vtimer_irq;
>   		break;
> 


-- 
Jazz is not dead. It just smells funny...

