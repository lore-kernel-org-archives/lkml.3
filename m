Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3IPN1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3IPN1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:27:53 -0400
Subject: Re: [PATCH 09/11] gfs2: set FILE_CREATED
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
In-Reply-To: <1379335925-30858-10-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	 <1379335925-30858-10-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 16 Sep 2013 14:27:58 +0100
Message-ID: <1379338078.2718.19.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-09-16 at 14:52 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> In gfs2_create_inode() set FILE_CREATED in *opened.
> 
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Thanks for spotting this issue,

Steve.


> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> ---
>  fs/gfs2/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index 9a1be62..ef411a3 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -694,8 +694,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
>  
>  	mark_inode_dirty(inode);
>  	d_instantiate(dentry, inode);
> -	if (file)
> +	if (file) {
> +		*opened |= FILE_CREATED;
>  		error = finish_open(file, dentry, gfs2_open_common, opened);
> +	}
>  	gfs2_glock_dq_uninit(ghs);
>  	gfs2_glock_dq_uninit(ghs + 1);
>  	return error;


