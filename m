Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3J1H5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:57:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37798 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3J1H5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:57:46 -0400
Date: Mon, 28 Oct 2013 08:57:35 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, airlied@redhat.com, daniel.vetter@ffwll.ch,
        p.zabel@pengutronix.de, yongjun_wei@trendmicro.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: drm/imx: fix return value check in
 imx_drm_init()
Message-ID: <20131028075735.GI30088@pengutronix.de>
References: <CAPgLHd8m+fq1WDdxkoVPRRDGBDD8ExVz8Nj9Z6W+DjQehp1YZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd8m+fq1WDdxkoVPRRDGBDD8ExVz8Nj9Z6W+DjQehp1YZA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:57:20 up 64 days, 17:28, 44 users,  load average: 0.17, 0.09,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 05:07:18PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function platform_device_register_simple() returns
> ERR_PTR() and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/imx-drm-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index a2e52a0..835a1b1 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -837,8 +837,8 @@ static int __init imx_drm_init(void)
>  	INIT_LIST_HEAD(&imx_drm_device->encoder_list);
>  
>  	imx_drm_pdev = platform_device_register_simple("imx-drm", -1, NULL, 0);
> -	if (!imx_drm_pdev) {
> -		ret = -EINVAL;
> +	if (IS_ERR(imx_drm_pdev)) {
> +		ret = PTR_ERR(imx_drm_pdev);
>  		goto err_pdev;
>  	}
>  
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
