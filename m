Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502Ab3GSMez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:34:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48928 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3GSMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:34:53 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <kishon@ti.com>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 0/4] Add phy support for AM335X platform using Generic PHy framework
Date: Fri, 19 Jul 2013 18:04:33 +0530
Message-ID: <1374237277-17769-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds phy support for AM335X platform.
This patch series is based on Generic PHY framework [1].


This series has
        - adds dual musb instances support for am335x platform 
        - adds phy-amxxxx-usb driver used in AMxxxx platforms
	- adds OTG callbacks
	- adds PHY wakeup enable/disable
        - adds dt  bindings for the phys
        - removes usb-phy and replaced with generic phy apis in glue layer

All these changes are avilable at [2]

[1] - http://marc.info/?l=linux-usb&m=137224750928570&w=2
[2] - git://git.ti.com/~georgecherian/ti-linux-kernel/georgec-connectivity-linux-feature-tree.git
        am335x-phy-driver-v2

George Cherian (4):
  usb: phy: phy-omap-control: Add API to power and wakeup
  phy: phy-amxxxx-usb: Add PHY driver for amxxxx platform
  arm: dts: Add USB phy nodes for AM33XX
  usb: musb: dsps: Remove the phy control from glue and add phy driver
    APIs

 arch/arm/boot/dts/am33xx.dtsi        |  68 ++++++++---
 drivers/phy/Kconfig                  |  12 ++
 drivers/phy/Makefile                 |   1 +
 drivers/phy/phy-amxxxx-usb.c         | 222 +++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_dsps.c         | 150 +++++++++--------------
 drivers/usb/phy/phy-omap-control.c   |  67 +++++++++++
 include/linux/usb/omap_control_usb.h |  24 ++++
 7 files changed, 434 insertions(+), 110 deletions(-)
 create mode 100644 drivers/phy/phy-amxxxx-usb.c

-- 
1.8.1.4

