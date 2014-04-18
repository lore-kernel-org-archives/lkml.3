Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaDRJty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48019 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaDRJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:49:45 -0400
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, boris.brezillon@free-electrons.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Cc: plagnioj@jcrosoft.com, airlied@linux.ie, robdclark@gmail.com,
        linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [RFC 0/3] DRM driver for the ATMEL High end LCD controller
Date: Fri, 18 Apr 2014 11:45:06 +0200
Message-Id: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch serie implements a simple DRM driver for the ATMEL High end LCD
controller found in the SAMA5 familly. It's based on the tilcdc driver.
It uses the cma_helper for memory and fbdev stuff.
Your comments are welcome !


Supported features:
* the base layer (the main framebuffer)
* a simple panel
* a backlight driver
* structure to 'easily' add other connectors (it comes from the tilcdc)

On the todo list:
* support overlays as drm_planes
* support for the hardware cursor
* support for the SiI9022 HDMI connector (present on sama5d36ek)


Jean-Jacques Hiblot (3):
  atmel: drm: added drm driver for the atmel hlcd controller
  atmel: drm: dt: Added DT entry for the atmel hlcdc found in the sama5
  atmel: dt: Add supports for the lcdc support on the sama5d36ek

 arch/arm/boot/dts/sama5d36ek.dts                   |  27 +-
 arch/arm/boot/dts/sama5d3_lcd.dtsi                 |  11 +
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/atmel_hlcdc/Kconfig                |  13 +
 drivers/gpu/drm/atmel_hlcdc/Makefile               |  12 +
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h          | 771 +++++++++++++++++++++
 .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c    |  92 +++
 .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h    |  25 +
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c     | 702 +++++++++++++++++++
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c      | 586 ++++++++++++++++
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h      | 124 ++++
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h      | 190 +++++
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c    | 459 ++++++++++++
 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h    |  28 +
 15 files changed, 3042 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/Kconfig
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/Makefile
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h

--
1.9.1

