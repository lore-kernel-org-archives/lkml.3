Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab3DPQit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 12:38:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935785Ab3DPQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:36:25 -0400
Date: Mon, 15 Apr 2013 16:42:22 +0200
From: Jan Kara <jack@suse.cz>
To: majianpeng <majianpeng@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: Remove the unnecessary protect.
Message-ID: <20130415144222.GI2299@quack.suse.cz>
References: <5163CC0F.2000400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5163CC0F.2000400@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 16:06:39, majianpeng wrote:
> After allocating a inode,it don't chain in superblock.At this time,it
> won't be used by others.So it make no sense to protect there.
  Something (likely your mailer) has mangled whitespace in your patch.
Please submit patches with a program that preserves whitespace (preferred)
or use text/plain attachments.

Also I don't think the argument for removing i_lock locking is as simple.
Without the lock, i_state initialization can be speculatively performed
earlier / later wrt other instructions by the CPU so it's not clear this
cannot cause problems to some of the callers.

								Honza

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
> fs/inode.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index f5f7c06..1d7b0dd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -906,9 +906,7 @@ struct inode *new_inode_pseudo(struct super_block *sb)
> struct inode *inode = alloc_inode(sb);
> 
> if (inode) {
> - spin_lock(&inode->i_lock);
> inode->i_state = 0;
> - spin_unlock(&inode->i_lock);
> INIT_LIST_HEAD(&inode->i_sb_list);
> }
> return inode;
> -- 
> 1.8.2.rc2.4.g7799588
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
