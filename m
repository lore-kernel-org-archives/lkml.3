Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJPMVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:21:42 -0400
Received: from mail.efficios.com ([78.47.125.74]:36518 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaJPMVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:21:39 -0400
Date: Thu, 16 Oct 2014 14:21:15 +0200
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 15/21] ext2: Remove xip.c and xip.h
Message-ID: <20141016122115.GM19075@thinkos.etherlink>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-16-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411677218-29146-16-git-send-email-matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-Sep-2014 04:33:32 PM, Matthew Wilcox wrote:
> These files are now empty, so delete them
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

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
> index cba3833..154cbcf 100644
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
> index d862031..0393c6d 100644
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
> 2.1.0
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
Key fingerprint: 2A0B 4ED9 15F2 D3FA 45F5  B162 1728 0A97 8118 6ACF
