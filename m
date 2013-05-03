Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198Ab3ECCPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:15:37 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:46503 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3ECCPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:15:36 -0400
Date: Fri, 3 May 2013 11:15:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/6] KVM: MMU: introduce kvm_clear_all_lpage_info
Message-Id: <20130503111531.b288fca3287c5f892436ade4@gmail.com>
In-Reply-To: <1367032402-13729-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1367032402-13729-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013 11:13:19 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> This function is used to reset the large page info of all guest pages
> which will be used in later patch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   25 +++++++++++++++++++++++++
>  arch/x86/kvm/x86.h |    2 ++
>  2 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 52b4e97..8e4494c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6951,6 +6951,31 @@ static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
>  	}
>  }
>  
> +static void clear_memslot_lpage_info(struct kvm_memory_slot *slot)
> +{
> +	int i;
> +
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
> +		int lpages;
> +		int level = i + 1;
> +
> +		lpages = gfn_to_index(slot->base_gfn + slot->npages - 1,
> +				      slot->base_gfn, level) + 1;
> +
> +		memset(slot->arch.lpage_info[i - 1], 0,
> +		       sizeof(*slot->arch.lpage_info[i - 1]));
> +		memslot_set_lpage_disallowed(slot, slot->npages, i, lpages);

This does something other than clearing.
Any better name?

	Takuya
