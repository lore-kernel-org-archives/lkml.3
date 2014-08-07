Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaHGGUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:20:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59790 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbaHGGUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:20:37 -0400
Date: Wed, 6 Aug 2014 23:20:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: cap1106 - allow changing key mapping from
 userspace
Message-ID: <20140807062033.GD651@core.coreip.homeip.net>
References: <20140721012045.GA4395@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721012045.GA4395@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 06:20:49PM -0700, Dmitry Torokhov wrote:
> Wire up support for EVIOC{G|S}KEYCODE to allow users change key mappings
> from userspace.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> 
> Just compiled, not tested.

*ping* Any chance you could give it a try? Thanks!

> 
>  drivers/input/keyboard/cap1106.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
> index f7d7a0d..180b184 100644
> --- a/drivers/input/keyboard/cap1106.c
> +++ b/drivers/input/keyboard/cap1106.c
> @@ -64,7 +64,7 @@ struct cap1106_priv {
>  	struct input_dev *idev;
>  
>  	/* config */
> -	unsigned int keycodes[CAP1106_NUM_CHN];
> +	unsigned short keycodes[CAP1106_NUM_CHN];
>  };
>  
>  static const struct reg_default cap1106_reg_defaults[] = {
> @@ -272,6 +272,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>  	for (i = 0; i < CAP1106_NUM_CHN; i++)
>  		__set_bit(priv->keycodes[i], priv->idev->keybit);
>  
> +	__clear_bit(KEY_RESERVED, priv->idev->keybit);
> +
> +	priv->idev->keycode = priv->keycodes;
> +	priv->idev->keycodesize = sizeof(priv->keycodes[0]);
> +	priv->idev->keycodemax = ARRAY_SIZE(priv->keycodes);
> +
>  	priv->idev->id.vendor = CAP1106_MANUFACTURER_ID;
>  	priv->idev->id.product = CAP1106_PRODUCT_ID;
>  	priv->idev->id.version = rev;
> -- 
> 2.0.0.526.g5318336
> 
> 
> -- 
> Dmitry

-- 
Dmitry
