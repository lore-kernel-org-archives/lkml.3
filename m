Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaAIM1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:27:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60385 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaAIM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:27:16 -0500
Date: Thu, 9 Jan 2014 12:27:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 24/28] drm/i2c: tda998x: adjust the audio CTS to the
	mode clock
Message-ID: <20140109122708.GB27432@n2100.arm.linux.org.uk>
References: <20140109120702.492c58d8@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109120702.492c58d8@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:07:02PM +0100, Jean-Francois Moine wrote:
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 68630b8..c2163f4 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -723,7 +723,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  		struct drm_display_mode *mode)
>  {
>  	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv;
> -	uint32_t n;
> +	uint32_t n, cts;
>  
>  	/* Enable audio ports */
>  	reg_write(priv, REG_ENA_AP, priv->audio_port);
> @@ -777,9 +777,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  	n = 128 * AUDIO_SAMPLE;		/* acr_n = 128 * sample_rate / 1000 */
>  
>  	/* Write the CTS and N values */
> -	buf[0] = 0x44;
> -	buf[1] = 0x42;
> -	buf[2] = 0x01;
> +	cts = mode->clock;
> +	buf[0] = cts;
> +	buf[1] = cts >> 8;
> +	buf[2] = cts >> 16;

NAK.  We use auto-CTS mode, so the actual programmed CTS value is
entirely irrelevant.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
