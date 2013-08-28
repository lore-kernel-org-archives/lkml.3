Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3H1Rdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:33:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49010 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3H1Rdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:33:38 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/3] Add Generic USB VBUS/ID detection via GPIO using extcon
Date: Wed, 28 Aug 2013 23:03:02 +0530
Message-ID: <1377711185-31238-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add generic support for USB VBUS/ID pin detection using extcon framework.
The USB ID pin on DRA7xx is connected via the gpio expander pcf8575.
The interrupt line of the same is connected to the gpio 11 of bank 6.
The following driver relies on  the  gpio interrupt to notify the actual
ID pin values by which the dwc3 driver determines the HOST/Peripheral roles.


These patches are on top of following merges.
v3.11-rc3 dra7 baseport tree [1] , with balbi/next ,control-usb multi instance support [2],
chanwoo/extcon-next, roger's patches for USB host adaptation[3],Laurent Pinchart's patch to
Enable pcf857x GPIO expander for Device Tree[4] and pcf857x cleanup patch [5].

Patches are available at
extcon_gpio_usbvid-v1
in git tree
git://git.ti.com/~georgecherian/ti-linux-kernel/georgec-connectivity-linux-feature-tree.git

[1] - dra7 base tree
        https://github.com/lokeshvutla/linux/tree/dra7-3.11-rc3-base
[2] - multiple control-usb instances
        https://github.com/rogerq/linux/tree/usb-control-module
[3] - [PATCH 0/4] ARM: DRA7-evm: USB host adaptation
        https://lkml.org/lkml/2013/8/1/335
[4] - [PATCH v5] gpio: pcf857x: Add OF support
        https://lkml.org/lkml/2013/8/27/70
[5] - [PATCH] gpio: pcf857x: cleanup irq_demux_work and use threaded irq
        https://lkml.org/lkml/2013/8/27/207

George Cherian (3):
  extcon: extcon-gpio-usbvid: Generic USB VBUS/ID detection via GPIO
  drivers: Makefile: Extcon is a framework so bump it up
  ARM: dts: dra7-evm: Add extcon nodes for USB ID pin detection

 .../bindings/extcon/extcon-gpio-usbvid.txt         |  20 ++
 arch/arm/boot/dts/dra7-evm.dts                     |  50 +++-
 drivers/Makefile                                   |   2 +-
 drivers/extcon/Kconfig                             |   6 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-gpio-usbvid.c                | 286 +++++++++++++++++++++
 6 files changed, 363 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
 create mode 100644 drivers/extcon/extcon-gpio-usbvid.c

-- 
1.8.1.4

