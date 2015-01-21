Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbbAUSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:44:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45555 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbAUSoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:44:08 -0500
Date: Wed, 21 Jan 2015 18:44:05 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "moinejf@free.fr" <moinejf@free.fr>
Subject: Re: [PATCH v2] drm/i2c: tda998x: Set the CEC I2C address based on
 the slave I2C address.
Message-ID: <20150121184405.GI10762@e106497-lin.cambridge.arm.com>
References: <545C835D.1050008@arm.com>
MIME-Version: 1.0
In-Reply-To: <545C835D.1050008@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 21 Jan 2015 18:44:06.0505 (UTC) FILETIME=[3C3C6D90:01D035AA]
X-MC-Unique: 115012118440600201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 08:31:25AM +0000, Andrew Jackson wrote:
> The I2C address for the TDA9989 and TDA19989 is fixed at 0x34
> but the two LSBs of the TDA19988's address are set by two configuration
> pins on the chip.  Irrespective of the chip, the associated CEC
> peripheral's I2C address is based upon the main I2C address.
> 
> This patch avoids any special handling required to support
> systems that contain multiple TDA19988 devices on the same
> I2C bus.
> 
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Hi Andrew,

What is the status of this patch? Is it going to be pulled by anyone?

Best regards,
Liviu

> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index d476279..eeab17a 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -1255,6 +1255,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  	struct device_node *np = client->dev.of_node;
>  	u32 video;
>  	int rev_lo, rev_hi, ret;
> +	unsigned short cec_addr;
>  
>  	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
>  	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
> @@ -1262,7 +1263,9 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  
>  	priv->current_page = 0xff;
>  	priv->hdmi = client;
> -	priv->cec = i2c_new_dummy(client->adapter, 0x34);
> +	/* CEC I2C address bound to TDA998x I2C addr by configuration pins */
> +	cec_addr = 0x34 + (client->addr & 0x03);
> +	priv->cec = i2c_new_dummy(client->adapter, cec_addr);
>  	if (!priv->cec)
>  		return -ENODEV;
>  
> -- 
> 1.7.1
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

