Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbbASIJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:09:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49807 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbASIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:09:22 -0500
Message-ID: <1421654951.3758.2.camel@pengutronix.de>
Subject: Re: [PATCH] gpu: ipu-v3: wait_for_completion_timeout does not
 return negativ status
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 09:09:11 +0100
In-Reply-To: <1421405282-8951-1-git-send-email-der.herr@hofr.at>
References: <1421405282-8951-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicholas,

thank you for the patch.

Am Freitag, den 16.01.2015, 11:48 +0100 schrieb Nicholas Mc Guire:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> Patch is against 3.19.0-rc3 -next-20150109
> 
> This patch was compiletested with imx_v6_v7_defconfig + 
> CONFIG_RESET_CONTROLLER=y, CONFIG_IMX_IPUV3_CORE=m
> 
>  drivers/gpu/ipu-v3/ipu-dc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
> index 2326c75..0ffa659 100644
> --- a/drivers/gpu/ipu-v3/ipu-dc.c
> +++ b/drivers/gpu/ipu-v3/ipu-dc.c
> @@ -282,7 +282,7 @@ void ipu_dc_disable_channel(struct ipu_dc *dc)
>  	enable_irq(irq);
>  	ret = wait_for_completion_timeout(&priv->comp, msecs_to_jiffies(50));
>  	disable_irq(irq);
> -	if (ret <= 0) {
> +	if (ret == 0) {

In addition to this, I think ret should be changed to unsigned long.

regards
Philipp

