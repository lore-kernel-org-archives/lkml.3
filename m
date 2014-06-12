Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbaFLJrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:47:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55440 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933001AbaFLJrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:47:48 -0400
Date: Thu, 12 Jun 2014 10:47:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig fails: big select-based circular dependency
Message-ID: <20140612094745.GD23430@n2100.arm.linux.org.uk>
References: <20140607090944.GL23430@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140607090944.GL23430@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

This causes randconfig and all*config to fail without building
anything.

If no one responds, I'll assume that no one is interested, and I'll
just create a pile of patches removing a bunch of these idiotic select
statements at random to break this loop.

On Sat, Jun 07, 2014 at 10:09:44AM +0100, Russell King - ARM Linux wrote:
> This is getting silly:
> 
> scripts/kconfig/conf --silentoldconfig Kconfig
> drivers/dma/Kconfig:5:error: recursive dependency detected!
> drivers/dma/Kconfig:5:  symbol DMADEVICES is selected by SAMSUNG_DMADEV
> arch/arm/plat-samsung/Kconfig:412:      symbol SAMSUNG_DMADEV is selected by S3C64XX_PL080
> arch/arm/mach-s3c64xx/Kconfig:20:       symbol S3C64XX_PL080 is selected by SPI_S3C64XX
> drivers/spi/Kconfig:429:        symbol SPI_S3C64XX depends on SPI
> drivers/spi/Kconfig:8:  symbol SPI is selected by DRM_PANEL_LD9040
> drivers/gpu/drm/panel/Kconfig:19:       symbol DRM_PANEL_LD9040 depends on DRM_PANEL
> drivers/gpu/drm/panel/Kconfig:1:        symbol DRM_PANEL is selected by DRM_IMX_LDB
> drivers/staging/imx-drm/Kconfig:35:     symbol DRM_IMX_LDB depends on MFD_SYSCON
> drivers/mfd/Kconfig:722:        symbol MFD_SYSCON is selected by POWER_RESET_KEYSTONE
> drivers/power/reset/Kconfig:76: symbol POWER_RESET_KEYSTONE depends on POWER_SUPPLY
> drivers/power/Kconfig:1:        symbol POWER_SUPPLY is selected by HID_SONY
> drivers/hid/Kconfig:622:        symbol HID_SONY depends on NEW_LEDS
> drivers/leds/Kconfig:8: symbol NEW_LEDS is selected by BACKLIGHT_ADP8860
> drivers/video/backlight/Kconfig:327:    symbol BACKLIGHT_ADP8860 depends on BACKLIGHT_CLASS_DEVICE
> drivers/video/backlight/Kconfig:156:    symbol BACKLIGHT_CLASS_DEVICE is selected by FB_MX3
> drivers/video/fbdev/Kconfig:2333:       symbol FB_MX3 depends on MX3_IPU
> drivers/dma/Kconfig:121:        symbol MX3_IPU depends on DMADEVICES
> 
> This is a good illustration why the select disease is truely bad...
> 
> -- 
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
