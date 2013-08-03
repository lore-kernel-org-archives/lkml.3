Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3HCMkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:40:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40041 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3HCMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:40:12 -0400
Date: Sat, 3 Aug 2013 13:39:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
Message-ID: <20130803123954.GX23006@n2100.arm.linux.org.uk>
References: <20130731081739.76aae84c@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731081739.76aae84c@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 08:17:39AM +0200, Jean-Francois Moine wrote:
> @@ -519,30 +532,17 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
>  
>  	err = snd_soc_register_component(&pdev->dev, &kirkwood_i2s_component,
>  					 soc_dai, 1);
> -	if (!err)
> -		return 0;
> -	dev_err(&pdev->dev, "snd_soc_register_component failed\n");
> -
> -	if (!IS_ERR(priv->extclk))
> -		clk_disable_unprepare(priv->extclk);
> -	clk_disable_unprepare(priv->clk);
> +	if (err) {
> +		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
> +		goto fail;
> +	}
> +	return 0;

This doesn't apply to mainline as there's a clk_put() there.
