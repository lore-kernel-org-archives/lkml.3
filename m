Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaLDWad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:30:33 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50659 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754632AbaLDWab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:30:31 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Josh Wu <josh.wu@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 0/4] mtd: nand: atmel: Rework DT representation of NFC/NAND
Date: Thu,  4 Dec 2014 23:30:10 +0100
Message-Id: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While working on the EBI driver [1] I noticed that the relationship between
the NFC (NAND Flash Controller) and the NAND chip it is attached to would
make things harder to represent when moving the NAND node under the EBI bus
(another useless 'ranges' definition).

Actually this representation might be even more problematic if one wants
decide to connect two NAND chips on his sama5 based board, because the NFC
node is a child of the NAND chip node, and thus can only be attached to a
single NAND chip.

To address this problem the current series moves the NFC node outside of
the NAND chip device which then reference the NFC using the "atmel,nfc"
property.

The series does not implement multi-chip support, but at least the new
representation should make it possible.

Best Regards,

Boris

[1]https://lkml.org/lkml/2014/12/3/806

Boris Brezillon (4):
  mtd: nand: atmel: Rework driver to separate nfc and nand nodes
  mtd: nand: atmel: Update DT documentation after splitting NFC and NAND
  ARM: at91/dt: sama5: move NFC nodes outside of NAND nodes
  ARM: at91/dt: sama5: move NAND nodes into board dts/dtsi

 .../devicetree/bindings/mtd/atmel-nand.txt         | 46 +++++++------
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        | 18 ++++-
 arch/arm/boot/dts/at91-sama5d4ek.dts               | 16 ++++-
 arch/arm/boot/dts/sama5d3.dtsi                     | 36 ++--------
 arch/arm/boot/dts/sama5d3xcm.dtsi                  | 18 ++++-
 arch/arm/boot/dts/sama5d4.dtsi                     | 36 ++--------
 drivers/mtd/nand/atmel_nand.c                      | 76 +++++++++++++++++-----
 7 files changed, 149 insertions(+), 97 deletions(-)

-- 
1.9.1

