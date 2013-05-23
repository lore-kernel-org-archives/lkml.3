Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3EWGBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:01:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50588 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3EWGBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:01:32 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 0/9] adding dual instance and usb-phy support for am335x platform
Date: Thu, 23 May 2013 11:31:19 +0530
Message-ID: <1369288888-8614-1-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set series
        - adds dual musb instances support for am335x platform
        - adds phy-dsps-usb driver based on TI's gs70 driver
        - adds DT bindings for am33xx usb-phy
	- removed references to usb-nop-xceiv from musb

has been verified on tree [1]

[1] git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

Ravi Babu (9):
  usb: musb: dsps: enable dual instance support for am33xx platform
  usb: musb: nop: remove unused nop_xceiv_(un)register APIs from glue
  arch: arm: omap3: remove unused usb_nop_xceive register API's
  usb: phy: nop: removing unused usb_nop_xceiv_(un_)register API
  usb: phy: dsps: adding usbphy driver for am33xx platform
  usb: musb: dsps: use usb-phy driver API for phy power on/off
  usb: musb: dsps: use get-usb-phy by phandle for multi instance
  usb: phy: dts: Adding usbphy DT bindings for am33xx
  usb: musb: dsp: remove the usb-phy control acess from platform glue

 arch/arm/boot/dts/am33xx.dtsi        |   17 +++
 arch/arm/mach-omap2/board-omap3evm.c |    3 -
 drivers/usb/musb/am35x.c             |    2 -
 drivers/usb/musb/blackfin.c          |    2 -
 drivers/usb/musb/da8xx.c             |    2 -
 drivers/usb/musb/davinci.c           |    3 -
 drivers/usb/musb/musb_dsps.c         |   85 +++----------
 drivers/usb/musb/tusb6010.c          |    3 -
 drivers/usb/phy/Kconfig              |    9 ++
 drivers/usb/phy/Makefile             |    1 +
 drivers/usb/phy/phy-dsps-usb.c       |  236 ++++++++++++++++++++++++++++++++++
 drivers/usb/phy/phy-nop.c            |   21 ---
 include/linux/usb/nop-usb-xceiv.h    |   14 --
 13 files changed, 282 insertions(+), 116 deletions(-)
 create mode 100644 drivers/usb/phy/phy-dsps-usb.c

