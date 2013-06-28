Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3F1Nxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:53:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35093 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3F1Nxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:53:35 -0400
Message-ID: <1372427593.4257.7.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 5/5] imx-drm: ipu-dp: Adjust the maximum number of flows
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Date: Fri, 28 Jun 2013 15:53:13 +0200
In-Reply-To: <1372390325-7566-5-git-send-email-festevam@gmail.com>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
	 <1372390325-7566-5-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

Am Freitag, den 28.06.2013, 00:32 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Later in ipu_dp_get() the index of the flow array is calculated by:
> flow >> 1
> 
> So adjust its maximum to IPUV3_NUM_FLOWS << 1.
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

If (flow == IPUV3_NUM_FLOWS << 1), this will continue and try to access
&priv->flow[3] below, which is invalid. How about

+	if ((flow >> 1) >= IPUV3_NUM_FLOWS)

instead?

>  		return ERR_PTR(-EINVAL);
>  
>  	if (flow & 1)

regards
Philipp

