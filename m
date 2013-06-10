Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3FJCqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:46:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45284 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3FJCqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:46:46 -0400
Date: Mon, 10 Jun 2013 03:46:45 +0100
From: Joel Becker <jlbec@evilplan.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Cocci spatch "memdup.spatch"
Message-ID: <20130610024645.GF13405@ZenIV.linux.org.uk>
Mail-Followup-To: Thomas Meyer <thomas@m3y3r.de>,
	linux-kernel@vger.kernel.org
References: <1370079672.29224.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370079672.29224.11.camel@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Joel Becker <jlbec@evilplan.org>

On Sat, Jun 01, 2013 at 11:41:12AM +0200, Thomas Meyer wrote:
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct o
>  	bh = osb->local_alloc_bh;
>  	alloc = (struct ocfs2_dinode *) bh->b_data;
>  
> -	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		goto out_commit;
>  	}
> -	memcpy(alloc_copy, alloc, bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
>  					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
> @@ -1244,13 +1243,12 @@ static int ocfs2_local_alloc_slide_windo
>  	 * local alloc shutdown won't try to double free main bitmap
>  	 * bits. Make a copy so the sync function knows which bits to
>  	 * free. */
> -	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
> +	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
>  	if (!alloc_copy) {
>  		status = -ENOMEM;
>  		mlog_errno(status);
>  		goto bail;
>  	}
> -	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
>  
>  	status = ocfs2_journal_access_di(handle,
>  					 INODE_CACHE(local_alloc_inode),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
