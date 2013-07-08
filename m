Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3GHKnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:43:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49528 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3GHKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:43:44 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/5] Add phy support for AM335X platform using Generic PHy framework
Date: Mon, 8 Jul 2013 16:13:16 +0530
Message-ID: <1373280201-31785-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds phy support for AM335X platform.
This patch series is based on Generic PHY framework [1]. 


This series has
	- adds dual musb instances support for am335x platform (just for testing)
	- adds phy-amxxxx-usb driver used in AMxxxx platforms
	- adds dt  bindings for the phys
	- removes usb-phy and replaced with generic phy apis in glue layer

All these changes are avilable at [2]

[1] - http://marc.info/?l=linux-usb&m=137224750928570&w=2
[2] - git://git.ti.com/~georgecherian/ti-linux-kernel/georgec-connectivity-linux-feature-tree.git 
	am335x-phy-driver

George Cherian (4):
  usb: phy: phy-omap-control: Add API to power on/off USB PHY for AM335X
  phy: phy-amxxxx-usb: Add PHY driver for amxxxx platform
  arm: dts: Add USB phy nodes for AM33XX
  usb: musb: dsps: Remove the phy control from glue and add phy driver
    APIs

Ravi Babu (1):
  usb: musb: dsps: enable dual instance support for am33xx platform

 arch/arm/boot/dts/am33xx.dtsi        |  22 ++++
 drivers/phy/Kconfig                  |  12 +++
 drivers/phy/Makefile                 |   1 +
 drivers/phy/phy-amxxxx-usb.c         | 201 +++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_dsps.c         | 107 +++++++------------
 drivers/usb/phy/phy-omap-control.c   |  32 ++++++
 include/linux/usb/omap_control_usb.h |  11 ++
 7 files changed, 316 insertions(+), 70 deletions(-)
 create mode 100644 drivers/phy/phy-amxxxx-usb.c

-- 
1.8.1.4

