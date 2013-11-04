Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3KDNQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:16:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3KDNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:16:22 -0500
Date: Mon, 4 Nov 2013 14:16:19 +0100
From: Jan Kara <jack@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] quota: info leak in quota_getquota()
Message-ID: <20131104131619.GA8566@quack.suse.cz>
References: <20131101102154.GC29795@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101102154.GC29795@longonot.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-11-13 13:21:54, Dan Carpenter wrote:
> The if_dqblk struct has a 4 byte hole at the end of the struct so
> uninitialized stack information is leaked to user space.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
  Thanks. I've merged the patch into my tree.

							Honza
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index dea86e8..2b363e2 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -117,6 +117,7 @@ static int quota_setinfo(struct super_block *sb, int type, void __user *addr)
>  
>  static void copy_to_if_dqblk(struct if_dqblk *dst, struct fs_disk_quota *src)
>  {
> +	memset(dst, 0, sizeof(*dst));
>  	dst->dqb_bhardlimit = src->d_blk_hardlimit;
>  	dst->dqb_bsoftlimit = src->d_blk_softlimit;
>  	dst->dqb_curspace = src->d_bcount;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
