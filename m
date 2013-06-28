Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3F1H35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:29:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57917 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3F1H34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:29:56 -0400
Date: Fri, 28 Jun 2013 09:29:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/5] imx-drm: imx-drm-core: Export
 imx_drm_encoder_get_mux_id
Message-ID: <20130628072950.GI27010@pengutronix.de>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372390325-7566-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:32:01AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> When building imx_v6_v7_defconfig with imx-drm drivers selected as modules, we 
> get the following build error:
> 
> ERROR: "imx_drm_encoder_get_mux_id" [drivers/staging/imx-drm/imx-ldb.ko] undefined!
So imx-ldb.c needs a symbol from imx-drm-core.c right? The alternative
to exporting this symbol for a single user(?) is to link these two files
into a single module. Does this make sense? If yes, that would IMHO be
the better fix.

Best regards
Uwe
> 
> Export the required function to avoid this problem.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/staging/imx-drm/imx-drm-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
> index 9854a1d..6bc205b 100644
> --- a/drivers/staging/imx-drm/imx-drm-core.c
> +++ b/drivers/staging/imx-drm/imx-drm-core.c
> @@ -678,6 +678,7 @@ found:
>  
>  	return i;
>  }
> +EXPORT_SYMBOL_GPL(imx_drm_encoder_get_mux_id);
>  
>  /*
>   * imx_drm_remove_encoder - remove an encoder
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
