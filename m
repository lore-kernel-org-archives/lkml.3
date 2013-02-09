Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab3BIO1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:27:15 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36611 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab3BIO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:27:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpio: mcp23s08: Allow -1 as a legal value for global gpio base
To: Lars Poeschel <larsi@wh2.tu-dresden.de>, poeschel@lemonage.de,
        rob.herring@calxeda.com, rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
In-Reply-To: <1360170118-11937-2-git-send-email-larsi@wh2.tu-dresden.de>
References: <1360170118-11937-1-git-send-email-larsi@wh2.tu-dresden.de> <1360170118-11937-2-git-send-email-larsi@wh2.tu-dresden.de>
Date: Sat, 09 Feb 2013 14:27:08 +0000
Message-Id: <20130209142708.8E9AC3E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Feb 2013 18:01:57 +0100, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> Explicitly allow -1 as a legal value for the
> mcp23s08_platform_data->base. This is the special value lets the
> kernel choose a valid global gpio base number.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  drivers/gpio/gpio-mcp23s08.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 3cea0ea..2afb828 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -483,7 +483,7 @@ static int mcp230xx_probe(struct i2c_client *client,
>  	int status;
>  
>  	pdata = client->dev.platform_data;
> -	if (!pdata || !gpio_is_valid(pdata->base)) {
> +	if ((!pdata || !gpio_is_valid(pdata->base)) && pdata->base != -1) {
>  		dev_dbg(&client->dev, "invalid or missing platform data\n");
>  		return -EINVAL;

When used with the device tree you shouldn't have a platform data
pointer at all. Instead you should modify the driver to not require it.

g.

