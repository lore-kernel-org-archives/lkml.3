Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3FFJ1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab3FFJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:27:17 -0400
Subject: Re: [PATCH] GFS2: minor readability improvement in gfs2_mount()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
In-Reply-To: <1370467772-4587-1-git-send-email-khoroshilov@ispras.ru>
References: <1370467772-4587-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 06 Jun 2013 10:24:42 +0100
Message-ID: <1370510682.2744.5.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-06-06 at 01:29 +0400, Alexey Khoroshilov wrote:
> The patch makes usage pattern of IS_ERR-PTR_ERR more typical.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  fs/gfs2/ops_fstype.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 0262c19..0d30e8e 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1313,9 +1313,10 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
>  	}
>  	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -	error = PTR_ERR(s);
> -	if (IS_ERR(s))
> +	if (IS_ERR(s)) {
> +		error = PTR_ERR(s);
>  		goto error_bdev;
> +	}
I'm not sure what you are getting at here. Why add a jump into the fast
path?

Steve.

>  
>  	if (s->s_root)
>  		blkdev_put(bdev, mode);


