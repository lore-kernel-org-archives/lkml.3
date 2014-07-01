Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbaGAP5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:57:10 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35171 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaGAP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:57:09 -0400
Message-ID: <53B2DA42.40604@arm.com>
Date: Tue, 01 Jul 2014 16:56:50 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: export demux regids as KVM_REG_ARM64
References: <1404229993-14522-1-git-send-email-alex.bennee@linaro.org>
In-Reply-To: <1404229993-14522-1-git-send-email-alex.bennee@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/14 16:53, Alex Bennée wrote:
> I suspect this is a -ECUTPASTE fault from the initial implementation. If
> we don't declare the register ID to be KVM_REG_ARM64 the KVM_GET_ONE_REG
> implementation kvm_arm_get_reg() returns -EINVAL and hilarity ensues.
> 
> The kvm/api.txt document describes all arm64 registers as starting with
> 0x60xx... (i.e KVM_REG_ARM64).
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0324458..5ee99e4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -962,7 +962,7 @@ static unsigned int num_demux_regs(void)
>  
>  static int write_demux_regids(u64 __user *uindices)
>  {
> -	u64 val = KVM_REG_ARM | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
> +	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
>  	unsigned int i;
>  
>  	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
> 

-EBROWNPAPERBAG.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
