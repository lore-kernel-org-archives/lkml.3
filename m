Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaAKS0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:26:12 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34528 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaAKS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:26:10 -0500
Date: Sat, 11 Jan 2014 18:26:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 17/28] drm/i2c: tda998x: set the repeat PLL value in
	range 0..3
Message-ID: <20140111182602.GF15937@n2100.arm.linux.org.uk>
References: <20140109120513.0965ddad@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120513.0965ddad@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:05:13PM +0100, Jean-Francois Moine wrote:
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index f60aef9..8a7d8a2 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -220,7 +220,7 @@ struct tda998x_priv {
>  # define PLL_SERIAL_1_SRL_IZ(x)   (((x) & 3) << 1)
>  # define PLL_SERIAL_1_SRL_MAN_IZ  (1 << 6)
>  #define REG_PLL_SERIAL_2          REG(0x02, 0x01)     /* read/write */
> -# define PLL_SERIAL_2_SRL_NOSC(x) (((x) & 3) << 0)
> +# define PLL_SERIAL_2_SRL_NOSC(x) ((x) << 0)
>  # define PLL_SERIAL_2_SRL_PR(x)   (((x) & 0xf) << 4)
>  #define REG_PLL_SERIAL_3          REG(0x02, 0x02)     /* read/write */
>  # define PLL_SERIAL_3_SRL_CCIR    (1 << 0)
> @@ -972,6 +972,11 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  	}
>  
>  	div = 148500 / mode->clock;
> +	if (div != 0) {
> +		div--;
> +		if (div > 3)
> +			div = 3;
> +	}

As the driver currently stands, we know that the clock divider works for
the lower resolution modes.  So, as things stand, for 74.25MHz modes,
we get a divisor of one.

Your patch changes this, the divider becomes zero.  I wonder whether
you've tested 720p modes at all with this?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
