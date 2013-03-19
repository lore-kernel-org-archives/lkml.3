Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab3CSKd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:33:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33874 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3CSKdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:33:25 -0400
Date: Tue, 19 Mar 2013 11:33:21 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] imx_drm: ipu_v3: fix invalid free of devm_* allocated
 data
Message-ID: <20130319103321.GN1906@pengutronix.de>
References: <1363435356-2237-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363435356-2237-1-git-send-email-silviupopescu1990@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:32:31 up 269 days,  1:44, 92 users,  load average: 0.81, 4.05,
 5.42
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 02:02:36PM +0200, Silviu-Mihai Popescu wrote:
> The objects allocated by devm_* APIs are managed by devres and are freed
> when the device is detached. There is no need to use kfree() explicitly.

Not only 'no need', it's simply wrong.

> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-dp.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> index 26aecaf..113b046 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> @@ -316,7 +316,6 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
>  
>  	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
>  	if (!priv->base) {
> -		kfree(priv);
>  		return -ENOMEM;
>  	}
>  
> -- 
> 1.7.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
