Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3GaDcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:32:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab3GaDcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:32:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,783,1367942400"; 
   d="scan'208";a="8073383"
Message-ID: <51F8844A.7080407@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 11:28:10 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: fix build warning in vga16fb.c
References: <51F8829E.4080605@huawei.com>
In-Reply-To: <51F8829E.4080605@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 11:29:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/31 11:29:48
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoho, Tomi has applied the patch from Lius to fix this warning.
And this is the sixth patch to fix the same issue since last week.

Thanks,
Gu


On 07/31/2013 11:21 AM, Xishi Qiu wrote:

> When building v3.11-rc3, I get the following warning:
> ...
> drivers/video/vga16fb.c: In function ‘vga16fb_destroy’:
> drivers/video/vga16fb.c:1268: warning: unused variable ‘dev’
> ...
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  drivers/video/vga16fb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
> index 830ded4..2827333 100644
> --- a/drivers/video/vga16fb.c
> +++ b/drivers/video/vga16fb.c
> @@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
>  
>  static void vga16fb_destroy(struct fb_info *info)
>  {
> -	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
>  	iounmap(info->screen_base);
>  	fb_dealloc_cmap(&info->cmap);
>  	/* XXX unshare VGA regions */


