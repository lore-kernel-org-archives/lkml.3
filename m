Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaGYGLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:11:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:65374 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751248AbaGYGLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:11:10 -0400
X-IronPort-AV: E=Sophos;i="5.00,959,1396972800"; 
   d="scan'208";a="33765743"
Message-ID: <53D1F21F.1010507@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 13:58:55 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev][PATCH 2/2] f2fs: fix to put root inode in error path
 of fill_super
References: <003b01cfa7c4$b7408040$25c180c0$@samsung.com>
In-Reply-To: <003b01cfa7c4$b7408040$25c180c0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:55 PM, Chao Yu wrote:

> We should put root inode correctly in error path of fill_super, otherwise we
> may encounter a leak case of inode resource.

Good catch, and it also fixed the incorrect 'goto'.

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/f2fs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 870fe19..34649aa 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -1033,8 +1033,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  		goto free_node_inode;
>  	}
>  	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
> +		iput(root);
>  		err = -EINVAL;
> -		goto free_root_inode;
> +		goto free_node_inode;
>  	}
>  
>  	sb->s_root = d_make_root(root); /* allocate root dentry */


