Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3FFKMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:12:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab3FFKMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:12:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,814,1363104000"; 
   d="scan'208";a="7479369"
Message-ID: <51B060E1.7050509@cn.fujitsu.com>
Date: Thu, 06 Jun 2013 18:13:53 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: naota@elisp.net
CC: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop inode if inode root is NULL
References: <87bo7jh8a5.fsf@elisp.net>
In-Reply-To: <87bo7jh8a5.fsf@elisp.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 18:11:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 18:11:03,
	Serialize complete at 2013/06/06 18:11:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 	thu, 06 Jun 2013 18:56:34 +0900, naota@elisp.net wrote:
> There is a path where btrfs_drop_inode() is called with its inode's root
> is NULL: In btrfs_new_inode(), when btrfs_set_inode_index() fails,
> iput() is called. We should handle this case before taking look at the
> root->root_item.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
>  fs/btrfs/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index af978f7..17f3064 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8012,6 +8012,9 @@ int btrfs_drop_inode(struct inode *inode)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  
> +	if (root == NULL)
> +		return 1;
> +
>  	/* the snap/subvol tree is on deleting */
>  	if (btrfs_root_refs(&root->root_item) == 0 &&
>  	    root != root->fs_info->tree_root)
> 

