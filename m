Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaENROP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:14:15 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:37481 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756509AbaENRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:13:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sock87_5b8acca27d80d
X-Filterd-Recvd-Size: 2413
Message-ID: <1400087627.30384.2.camel@joe-AO725>
Subject: Re: [PATCH 1/3] FS/EFS: convert printk to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Wed, 14 May 2014 10:13:47 -0700
In-Reply-To: <20140514190837.74607436b964eaf155e1665a@skynet.be>
References: <20140514190837.74607436b964eaf155e1665a@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 19:08 +0200, Fabian Frederick wrote:
> Convert all except KERN_DEBUG

trivial note:

> diff --git a/fs/efs/file.c b/fs/efs/file.c
> index 1ccb364..a75c710 100644
> --- a/fs/efs/file.c
> +++ b/fs/efs/file.c
> @@ -22,7 +22,7 @@ int efs_get_block(struct inode *inode, sector_t iblock,
>  		/*
>  		 * i have no idea why this happens as often as it does
>  		 */
> -		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> +		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
>  			block,
>  			inode->i_blocks,
>  			inode->i_size);
[]
> @@ -48,10 +48,8 @@ int efs_bmap(struct inode *inode, efs_block_t block) {
>  		/*
>  		 * i have no idea why this happens as often as it does
>  		 */
> -		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> -			block,
> -			inode->i_blocks,
> -			inode->i_size);
> +		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> +			block, inode->i_blocks, inode->i_size);
>  #endif

Please use the same form for both blocks,
arguments on a single line.

[]

> @@ -130,7 +130,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
>  	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
>  		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
>  		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
> -			printk(KERN_WARNING "EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
> +			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);

Might as well wrap to 80 cols here.


