Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbaGXLK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:10:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51861 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbaGXLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:10:22 -0400
Date: Thu, 24 Jul 2014 04:08:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 4/7] shmem: support RENAME_NOREPLACE
In-Reply-To: <1406121336-1379-5-git-send-email-miklos@szeredi.hu>
Message-ID: <alpine.LSU.2.11.1407240359360.1136@eggly.anvils>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu> <1406121336-1379-5-git-send-email-miklos@szeredi.hu>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Expand noreplace_rename2() because next patch will implement one more flag.

noreplace_rename2()??  I understand the code better than this comment.

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

though I wouldn't object to a comment, perhaps just in the commit message,
like you have in ext4: Existence checking was done by the VFS, otherwise
"RENAME_NOREPLACE" is equivalent to regular rename.

> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1140f49b6ded..791b05514f9a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2022,11 +2022,14 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
>   * it exists so that the VFS layer correctly free's it when it
>   * gets overwritten.
>   */
> -static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
> +static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry, unsigned int flags)
>  {
>  	struct inode *inode = old_dentry->d_inode;
>  	int they_are_dirs = S_ISDIR(inode->i_mode);
>  
> +	if (flags & ~(RENAME_NOREPLACE))
> +		return -EINVAL;
> +
>  	if (!simple_empty(new_dentry))
>  		return -ENOTEMPTY;
>  
> @@ -2709,7 +2712,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
>  	.mkdir		= shmem_mkdir,
>  	.rmdir		= shmem_rmdir,
>  	.mknod		= shmem_mknod,
> -	.rename		= shmem_rename,
> +	.rename2	= shmem_rename2,
>  	.tmpfile	= shmem_tmpfile,
>  #endif
>  #ifdef CONFIG_TMPFS_XATTR
> -- 
> 1.8.1.4
