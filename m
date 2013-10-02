Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3JBO7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab3JBO7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:59:41 -0400
Date: Wed, 2 Oct 2013 17:59:31 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 17/26] kvm: Use get_user_pages_unlocked() in
 async_pf_execute()
Message-ID: <20131002145931.GL17294@redhat.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-18-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380724087-13927-18-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks straightforward.

On Wed, Oct 02, 2013 at 04:27:58PM +0200, Jan Kara wrote:
> CC: Gleb Natapov <gleb@redhat.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: kvm@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  virt/kvm/async_pf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 8a39dda7a325..8d4b39a4bc12 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -67,9 +67,7 @@ static void async_pf_execute(struct work_struct *work)
>  	might_sleep();
>  
>  	use_mm(mm);
> -	down_read(&mm->mmap_sem);
> -	get_user_pages(current, mm, addr, 1, 1, 0, &page, NULL);
> -	up_read(&mm->mmap_sem);
> +	get_user_pages_unlocked(current, mm, addr, 1, 1, 0, &page);
>  	unuse_mm(mm);
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -- 
> 1.8.1.4

--
			Gleb.
