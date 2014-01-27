Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaA0UMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:12:40 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50219 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbaA0UMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:12:38 -0500
Date: Mon, 27 Jan 2014 20:12:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 24/24] drm/i2c: tda998x: adjust the audio clock
	divider for S/PDIF
Message-ID: <20140127201231.GY15937@n2100.arm.linux.org.uk>
References: <cover.1390646891.git.moinejf@free.fr> <20140125181436.5c443251@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140125181436.5c443251@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 06:14:36PM +0100, Jean-Francois Moine wrote:
> According to some tests on the Cubox (Marvell Armada 510 + TDA19988),
> the S/PDIF input asks for a greater audio clock divider.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index b4827c0..e4dfcb4 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -679,10 +679,14 @@ tda998x_configure_audio(struct tda998x_priv *priv,
>  	 * There is no detailed info in the datasheet, so we just
>  	 * assume 100MHz requires larger divider.
>  	 */
> +	adiv = AUDIO_DIV_SERCLK_8;
>  	if (mode->clock > 100000)
> -		adiv = AUDIO_DIV_SERCLK_16;
> -	else
> -		adiv = AUDIO_DIV_SERCLK_8;
> +		adiv++;			/* AUDIO_DIV_SERCLK_8 */
> +
> +	/* S/PDIF asks for a larger divider */
> +	if (p->audio_format == AFMT_SPDIF)
> +		adiv++;			/* AUDIO_DIV_SERCLK_16 or _32 */

I'm not sure these comments are quite right... You start off with
adiv at AUDIO_DIV_SERCLK_8, and then you increment it, but the
comment says it's AUDIO_DIV_SERCLK_8 ?  Shouldn't it become
AUDIO_DIV_SERCLK_16 ?

Please review the above change yourself. :)

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
