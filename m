Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaENRT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:19:29 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:51538 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbaENRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:19:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMNAFqlc1NXQ68k/2dsb2JhbABZgwasbQEBAQEBAQUBmh0BgSIXdIIlAQEEAScTHCMFCwgDGC45HgYTiDkMAdE4F4VUiHoHhEABA5lQAYsNiAeDODs
Date: Wed, 14 May 2014 19:19:16 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] FS/EFS: convert printk to pr_foo()
Message-Id: <20140514191916.36180c6b06c196bab08692bb@skynet.be>
In-Reply-To: <1400087627.30384.2.camel@joe-AO725>
References: <20140514190837.74607436b964eaf155e1665a@skynet.be>
	<1400087627.30384.2.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 10:13:47 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-05-14 at 19:08 +0200, Fabian Frederick wrote:
> > Convert all except KERN_DEBUG
> 
> trivial note:
> 
> > diff --git a/fs/efs/file.c b/fs/efs/file.c
> > index 1ccb364..a75c710 100644
> > --- a/fs/efs/file.c
> > +++ b/fs/efs/file.c
> > @@ -22,7 +22,7 @@ int efs_get_block(struct inode *inode, sector_t iblock,
> >  		/*
> >  		 * i have no idea why this happens as often as it does
> >  		 */
> > -		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> > +		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> >  			block,
> >  			inode->i_blocks,
> >  			inode->i_size);
> []
> > @@ -48,10 +48,8 @@ int efs_bmap(struct inode *inode, efs_block_t block) {
> >  		/*
> >  		 * i have no idea why this happens as often as it does
> >  		 */
> > -		printk(KERN_WARNING "EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> > -			block,
> > -			inode->i_blocks,
> > -			inode->i_size);
> > +		pr_warn("EFS: bmap(): block %d >= %ld (filesize %ld)\n",
> > +			block, inode->i_blocks, inode->i_size);
> >  #endif
> 
> Please use the same form for both blocks,
> arguments on a single line.
> 
> []
> 
> > @@ -130,7 +130,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
> >  	for(i = 0; i < EFS_DIRECTEXTENTS; i++) {
> >  		extent_copy(&(efs_inode->di_u.di_extents[i]), &(in->extents[i]));
> >  		if (i < in->numextents && in->extents[i].cooked.ex_magic != 0) {
> > -			printk(KERN_WARNING "EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
> > +			pr_warn("EFS: extent %d has bad magic number in inode %lu\n", i, inode->i_ino);
> 
> Might as well wrap to 80 cols here.
This is fixed later when fmt is removed (if it's still > 80 cols).

> 
> 


-- 
Fabian Frederick <fabf@skynet.be>
