Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaAKSiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:38:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34552 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751466AbaAKSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:38:22 -0500
Date: Sat, 11 Jan 2014 18:38:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 9/28] drm/i2c: tda998x: don't read write-only
	registers
Message-ID: <20140111183817.GI15937@n2100.arm.linux.org.uk>
References: <20140109115941.30e67a37@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115941.30e67a37@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:59:41AM +0100, Jean-Francois Moine wrote:
> @@ -936,10 +926,22 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
>  	/* must be last register set: */
>  	reg_clear(priv, REG_TBG_CNTRL_0, TBG_CNTRL_0_SYNC_ONCE);
>  
> +	/*
> +	 * Always generate sync polarity relative to input sync and
> +	 * revert input stage toggled sync at output stage
> +	 */
> +	reg = TBG_CNTRL_1_DWIN_DIS | TBG_CNTRL_1_TGL_EN;
> +	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
> +		reg |= TBG_CNTRL_1_H_TGL;
> +	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
> +		reg |= TBG_CNTRL_1_V_TGL;
> +	reg_write(priv, REG_TBG_CNTRL_1, reg);
> +

I now NAK this patch, as it messes up the register writing order.  See
the comment in the context line above.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
