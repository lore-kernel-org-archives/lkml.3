Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3KUFec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:34:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:35408 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3KUFea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438983292"
Date: Thu, 21 Nov 2013 13:34:03 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/2] f2fs: disable the extent cache ops on
 high fragmented files
Message-ID: <20131121053402.GA9143@hli22-desktop>
References: <1384845037-7872-1-git-send-email-jaegeuk.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384845037-7872-1-git-send-email-jaegeuk.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

Function looks good to me. But some nitpicking below for code cleanup..

> @@ -71,6 +71,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
return value could be boolean?
>  	pgoff_t start_fofs, end_fofs;
>  	block_t start_blkaddr;
>  
> +	if (is_inode_flag_set(fi, FI_NO_EXTENT))
> +		return 0;
> +
>  	read_lock(&fi->ext.ext_lock);
>  	if (fi->ext.len == 0) {
>  		read_unlock(&fi->ext.ext_lock);
> @@ -109,6 +112,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
>  	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
>  	pgoff_t fofs, start_fofs, end_fofs;
>  	block_t start_blkaddr, end_blkaddr;
> +	int need_update = true;
bool?
