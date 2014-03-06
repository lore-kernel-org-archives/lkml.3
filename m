Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaCFKXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:23:37 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63795 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbaCFKXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:23:31 -0500
Message-ID: <1394101408.4592.19.camel@x220>
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Date: Thu, 06 Mar 2014 11:23:28 +0100
In-Reply-To: <20140306044529.GA6466@kroah.com>
References: <1391958577.25424.22.camel@x220> <3099833.ZhlQFyxhbo@avalon>
	 <1394065683.12070.32.camel@joe-AO722> <2136780.FIdBGb725A@avalon>
	 <20140306044529.GA6466@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2014 10:23:29.0856 (UTC) FILETIME=[1E65C400:01CF3926]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 20:45 -0800, Greg Kroah-Hartman wrote:
> On Thu, Mar 06, 2014 at 01:48:29AM +0100, Laurent Pinchart wrote:
> > Would you recommend to drop driver-specific Kconfig options related to 
> > debugging and use CONFIG_DYNAMIC_DEBUG instead ?
> 
> Yes, please do that, no one wants to rebuild drivers and subsystems with
> different options just for debugging.

There are 50+ cases of Kconfig options setting the DEBUG flag, so there
might be room for a series to remove some of those. (Note that Joe says
there are valid reasons to use a Kconfig option to set this flag, if I'm
not misunderstanding Joe.) For what it's worth, I've added the list of
these (for v3.14-rc5) below.


Paul Bolle

