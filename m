Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3IHMTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3IHMTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:19:23 -0400
Date: Sun, 8 Sep 2013 15:19:17 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/15] KVM: MMU: fix the count of spte number
Message-ID: <20130908121917.GH17294@redhat.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378376958-27252-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:29:04PM +0800, Xiao Guangrong wrote:
> If the desc is the last one and it is full, its sptes is not counted
> 
Hmm, if desc is not full but it is not the last one all sptes after the
desc are not counted too.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 6e2d2c8..7714fd8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -948,6 +948,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  			count += PTE_LIST_EXT;
>  		}
>  		if (desc->sptes[PTE_LIST_EXT-1]) {
> +			count += PTE_LIST_EXT;
>  			desc->more = mmu_alloc_pte_list_desc(vcpu);
>  			desc = desc->more;
>  		}
> -- 
> 1.8.1.4

--
			Gleb.
