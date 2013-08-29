Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3H2HYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:24:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab3H2HYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:24:05 -0400
Date: Thu, 29 Aug 2013 10:22:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 01/12] KVM: MMU: remove unused parameter
Message-ID: <20130829072259.GZ22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1375189330-24066-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:01:59PM +0800, Xiao Guangrong wrote:
> ＠vcpu in page_fault_can_be_fast() is not used so remove it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Applied this one. Thanks.

> ---
>  arch/x86/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3a9493a..a731c0b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2808,7 +2808,7 @@ exit:
>  	return ret;
>  }
>  
> -static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
> +static bool page_fault_can_be_fast(u32 error_code)
>  {
>  	/*
>  	 * Do not fix the mmio spte with invalid generation number which
> @@ -2861,7 +2861,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
>  	bool ret = false;
>  	u64 spte = 0ull;
>  
> -	if (!page_fault_can_be_fast(vcpu, error_code))
> +	if (!page_fault_can_be_fast(error_code))
>  		return false;
>  
>  	walk_shadow_page_lockless_begin(vcpu);
> -- 
> 1.8.1.4

--
			Gleb.
