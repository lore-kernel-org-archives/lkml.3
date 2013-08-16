Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3HPKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:14:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45476 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3HPKOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:14:18 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/2] Enable USB ID pin detection using extcon for DRA7xx
Date: Fri, 16 Aug 2013 15:43:47 +0530
Message-ID: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add support for USB ID pin detection using extcon framework. 
The ID pin on DRA7xx is connected via the gpio expander pcf8575. 
The interrupt line of the same is connected to the gpio 11 of bank 6. 
The following driver relies on  the  gpio interrupt to notify the actual 
ID pin values by which the dwc3 driver determines the HOST/Peripheral roles.

Optionally a polling method is also available if the gpio interrupts 
are not used on boards.

These patches are on top of following merges.
v3.11-rc3 dra7 baseport tree [1] , with balbi/next ,control-usb multi instance support [2],
chanwoo/extcon-next, roger's patches for USB host adaptation[3] and Archit's patch to 
Enable pcf857x GPIO expander for Device Tree[4].

Patches are available at 
extcon_dra7xx-v2
in git tree
git://git.ti.com/~georgecherian/ti-linux-kernel/georgec-connectivity-linux-feature-tree.git 

[1] - dra7 base tree
	https://github.com/lokeshvutla/linux/tree/dra7-3.11-rc3-base
[2] - multiple control-usb instances
	https://github.com/rogerq/linux/tree/usb-control-module
[3] - [PATCH 0/4] ARM: DRA7-evm: USB host adaptation
	https://lkml.org/lkml/2013/8/1/335
[4] - [PATCH] gpio: Enable pcf857x GPIO expander for Device Tree
 	https://lkml.org/lkml/2013/6/6/333


George Cherian (2):
  extcon: extcon-dra7xx: Add extcon driver for USB ID detection
  arm: dts: dra7-evm: Add extcon dt nodes for USB ID detection

 .../devicetree/bindings/extcon/extcon-dra7xx.txt   |  19 ++
 arch/arm/boot/dts/dra7-evm.dts                     |  42 +++-
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-dra7xx.c                     | 234 +++++++++++++++++++++
 5 files changed, 302 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
 create mode 100644 drivers/extcon/extcon-dra7xx.c

-- 
1.8.1.4

