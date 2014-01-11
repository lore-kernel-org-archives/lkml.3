Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaAKSzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:55:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34575 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751274AbaAKSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:55:17 -0500
Date: Sat, 11 Jan 2014 18:55:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 26/28] drm/i2c: tda998x: code optimization
Message-ID: <20140111185509.GL15937@n2100.arm.linux.org.uk>
References: <20140109120725.0b0f3e55@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120725.0b0f3e55@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:07:25PM +0100, Jean-Francois Moine wrote:
> This patch reduces the number of I2C exchanges by setting many bits in
> one write and removing a useless write.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c   | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 6b4f6d2..d3b3f3a 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -751,10 +751,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  	}
>  
>  	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
> -	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
> +	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |

This patch clearly hasn't even been build tested, so I doubt there's
much point reviewing this or the following patches.  From a quick scan
of the following patches, this never got fixed so the following patches
can't have been build tested either.

Thanks.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
