Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaAKSoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:44:20 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34561 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751629AbaAKSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:44:19 -0500
Date: Sat, 11 Jan 2014 18:44:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 21/28] drm/i2c: tda998x: use global constants
Message-ID: <20140111184412.GJ15937@n2100.arm.linux.org.uk>
References: <20140109120618.4955853c@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120618.4955853c@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:06:18PM +0100, Jean-Francois Moine wrote:
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c   | 23 +++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 864b9f5..efd29d1 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -132,6 +132,8 @@ struct tda998x_priv {
>  # define VIP_CNTRL_5_CKCASE       (1 << 0)
>  # define VIP_CNTRL_5_SP_CNT(x)    (((x) & 3) << 1)
>  #define REG_MUX_AP                REG(0x00, 0x26)     /* read/write */
> +# define MUX_AP_SELECT_I2S	  0x64
> +# define MUX_AP_SELECT_SPDIF	  0x40
>  #define REG_MUX_VP_VIP_OUT        REG(0x00, 0x27)     /* read/write */
>  #define REG_MAT_CONTRL            REG(0x00, 0x80)     /* write */
>  # define MAT_CONTRL_MAT_SC(x)     (((x) & 3) << 0)
> @@ -212,7 +214,12 @@ struct tda998x_priv {
>  # define AIP_CLKSEL_FS(x)         (((x) & 3) << 0)
>  # define AIP_CLKSEL_CLK_POL(x)    (((x) & 1) << 2)
>  # define AIP_CLKSEL_AIP(x)        (((x) & 7) << 3)
> -
> +#define  SEL_AIP_SPDIF		  0
> +#define  SEL_AIP_I2S		  1

I'd much rather these became:

# define AIP_CLKSEL_AIP_SPDIF     (0 << 3)
# define AIP_CLKSEL_AIP_I2S       (1 << 3)

and kill AIP_CLKSEL_AIP().

> +#define  CLKPOLDSD_ACLK		  0			/* same pol as ACLK */
> +#define  CLKPOLDSD_NACLK	  1			/* inverted */

If this is for AIP_CLKSEL_CLK_POL, this is labelled up in the data I
have as "for internal use" - we should probably remove AIP_CLKSEL_CLK_POL()
from the above definitions.

> +#define  CTSREF_ACLK		  0			/* I2S */
> +#define  CTSREF_FS64SPDIF	  2			/* spdif */

Again, better to define these as:

# define AIP_CLKSEL_FS_ACLK       (0 << 0)
# define AIP_CLKSEL_FS_MCLK       (1 << 0)
# define AIP_CLKSEL_FS_FS64SPDIF  (2 << 0)

and kill AIP_CLKSEL_FS().

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
