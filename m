Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaIUKGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 06:06:34 -0400
Received: from svenfoo.org ([82.94.215.22]:33443 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaIUKGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 06:06:32 -0400
Message-ID: <541EA326.1070404@zonque.org>
Date: Sun, 21 Sep 2014 12:06:30 +0200
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Matt Ranostay <mranostay@gmail.com>, galak@codeaurora.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] cap1106: support for active-high interrupt option
References: <1411268469-21283-1-git-send-email-mranostay@gmail.com> <1411268469-21283-3-git-send-email-mranostay@gmail.com>
In-Reply-To: <1411268469-21283-3-git-send-email-mranostay@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2014 05:01 AM, Matt Ranostay wrote:
> Some applications need to use the active-high push-pull interrupt
> option. This allows it be enabled in the device tree child node.
> 
> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
> ---
>  drivers/input/keyboard/cap1106.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/input/keyboard/cap1106.c b/drivers/input/keyboard/cap1106.c
> index b9c43b5..33e2590 100644
> --- a/drivers/input/keyboard/cap1106.c
> +++ b/drivers/input/keyboard/cap1106.c
> @@ -234,6 +234,12 @@ static int cap1106_i2c_probe(struct i2c_client *i2c_client,
>  			dev_err(dev, "Invalid sensor-gain value %d\n", gain32);
>  	}
>  
> +	if (of_property_read_bool(node, "microchip,active-high")) {

I think the name of that property should make clear it's only changing
the interrupt output driver configuration. What about
"microchip,irq-active-high"?

Also, patch 3/3, which documents this new property, can be squashed into
this one.

> +		error = regmap_write(priv->regmap, CAP1106_REG_CONFIG2, 0);

This register controls a lot more details than that. Overriding it with
0 doesn't seem right. Please use regmap_update_bits() to just update
ALT_POL, and also add a #define for it, so the next reader knows what
the code is doing :)


Thanks,
Daniel

