Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbaDIJ7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:59:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbaDIJ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:59:44 -0400
Date: Wed, 9 Apr 2014 11:59:41 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 14/22] ext2: Remove xip.c and xip.h
Message-ID: <20140409095941.GH32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <33ff0862f6d99b352429ef4494817544c3d5da68.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33ff0862f6d99b352429ef4494817544c3d5da68.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:40, Matthew Wilcox wrote:
> These files are now empty, so delete them
  Looks good, you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/ext2/Makefile |  1 -
>  fs/ext2/inode.c  |  1 -
>  fs/ext2/namei.c  |  1 -
>  fs/ext2/super.c  |  1 -
>  fs/ext2/xip.c    | 15 ---------------
>  fs/ext2/xip.h    | 16 ----------------
>  6 files changed, 35 deletions(-)
>  delete mode 100644 fs/ext2/xip.c
>  delete mode 100644 fs/ext2/xip.h
> 
> diff --git a/fs/ext2/Makefile b/fs/ext2/Makefile
> index f42af45..445b0e9 100644
> --- a/fs/ext2/Makefile
> +++ b/fs/ext2/Makefile
> @@ -10,4 +10,3 @@ ext2-y := balloc.o dir.o file.o ialloc.o inode.o \
>  ext2-$(CONFIG_EXT2_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
>  ext2-$(CONFIG_EXT2_FS_POSIX_ACL) += acl.o
>  ext2-$(CONFIG_EXT2_FS_SECURITY)	 += xattr_security.o
> -ext2-$(CONFIG_EXT2_FS_XIP)	 += xip.o
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 2e587e2..67124f0 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -34,7 +34,6 @@
>  #include <linux/aio.h>
>  #include "ext2.h"
>  #include "acl.h"
> -#include "xip.h"
>  #include "xattr.h"
>  
>  static int __ext2_write_inode(struct inode *inode, int do_sync);
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index 846c356..7ca803f 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -35,7 +35,6 @@
>  #include "ext2.h"
>  #include "xattr.h"
>  #include "acl.h"
> -#include "xip.h"
>  
>  static inline int ext2_add_nondir(struct dentry *dentry, struct inode *inode)
>  {
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 3a1db39..752ccb4 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -35,7 +35,6 @@
>  #include "ext2.h"
>  #include "xattr.h"
>  #include "acl.h"
> -#include "xip.h"
>  
>  static void ext2_sync_super(struct super_block *sb,
>  			    struct ext2_super_block *es, int wait);
> diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
> deleted file mode 100644
> index 66ca113..0000000
> --- a/fs/ext2/xip.c
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -/*
> - *  linux/fs/ext2/xip.c
> - *
> - * Copyright (C) 2005 IBM Corporation
> - * Author: Carsten Otte (cotte@de.ibm.com)
> - */
> -
> -#include <linux/mm.h>
> -#include <linux/fs.h>
> -#include <linux/genhd.h>
> -#include <linux/buffer_head.h>
> -#include <linux/blkdev.h>
> -#include "ext2.h"
> -#include "xip.h"
> -
> diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
> deleted file mode 100644
> index 87eeb04..0000000
> --- a/fs/ext2/xip.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -/*
> - *  linux/fs/ext2/xip.h
> - *
> - * Copyright (C) 2005 IBM Corporation
> - * Author: Carsten Otte (cotte@de.ibm.com)
> - */
> -
> -#ifdef CONFIG_EXT2_FS_XIP
> -static inline int ext2_use_xip (struct super_block *sb)
> -{
> -	struct ext2_sb_info *sbi = EXT2_SB(sb);
> -	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
> -}
> -#else
> -#define ext2_use_xip(sb)			0
> -#endif
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
