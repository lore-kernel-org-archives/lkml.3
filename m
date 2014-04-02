Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaDBFpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:45:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaDBFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:45:54 -0400
Date: Wed, 2 Apr 2014 07:45:49 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 3/3] pwm: imx: support output polarity inversion
Message-ID: <20140402054549.GW17250@pengutronix.de>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-4-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395996540-10999-4-git-send-email-LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:41:42 up 220 days, 15:12, 53 users,  load average: 0.14, 0.16,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lothar,

On Fri, Mar 28, 2014 at 09:49:00AM +0100, Lothar Waßmann wrote:
>  static struct pwm_ops imx_pwm_ops = {
>  	.enable = imx_pwm_enable,
>  	.disable = imx_pwm_disable,
> @@ -210,6 +228,7 @@ struct imx_pwm_data {
>  	int (*config)(struct pwm_chip *chip,
>  		struct pwm_device *pwm, int duty_ns, int period_ns);
>  	void (*set_enable)(struct pwm_chip *chip, bool enable);
> +	unsigned output_polarity:1;
>  };
>  
>  static struct imx_pwm_data imx_pwm_data_v1 = {
> @@ -220,6 +239,7 @@ static struct imx_pwm_data imx_pwm_data_v1 = {
>  static struct imx_pwm_data imx_pwm_data_v2 = {
>  	.config = imx_pwm_config_v2,
>  	.set_enable = imx_pwm_set_enable_v2,
> +	.output_polarity = 1,
>  };
>  
>  static const struct of_device_id imx_pwm_dt_ids[] = {
> @@ -272,6 +292,11 @@ static int imx_pwm_probe(struct platform_device *pdev)
>  		return PTR_ERR(imx->mmio_base);
>  
>  	data = of_id->data;
> +	if (data->output_polarity) {
> +		dev_dbg(&pdev->dev, "PWM supports output inversion\n");
> +		imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
> +	}

You shouldn't modify imx_pwm_ops in the probe function, it's not good
style and prevents us from making the ops const.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
