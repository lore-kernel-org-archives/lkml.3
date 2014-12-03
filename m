Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLCPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:45:46 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35846 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750980AbaLCPpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:45:45 -0500
Date: Wed, 3 Dec 2014 15:45:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        vladimir_zapolskiy@mentor.com, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v16 05/12] drm: imx: imx-hdmi: move imx-hdmi to
 bridge/dw_hdmi
Message-ID: <20141203154503.GD11285@n2100.arm.linux.org.uk>
References: <1417620408-30354-1-git-send-email-andy.yan@rock-chips.com>
 <1417620732-30593-1-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417620732-30593-1-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:32:12PM +0800, Andy Yan wrote:
> diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
> index 884923f..26162ef 100644
> --- a/drivers/gpu/drm/bridge/Kconfig
> +++ b/drivers/gpu/drm/bridge/Kconfig
> @@ -3,3 +3,8 @@ config DRM_PTN3460
>  	depends on DRM
>  	select DRM_KMS_HELPER
>  	---help---
> +
> +config DRM_DW_HDMI
> +	bool "Synopsys DesignWare High-Definition Multimedia Interface"
> +	depends on DRM
> +	select DRM_KMS_HELPER
...
> diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
> index 82fb758..7070077 100644
> --- a/drivers/gpu/drm/imx/Kconfig
> +++ b/drivers/gpu/drm/imx/Kconfig
> @@ -48,6 +48,7 @@ config DRM_IMX_IPUV3
>  
>  config DRM_IMX_HDMI
>  	tristate "Freescale i.MX DRM HDMI"
> +	select DRM_DW_HDMI
>  	depends on DRM_IMX
>  	help
>  	  Choose this if you want to use HDMI on i.MX6.

I'd recommend that if you want to select DRM_DW_HDMI, then don't give
DRM_DW_HDMI a prompt message.  I assume you're going to do something
similar with your Rockchip driver too - in which case DRM_DW_HDMI is
really about building a library module.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
