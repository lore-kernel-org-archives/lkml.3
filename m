Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3LCCq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:46:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3LCCqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:46:25 -0500
Date: Mon, 2 Dec 2013 18:47:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: add necessary Null check in
 sysfs_do_create_link_sd
Message-ID: <20131203024726.GC23997@kroah.com>
References: <529D3627.1000205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529D3627.1000205@huawei.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 09:38:47AM +0800, Rui Xiang wrote:
> While target_sd or sd are null, it won't need sysfs_put and
> should return -ENOENT directly. Here add null check for
> target_sd and sd.
> 
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
> ---
>  fs/sysfs/symlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
> index 3ae3f1b..d69b786 100644
> --- a/fs/sysfs/symlink.c
> +++ b/fs/sysfs/symlink.c
> @@ -83,8 +83,10 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
>  	return 0;
>  
>   out_put:
> -	sysfs_put(target_sd);
> -	sysfs_put(sd);
> +	if (target_sd)
> +		sysfs_put(target_sd);
> +	if (sd)
> +		sysfs_put(sd);

This change does nothing at all, why is it needed?

greg k-h
