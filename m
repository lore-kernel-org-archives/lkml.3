Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3FKHR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:17:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36568 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab3FKHR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:17:57 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v2 0/7] adding dual instance and usb-phy support for am335x platform
Date: Tue, 11 Jun 2013 12:47:45 +0530
Message-ID: <1370935072-21056-1-git-send-email-ravibabu@ti.com>
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

changes from v1:
	- includes sergei's & felipe comments
	- retain the nop-phy driver API usage for non-DT davinci &
	  other musb platform

Ravi Babu (7):
  usb: musb: dsps: enable dual instance support for am33xx platform
  usb: phy: dsps: adding usbphy driver for am33xx platform
  usb: musb: dsps: remove nop_xceiv_(un)register APIs from dsps glue
  usb: musb: dsps: use usb-phy driver API for phy power on/off
  usb: musb: dsps: use get-usb-phy by phandle for multi instance
  usb: phy: dts: Adding usbphy DT bindings for am33xx
  usb: musb: dsp: remove the usb-phy control acess from platform glue

 arch/arm/boot/dts/am33xx.dtsi  |   17 +++
 drivers/usb/musb/musb_dsps.c   |   85 +++-----------
 drivers/usb/phy/Kconfig        |    9 ++
 drivers/usb/phy/Makefile       |    1 +
 drivers/usb/phy/phy-dsps-usb.c |  236 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 282 insertions(+), 66 deletions(-)
 create mode 100644 drivers/usb/phy/phy-dsps-usb.c

