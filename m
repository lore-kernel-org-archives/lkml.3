Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3CJWzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:55:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36134 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3CJWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:55:21 -0400
Date: Sun, 10 Mar 2013 15:55:13 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fs2fs: Replaced calls to kmalloc and memcpy with
 kmemdup
Message-ID: <20130310225513.GF7783@localhost>
Mail-Followup-To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <1362829777-6924-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362829777-6924-1-git-send-email-gheorghiuandru@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 01:49:37PM +0200, Alexandru Gheorghiu wrote:
> Replaced calls to kmalloc followd by memcpy with a single call to kmemdup.
> This patch was found using coccicheck.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/localalloc.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index aebeacd..839183f 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
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
> @@ -1244,13 +1243,12 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
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
> -- 
> 1.7.9.5
> 

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

			http://www.jlbec.org/
			jlbec@evilplan.org
