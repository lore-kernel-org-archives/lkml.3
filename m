Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaAHOaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:30:07 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:34477 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756862AbaAHOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:30:05 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash Controller support
Date: Wed,  8 Jan 2014 15:21:55 +0100
Message-Id: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 6859263707980396733
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series add the sunxi NFC support with up to 8 NAND chip connected.
I'm still in the early stages drivers development and some key features are
missing, but it's usable (I tested it on the cubietruck board).

Here's what's missing:
 - HW ECC support
 - DMA support
 - HW randomization support
 - many more improvements

This series depends on Emilio's patch series implementing mod0 clks
(http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/185478.html)
+ an other patch not yet posted
(http://git.elopez.com.ar/linux/commits/5b4eb3ac406b9c98965714d40e8dd6da943d1ab0)


Best Regards,

Boris

Boris BREZILLON (9):
  mtd: nand: retrieve ECC requirements from Hynix READ ID byte 4
  mtd: nand: define struct nand_timings
  of: mtd: add NAND timings retrieval support
  of: mtd: add NAND timings bindings documentation
  mtd: nand: add sunxi NFC support
  mtd: nand: add sunxi NFC dt bindings doc
  ARM: dt/sunxi: add NFC node to Allwinner A20 SoC
  ARM: dt/sunxi: add NFC pinctrl pin definitions
  ARM: sunxi/dt: enable NAND on cubietruck board

 Documentation/devicetree/bindings/mtd/nand.txt     |   34 +
 .../devicetree/bindings/mtd/sunxi-nand.txt         |   71 ++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   33 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   35 +
 drivers/mtd/nand/Kconfig                           |    6 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/nand_base.c                       |   37 ++
 drivers/mtd/nand/sunxi_nfc.c                       |  700 ++++++++++++++++++++
 drivers/of/of_mtd.c                                |   47 ++
 include/linux/mtd/nand.h                           |   44 ++
 include/linux/of_mtd.h                             |    9 +
 11 files changed, 1017 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
 create mode 100644 drivers/mtd/nand/sunxi_nfc.c

-- 
1.7.9.5