v3.14-rc5:arch/powerpc/platforms/pseries/Makefile:ccflags-$(CONFIG_PPC_PSERIES_DEBUG)	+= -DDEBUG
v3.14-rc5:drivers/base/Makefile:ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
v3.14-rc5:drivers/base/power/Makefile:ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
v3.14-rc5:drivers/bcma/Makefile:ccflags-$(CONFIG_BCMA_DEBUG)		:= -DDEBUG
v3.14-rc5:drivers/dma/Makefile:ccflags-$(CONFIG_DMADEVICES_DEBUG)  := -DDEBUG
v3.14-rc5:drivers/gpio/Makefile:ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
v3.14-rc5:drivers/gpu/drm/tegra/Makefile:ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
v3.14-rc5:drivers/hwmon/Makefile:ccflags-$(CONFIG_HWMON_DEBUG_CHIP) := -DDEBUG
v3.14-rc5:drivers/i2c/Makefile:ccflags-$(CONFIG_I2C_DEBUG_CORE) := -DDEBUG
v3.14-rc5:drivers/i2c/algos/Makefile:ccflags-$(CONFIG_I2C_DEBUG_ALGO) := -DDEBUG
v3.14-rc5:drivers/i2c/busses/Makefile:ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
v3.14-rc5:drivers/i2c/muxes/Makefile:ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
v3.14-rc5:drivers/infiniband/hw/amso1100/Kbuild:ccflags-$(CONFIG_INFINIBAND_AMSO1100_DEBUG) := -DDEBUG
v3.14-rc5:drivers/infiniband/hw/cxgb3/Makefile:ccflags-$(CONFIG_INFINIBAND_CXGB3_DEBUG) += -DDEBUG
v3.14-rc5:drivers/media/platform/omap3isp/Makefile:ccflags-$(CONFIG_VIDEO_OMAP3_DEBUG) += -DDEBUG
v3.14-rc5:drivers/media/platform/ti-vpe/Makefile:ccflags-$(CONFIG_VIDEO_TI_VPE_DEBUG) += -DDEBUG
v3.14-rc5:drivers/memstick/Makefile:subdir-ccflags-$(CONFIG_MEMSTICK_DEBUG) := -DDEBUG
v3.14-rc5:drivers/misc/cb710/Makefile:ccflags-$(CONFIG_CB710_DEBUG)	:= -DDEBUG
v3.14-rc5:drivers/misc/sgi-gru/Makefile:ccflags-$(CONFIG_SGI_GRU_DEBUG)	:= -DDEBUG
v3.14-rc5:drivers/mmc/Makefile:subdir-ccflags-$(CONFIG_MMC_DEBUG) := -DDEBUG
v3.14-rc5:drivers/net/caif/Makefile:ccflags-$(CONFIG_CAIF_DEBUG) := -DDEBUG
v3.14-rc5:drivers/net/can/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/c_can/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/cc770/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/mscan/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/sja1000/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/softing/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/can/usb/Makefile:ccflags-$(CONFIG_CAN_DEBUG_DEVICES) := -DDEBUG
v3.14-rc5:drivers/net/ethernet/dec/tulip/Makefile:ccflags-$(CONFIG_NET_TULIP)	:= -DDEBUG
v3.14-rc5:drivers/net/wireless/brcm80211/Makefile:subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DDEBUG
v3.14-rc5:drivers/net/wireless/zd1211rw/Makefile:ccflags-$(CONFIG_ZD1211RW_DEBUG) := -DDEBUG
v3.14-rc5:drivers/nfc/Makefile:ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
v3.14-rc5:drivers/pci/Makefile:ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
v3.14-rc5:drivers/pinctrl/Makefile:ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
v3.14-rc5:drivers/power/Makefile:ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
v3.14-rc5:drivers/pps/Makefile:ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
v3.14-rc5:drivers/pps/clients/Makefile:ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
v3.14-rc5:drivers/rapidio/Makefile:subdir-ccflags-$(CONFIG_RAPIDIO_DEBUG) := -DDEBUG
v3.14-rc5:drivers/regulator/Makefile:ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
v3.14-rc5:drivers/rtc/Makefile:ccflags-$(CONFIG_RTC_DEBUG)	:= -DDEBUG
v3.14-rc5:drivers/spi/Makefile:ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
v3.14-rc5:drivers/staging/comedi/Makefile:ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
v3.14-rc5:drivers/staging/comedi/drivers/Makefile:ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
v3.14-rc5:drivers/staging/comedi/kcomedilib/Makefile:ccflags-$(CONFIG_COMEDI_DEBUG)		:= -DDEBUG
v3.14-rc5:drivers/staging/usbip/Makefile:ccflags-$(CONFIG_USBIP_DEBUG) := -DDEBUG
v3.14-rc5:drivers/usb/chipidea/Makefile:ccflags-$(CONFIG_USB_CHIPIDEA_DEBUG) := -DDEBUG
v3.14-rc5:drivers/usb/dwc2/Makefile:ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
v3.14-rc5:drivers/usb/dwc3/Makefile:ccflags-$(CONFIG_USB_DWC3_DEBUG)	:= -DDEBUG
v3.14-rc5:drivers/usb/gadget/Makefile:ccflags-$(CONFIG_USB_GADGET_DEBUG)	:= -DDEBUG
v3.14-rc5:drivers/usb/wusbcore/Makefile:ccflags-$(CONFIG_USB_WUSB_CBAF_DEBUG) := -DDEBUG
v3.14-rc5:drivers/video/intelfb/Makefile:ccflags-$(CONFIG_FB_INTEL_DEBUG) := -DDEBUG -DREGDUMP
v3.14-rc5:drivers/video/omap2/dss/Makefile:ccflags-$(CONFIG_OMAP2_DSS_DEBUG) += -DDEBUG
v3.14-rc5:fs/ntfs/Makefile:ccflags-$(CONFIG_NTFS_DEBUG)	+= -DDEBUG
v3.14-rc5:kernel/power/Makefile:ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
v3.14-rc5:net/caif/Makefile:ccflags-$(CONFIG_CAIF_DEBUG)     :=      -DDEBUG
v3.14-rc5:net/rds/Makefile:ccflags-$(CONFIG_RDS_DEBUG)	:=	-DDEBUG

