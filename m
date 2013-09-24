Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3IXIu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:50:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3IXIuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:50:24 -0400
Date: Tue, 24 Sep 2013 01:50:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] sysv: Add forgotten superblock lock init for v7 fs
Message-ID: <20130924085022.GD11858@infradead.org>
References: <1379457556-8902-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379457556-8902-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 12:39:16AM +0200, Lubomir Rintel wrote:
> Superblock lock was replaced with (un)lock_super() removal, but left
> uninitialized for Seventh Edition UNIX filesystem in the following commit (3.7):
> c07cb01 sysv: drop lock/unlock super
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Looks good.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Al, can you add this to the next VFS pile?

> ---
>  fs/sysv/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/sysv/super.c b/fs/sysv/super.c
> index d0c6a00..eda1095 100644
> --- a/fs/sysv/super.c
> +++ b/fs/sysv/super.c
> @@ -487,6 +487,7 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
>  	sbi->s_sb = sb;
>  	sbi->s_block_base = 0;
>  	sbi->s_type = FSTYPE_V7;
> +	mutex_init(&sbi->s_lock);
>  	sb->s_fs_info = sbi;
>  	
>  	sb_set_blocksize(sb, 512);
> -- 
> 1.7.1
> 
---end quoted text---
