Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3H0Eyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:54:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab3H0Eys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:54:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,965,1367942400"; 
   d="scan'208";a="8313453"
Message-ID: <521C3013.1070003@cn.fujitsu.com>
Date: Tue, 27 Aug 2013 12:50:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: unlisted-recipients:;;linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;linux-fsdevel@vger.kernel.org
					     ^-missing end of address
Subject: Re: [PATCH] f2fs: fix omitting to update inode page
References: <1377520082-20526-1-git-send-email-jaegeuk.kim@samsung.com>
In-Reply-To: <1377520082-20526-1-git-send-email-jaegeuk.kim@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 12:52:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/27 12:52:50,
	Serialize complete at 2013/08/27 12:52:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 08:28 PM, Jaegeuk Kim wrote:

> The f2fs_set_link updates its parent inode number, so we should sync this to
> the inode block.
> Otherwise, the data can be lost after sudden-power-off.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 4e47518..9e90d31 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -447,6 +447,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		else
>  			release_orphan_inode(sbi);
>  
> +		update_inode_page(old_inode):

':' --> ';'

>  		update_inode_page(new_inode);
>  	} else {
>  		err = f2fs_add_link(new_dentry, old_inode);


