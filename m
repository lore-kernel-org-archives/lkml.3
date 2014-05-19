Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaESFdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:33:42 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52871 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaESFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:33:40 -0400
Date: Sun, 18 May 2014 22:33:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/5] Input: tsc2005: use dev_err for error messages
Message-ID: <20140519053337.GA29386@core.coreip.homeip.net>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <1398470179-20880-3-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398470179-20880-3-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 01:56:16AM +0200, Sebastian Reichel wrote:
> Change some dev_dbg() invocations to dev_err() ones, because they
> are supposed to output error messages.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Applied, thank you.

> ---
>  drivers/input/touchscreen/tsc2005.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
> index 550adcb..520e673 100644
> --- a/drivers/input/touchscreen/tsc2005.c
> +++ b/drivers/input/touchscreen/tsc2005.c
> @@ -579,7 +579,7 @@ static int tsc2005_probe(struct spi_device *spi)
>  	int error;
>  
>  	if (!pdata) {
> -		dev_dbg(&spi->dev, "no platform data\n");
> +		dev_err(&spi->dev, "no platform data\n");
>  		return -ENODEV;
>  	}
>  
> @@ -591,7 +591,7 @@ static int tsc2005_probe(struct spi_device *spi)
>  	max_p	= pdata->ts_pressure_max   ? : MAX_12BIT;
>  
>  	if (spi->irq <= 0) {
> -		dev_dbg(&spi->dev, "no irq\n");
> +		dev_err(&spi->dev, "no irq\n");
>  		return -ENODEV;
>  	}
>  
> -- 
> 1.9.2
> 

-- 
Dmitry
