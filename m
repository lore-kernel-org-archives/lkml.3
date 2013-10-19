Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3JSWDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:03:35 -0400
Received: from mout.web.de ([212.227.15.3]:49557 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3JSWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:03:33 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [kconfig] update: results of some syntactical checks
Date: Sun, 20 Oct 2013 00:03:30 +0200
Message-ID: <3513955.N5RNgL3hPx@tacticalops>
User-Agent: KMail/4.11.2 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:bk3onQHdFr/fxpDCRIhovmoemTjAwNPuAQTLHyRTvEovR59cQvj
 Q8EfbZcHdT1kEYvjiOGvfJczjQqIWcS5ut3eYaTLUsdpC39CqQ0oalKj0qMIBSe8SLFm2UV
 DZnb3Q+b4p/JRJMbzJr/dT6ihm0+TwrOtF1Kl/yTDikP5o5kUcCI/0HMqWvvZoQMtrAG3QD
 nu2f71U8Prnmiy0rwtxRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update to the syntactic results that I sent, back in July.

With kernel 3.12 nearing completion, I would like to point to new sections
in Kconfig files with potential problems:

drivers/media/common/siano/Kconfig:21-26
> config SMS_SIANO_DEBUGFS
>	bool "Enable debugfs for smsdvb"
>	depends on SMS_SIANO_MDTV
>	depends on DEBUG_FS
>	depends on SMS_USB_DRV
>	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV

The last line adds the dependency CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV.
This expression does not look sound as those two symbols are not declared
anywhere. So, the two strings CONFIG_SMS_USB_DRV and CONFIG_SMS_SDIO_DRV
are compared, yielding always 'n'. As a result, SMS_SIANO_DEBUGFS will never
be enabled.

Probably, it was meant to say something like
>	depends on SMS_USB_DRV = SMS_SDIO_DRV

Two other config sections that probably behave differently than expected:

drivers/staging/rtl8188eu/Kconfig: 13-15
> config 88EU_AP_MODE
>	bool "Realtek RTL8188EU AP mode"
>	default Y

drivers/staging/rtl8188eu/Kconfig: 21-23
> config 88EU_P2P
>	bool "Realtek RTL8188EU Peer-to-peer mode"
>	default Y

The capital Y is different from the lowercase y. While y is an actually
hard coded constant symbol, Y is undeclared and evaluates to n.
The default values are probably only for convenience, so 88EU_AP_MODE and
88EU_P2P are activated together with 8188EU. They still can be turned off.
Anyway, it should probably say "default y" in both cases.


Here the updated full two lists from July:

Actually declared symbols with names of constants: 2
  8260 at
    arch/powerpc/platforms/82xx/Kconfig:55
  8272 at
    arch/powerpc/platforms/82xx/Kconfig:64

Symbols used, but not declared: 34
  Symbol: ARCH_ARM at
    sound/soc/omap/Kconfig:28
    sound/soc/omap/Kconfig:2
  Symbol: ARCH_EFM32 at
    drivers/spi/Kconfig:167
    drivers/tty/serial/Kconfig:1430
  Symbol: ARCH_HI3xxx at
    drivers/dma/Kconfig:313
    arch/arm/Kconfig.debug:184
    arch/arm/Kconfig.debug:192
  Symbol: ARCH_MOXART at
    drivers/net/ethernet/moxa/Kconfig:22
    drivers/net/ethernet/moxa/Kconfig:7
  Symbol: ARCH_MULTI_V4 at
    arch/arm/Kconfig:916
  Symbol: ATHEROS_AR231X at
    drivers/net/wireless/ath/ath5k/Kconfig:56
    drivers/net/wireless/ath/ath5k/Kconfig:63
    drivers/net/wireless/ath/ath5k/Kconfig:9
    drivers/net/wireless/ath/ath5k/Kconfig:8
    drivers/net/wireless/ath/ath5k/Kconfig:2
  Symbol: CONFIG_SMS_SDIO_DRV at
    drivers/media/common/siano/Kconfig:25
  Symbol: CONFIG_SMS_USB_DRV at
    drivers/media/common/siano/Kconfig:25
  Symbol: CPU_MMP3 at
    drivers/video/mmp/hw/Kconfig:4
    drivers/usb/phy/Kconfig:44
    drivers/video/mmp/Kconfig:2
  Symbol: CPU_PXA988 at
    drivers/video/mmp/hw/Kconfig:4
    drivers/video/mmp/Kconfig:2
  Symbol: CPU_SUBTYPE_SH7764 at
    arch/sh/drivers/dma/Kconfig:14
  Symbol: DEPRECATED at
    arch/mn10300/Kconfig.debug:34
  Symbol: EXYNOS_DEV_SYSMMU at
    drivers/iommu/Kconfig:180
  Symbol: GENERIC_HAS_IOMAP at
    arch/score/Kconfig:39
    arch/score/Kconfig:27
    arch/score/Kconfig:33
  Symbol: GENERIC_TIME at
    arch/arm/mach-bcm/Kconfig:11
  Symbol: GPIO_BCM at
    arch/arm/mach-bcm/Kconfig:12
  Symbol: HAVE_GENERIC_HARDIRQS at
    arch/score/Kconfig:5
  Symbol: LOCAL_TIMERS at
    arch/arm/mach-shmobile/Kconfig:6
    arch/arm/mach-omap2/Kconfig:59
    arch/arm/mach-rockchip/Kconfig:10
    arch/arm/mach-rockchip/Kconfig:7
  Symbol: M at
    drivers/usb/host/Kconfig:547
    drivers/usb/misc/Kconfig:130
  Symbol: MACH_NOKIA_RM696 at
    arch/arm/mach-omap2/Kconfig:321
  Symbol: MACH_OMAP_H4_OTG at
    drivers/usb/gadget/Kconfig:207
  Symbol: MACH_SMDKC210 at
    sound/soc/samsung/Kconfig:138
  Symbol: MACH_SMDKV310 at
    sound/soc/samsung/Kconfig:138
  Symbol: MN10300_PROC_MN2WS0038 at
    arch/mn10300/Kconfig:184
  Symbol: MPILIB_EXTRA at
    crypto/asymmetric_keys/Kconfig:24
  Symbol: MV64360 at
    arch/powerpc/Kconfig:419
  Symbol: N at
    drivers/staging/rtl8187se/Kconfig:8
    drivers/staging/bcm/Kconfig:3
    drivers/staging/usbip/Kconfig:31
    arch/cris/arch-v32/drivers/Kconfig:13
    drivers/staging/rtl8712/Kconfig:14
    drivers/usb/host/Kconfig:340
    drivers/staging/rtl8712/Kconfig:6
    drivers/staging/android/Kconfig:61
    drivers/staging/usbip/Kconfig:42
    drivers/staging/usbip/Kconfig:20
    arch/cris/arch-v32/drivers/Kconfig:118
    drivers/usb/host/Kconfig:317
    drivers/staging/android/Kconfig:4
    drivers/staging/frontier/Kconfig:3
    drivers/usb/host/Kconfig:329
    drivers/staging/rtl8192u/Kconfig:7
    arch/arc/Kconfig:356
    drivers/staging/media/go7007/Kconfig:48
    drivers/staging/media/go7007/Kconfig:15
    drivers/usb/core/Kconfig:12
    drivers/staging/rtl8192e/rtl8192e/Kconfig:7
    drivers/staging/usbip/Kconfig:3
    drivers/staging/media/go7007/Kconfig:26
    drivers/staging/rtl8188eu/Kconfig:5
  Symbol: OF_I2C at
    drivers/i2c/busses/Kconfig:377
  Symbol: OMAP_PM_SRF at
    drivers/staging/tidspbridge/Kconfig:19
  Symbol: PICOXCELL_PC3X3 at
    drivers/char/hw_random/Kconfig:242
  Symbol: PLATFORM_MICROBLAZE_AUTO at
    arch/microblaze/platform/Kconfig.platform:10
  Symbol: PLAT_SPEAR_SINGLE at
    arch/arm/mach-spear/Kconfig:84
    arch/arm/mach-spear/Kconfig:99
    arch/arm/mach-spear/Kconfig:6
    arch/arm/mach-spear/Kconfig:51
    arch/arm/mach-spear/Kconfig:19
  Symbol: RCAR_CLK_ADG at
    sound/soc/sh/Kconfig:40
  Symbol: Y at
    drivers/staging/rtl8188eu/Kconfig:14
    drivers/staging/rtl8188eu/Kconfig:22
-- 

