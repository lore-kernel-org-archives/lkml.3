Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3KKHnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:43:18 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37002 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KKHnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:43:13 -0500
MIME-Version: 1.0
In-Reply-To: <1383300583-6953-1-git-send-email-duanj.fnst@cn.fujitsu.com>
References: <1383300583-6953-1-git-send-email-duanj.fnst@cn.fujitsu.com>
Date: Mon, 11 Nov 2013 15:43:10 +0800
Message-ID: <CAPgLHd_p+LJmBX6FCy1+mF3VTHkBoPa83SNXciqb28pa3QE7TA@mail.gmail.com>
Subject: Re: [PATCH] drivers: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
From: Wei Yongjun <weiyj.lk@gmail.com>
To: duanj.fnst@cn.fujitsu.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 06:09 PM, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.
>
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>  drivers/misc/carma/carma-fpga.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
> index 08b18f3..9a32e98 100644
> --- a/drivers/misc/carma/carma-fpga.c
> +++ b/drivers/misc/carma/carma-fpga.c
> @@ -956,10 +956,7 @@ static int data_debugfs_init(struct fpga_device *priv)
>  {
>  	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
>  					      &data_debug_fops);
> -	if (IS_ERR(priv->dbg_entry))
> -		return PTR_ERR(priv->dbg_entry);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(priv->dbg_entry);
>  }

Those code has make sure that CONFIG_DEBUG_FS is enabled, so
debugfs_create_file() never return PTR_ERR(), only NULL will
be returned when error occurs.



