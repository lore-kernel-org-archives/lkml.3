Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaJKPlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:41:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42329 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaJKPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:41:21 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Berlin BG2 AHCI and SATA PHY
Date: Sat, 11 Oct 2014 17:41:08 +0200
Message-Id: <1413042073-14253-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set catches up with latest Berlin improvements provided
by Antoine - in particular SATA PHY support and AHCI generic for
Berlin BG2.

Marvell BSP code for BG2 suggests more differences between the two
PHY revisions found on BG2 and BG2Q, but the only important one seems
to be the PHY_BASE used in AHCI vendor-specific registers. I also
confirmed that power_off does indeed power off the PHY on BG2, too
(It wasn't very clear in BSP code).

Anyway, I have tested this on BG2-based Sony NSZ-GS7 and attached
SATA HDD is successfully detected and partitions are displayed.

The patches are currently based on next-20141009 and I plan to resend
once v3.18-rc1 drops. A branch based on next-20141009 with this patches
applied can be found on

git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-sata-v1

Patch 1 prepares phy-berlin-sata to support different PHY_BASE addresses
by moving the constant to driver private data.

Patches 2 and 3 add a new compatible to driver and DT documentation that
reflects the differences between BG2Q and BG2 SATA PHY.

Patches 4 and 5 finally add DT nodes to both Berlin2 SoC dtsi and Sony
NSZ-GS7 board DT file. SATA plug on NSZ-GS7 is unpopulated but can be
very easily equipped with SATA receptable and some 0402 caps. I decided
to enable SATA by default although not all users may populate it.

Sebastian

Sebastian Hesselbarth (5):
  phy: berlin-sata: Move PHY_BASE into private data struct
  phy: berlin-sata: Add support for BG2 SATA PHY
  phy: berlin-sata: Document BG2 compatible
  ARM: berlin: Add AHCI and SATA PHY nodes to BG2
  ARM: berlin: Enable SATA on Sony NSZ-GS7

 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  4 +-
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |  7 ++++
 arch/arm/boot/dts/berlin2.dtsi                     | 40 ++++++++++++++++++
 drivers/phy/phy-berlin-sata.c                      | 48 +++++++++++++++-------
 4 files changed, 84 insertions(+), 15 deletions(-)

---
Cc: Kishon Vijay Abraham I <kishon@ti.com> 
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org 
-- 
2.1.1

