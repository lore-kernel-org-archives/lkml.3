Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaHRKZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaHRKZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:25:09 -0400
Message-ID: <53F1D476.1030801@redhat.com>
Date: Mon, 18 Aug 2014 12:24:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: vmx: don't vmx_segment_cache_clear twice in
 enter_pmode
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <1408355431-115633-3-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408355431-115633-3-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 11:50, Wanpeng Li ha scritto:
> vmx_segment_cache_clear() will be called by vmx_set_segment() 
> which lead to vmx_segment_cache_clear() is called twice in 
> enter_pmode(). This patch remove the duplicate call site. 
> 
> Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/vmx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 2963303..c97c44c 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -3183,8 +3183,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
>  
>  	vmx->rmode.vm86_active = 0;
>  
> -	vmx_segment_cache_clear(vmx);
> -
>  	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
>  
>  	flags = vmcs_readl(GUEST_RFLAGS);
> 

I think this is not useful and obscures the code a bit.

It would be a bigger improvement to see when fix_pmode_seg really needs
to call vmx_set_segment, and avoid the call.  Are you seeing enter_pmode
high in any profiles?

Paolo
