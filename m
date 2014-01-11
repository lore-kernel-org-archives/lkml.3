Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaAKRF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:05:26 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34280 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751523AbaAKRFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:05:23 -0500
Date: Sat, 11 Jan 2014 17:05:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/28] drm/i2c: tda998x: code cleanup
Message-ID: <20140111170515.GP15937@n2100.arm.linux.org.uk>
References: <20140109115811.779554cb@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140109115811.779554cb@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:58:11AM +0100, Jean-Francois Moine wrote:
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

Again, this needs a proper changelog.  It also needs style fixes:

WARNING: sizeof buf should be sizeof(buf)
#16: FILE: drivers/gpu/drm/i2c/tda998x_drv.c:338:
+	ret = i2c_master_send(client, buf, sizeof buf);

WARNING: sizeof buf should be sizeof(buf)
#35: FILE: drivers/gpu/drm/i2c/tda998x_drv.c:453:
+	ret = i2c_master_send(client, buf, sizeof buf);

WARNING: sizeof buf should be sizeof(buf)
#44: FILE: drivers/gpu/drm/i2c/tda998x_drv.c:469:
+	ret = i2c_master_send(client, buf, sizeof buf);

total: 0 errors, 3 warnings, 49 lines checked

Your patch has style problems, please review.

Hence, it has only been tested.  I'm not giving an acked-by until the
above issues are addressed.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c  | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 603f716..cd7ac58 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -335,7 +335,7 @@ cec_write(struct tda998x_priv *priv, uint16_t addr, uint8_t val)
>  	uint8_t buf[] = {addr, val};
>  	int ret;
>  
> -	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
> +	ret = i2c_master_send(client, buf, sizeof buf);
>  	if (ret < 0)
>  		dev_err(&client->dev, "Error %d writing to cec:0x%x\n", ret, addr);
>  }
> @@ -372,7 +372,8 @@ set_page(struct tda998x_priv *priv, uint16_t reg)
>  		};
>  		int ret = i2c_master_send(client, buf, sizeof(buf));
>  		if (ret < 0) {
> -			dev_err(&client->dev, "Error %d writing to REG_CURPAGE\n", ret);
> +			dev_err(&client->dev, "setpage %04x err %d\n",
> +					reg, ret);
>  			return ret;
>  		}
>  
> @@ -449,7 +450,7 @@ reg_write(struct tda998x_priv *priv, uint16_t reg, uint8_t val)
>  	if (ret < 0)
>  		return;
>  
> -	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
> +	ret = i2c_master_send(client, buf, sizeof buf);
>  	if (ret < 0)
>  		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
>  }
> @@ -465,7 +466,7 @@ reg_write16(struct tda998x_priv *priv, uint16_t reg, uint16_t val)
>  	if (ret < 0)
>  		return;
>  
> -	ret = i2c_master_send(client, buf, ARRAY_SIZE(buf));
> +	ret = i2c_master_send(client, buf, sizeof buf);
>  	if (ret < 0)
>  		dev_err(&client->dev, "Error %d writing to 0x%x\n", ret, reg);
>  }
> @@ -998,7 +999,7 @@ read_edid_block(struct drm_encoder *encoder, uint8_t *buf, int blk)
>  
>  	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, EDID_LENGTH);
>  	if (ret != EDID_LENGTH) {
> -		dev_err(encoder->dev->dev, "failed to read edid block %d: %d",
> +		dev_err(encoder->dev->dev, "failed to read edid block %d: %d\n",
>  				blk, ret);
>  		return ret;
>  	}
> @@ -1012,7 +1013,7 @@ static uint8_t *
>  do_get_edid(struct drm_encoder *encoder)
>  {
>  	struct tda998x_priv *priv = to_tda998x_priv(encoder);
> -	int j = 0, valid_extensions = 0;
> +	int j, valid_extensions = 0;
>  	uint8_t *block, *new;
>  	bool print_bad_edid = drm_debug & DRM_UT_KMS;
>  
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
