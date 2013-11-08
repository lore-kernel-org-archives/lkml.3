Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3KHGCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:02:21 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52401 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3KHGCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:02:20 -0500
X-AuditID: 9c93016f-b7bb9ae000001e30-d9-527c7e6b7194
Date: Fri, 8 Nov 2013 15:02:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] Squashfs: restructure squashfs_readpage()
Message-ID: <20131108060218.GC4038@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-6-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383855865-4683-6-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 08:24:24PM +0000, Phillip Lougher wrote:
> Restructure squashfs_readpage() splitting it into separate
> functions for datablocks, fragments and sparse blocks.
> 
> Move the memcpying (from squashfs cache entry) implementation of
> squashfs_readpage_block into file_cache.c
> 
> This allows different implementations to be supported.
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
> ---
>  fs/squashfs/Makefile     |    2 +-
>  fs/squashfs/file.c       |  142 +++++++++++++++++++++++-----------------------
>  fs/squashfs/file_cache.c |   38 +++++++++++++
>  fs/squashfs/squashfs.h   |    7 +++
>  4 files changed, 118 insertions(+), 71 deletions(-)
>  create mode 100644 fs/squashfs/file_cache.c
> 
> diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
> index 5833b96..908c0d9 100644
> --- a/fs/squashfs/Makefile
> +++ b/fs/squashfs/Makefile
> @@ -4,7 +4,7 @@
>  
>  obj-$(CONFIG_SQUASHFS) += squashfs.o
>  squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
> -squashfs-y += namei.o super.o symlink.o decompressor.o
> +squashfs-y += namei.o super.o symlink.o decompressor.o file_cache.c

                                                          file_cache.o

-- 
Kind regards,
Minchan Kim
