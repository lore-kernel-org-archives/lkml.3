Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324Ab3ECC1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:27:37 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42001 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3ECC1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:27:36 -0400
Date: Fri, 3 May 2013 11:27:29 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-Id: <20130503112729.942a04b2ba2566b35328f49e@gmail.com>
In-Reply-To: <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013 11:13:20 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> +/*
> + * Fast invalid all shadow pages belong to @slot.
> + *
> + * @slot != NULL means the invalidation is caused the memslot specified
> + * by @slot is being deleted, in this case, we should ensure that rmap
> + * and lpage-info of the @slot can not be used after calling the function.
> + *
> + * @slot == NULL means the invalidation due to other reasons, we need

The comment should explain what the "other reasons" are.
But this API may better be split into two separate functions; it depends
on the "other reasons".

> + * not care rmap and lpage-info since they are still valid after calling
> + * the function.
> + */
> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> +				   struct kvm_memory_slot *slot)

You yourself is explaining this as "invalidation" in the comment.
kvm_mmu_invalidate_shadow_pages_memslot() or something...

Anybody can think of a better name?

	Takuya
