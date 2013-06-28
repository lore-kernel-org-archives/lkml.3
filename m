Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3F1HaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:30:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57929 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3F1HaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:30:21 -0400
Date: Fri, 28 Jun 2013 09:30:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 5/5] imx-drm: ipu-dp: Adjust the maximum number of flows
Message-ID: <20130628073013.GJ27010@pengutronix.de>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
 <1372390325-7566-5-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372390325-7566-5-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:32:05AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Later in ipu_dp_get() the index of the flow array is calculated by:
> flow >> 1
> 
> So adjust its maximum to IPUV3_NUM_FLOWS << 1.
Maybe squash this into patch 4?

Uwe
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> index 3bdff6af..ae2c199 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
> @@ -282,7 +282,7 @@ struct ipu_dp *ipu_dp_get(struct ipu_soc *ipu, unsigned int flow)
>  	struct ipu_dp_priv *priv = ipu->dp_priv;
>  	struct ipu_dp *dp;
>  
> -	if (flow > 5)
> +	if (flow > IPUV3_NUM_FLOWS << 1)
>  		return ERR_PTR(-EINVAL);
>  
>  	if (flow & 1)
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
