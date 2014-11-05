Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaKEOVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:21:53 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54149 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754906AbaKEOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:21:48 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>
Subject: [PATCH v3 0/3] Add Reset Controller for MediaTek SoC 
Date: Wed, 5 Nov 2014 22:21:29 +0800
Message-ID: <1415197292-10546-1-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The patch is based on https://lkml.org/lkml/2014/5/27/422

Changes since v2
================
- Correct #size-cell to be 1.
- Add header file "mt8135-resets.h" for supported resets in MT8135.

Changes since v1
================
(1) Patch 1/3: Update reset controller driver's implementation. 
  - rename mt_ prefixes to the prefix mtk_
  - use module_platform_driver() macro for driver init.
  - clean up includes of header files.
  - reset controll is a child of syscon. Get regamp through its parent node.
  - rename data->size to data->num_regs. It is number of registers in syscon for reset usage. 
(2) Patch 2/3: update bindings document according to new dts layout of reset-controller. 
(3) Patch 3/3: change reset-controller device node as child of syscon. 


This driver is based on 3.18-rc1.

Flora Fu (3):
  ARM: mediatek: Add Reset Controller for MediaTek SoC
  dt-bindings: Add Reset Controller for MediaTek SoC
  ARM: dts: mt8135: Add Reset Controller for MediaTek SoC

 .../devicetree/bindings/reset/mediatek,reset.txt   |  50 ++++++++
 arch/arm/boot/dts/mt8135.dtsi                      |  27 +++++
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-mtk.c                          | 131 +++++++++++++++++++++
 .../dt-bindings/reset-controller/mt8135-resets.h   |  64 ++++++++++
 5 files changed, 273 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/mediatek,reset.txt
 create mode 100644 drivers/reset/reset-mtk.c
 create mode 100644 include/dt-bindings/reset-controller/mt8135-resets.h

--
1.8.1.1.dirty



