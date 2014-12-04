Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaLDNT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:19:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLDNTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:19:25 -0500
Date: Thu, 4 Dec 2014 14:19:20 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] kvm: cpuid: fix xsave area size of XSAVEC
Message-ID: <20141204131919.GB17050@potion.brq.redhat.com>
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
 <1417691470-5221-3-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417691470-5221-3-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 19:11+0800, Wanpeng Li:
> XSAVEC also use the compacted format for the extended region
> of the XSAVE area. This patch fix it by caculate the size of
> XSAVEC extended region of XSAVE area as compact format.

(I'll believe as it makes sense, but SDM could mention that.)

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

(Nested part later.)

> v1 -> v2:
>  * use | (bitwise or) instead of II (logical or)
> 
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5b78e9b..7d5bdb4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (best->eax & F(XSAVES)))
> +	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>  
>  	/*
> -- 
> 1.9.1
> 
