Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaKYKmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaKYKmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 165/254] ARM: mvebu: armada xp: Generalize use of i2c quirk
Date: Tue, 25 Nov 2014 10:38:35 +0000
Message-Id: <1416912004-5928-166-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 5129ee22ce4aff7c5907d4c3d67d23f86cd6db9b upstream.

A second product has come to light which makes use of the A0 stepping
of the Armada XP SoC. A0 stepping has a hardware bug in the i2c core
meaning that hardware offload does not work, resulting in the kernel
failing to boot. The quirk detects that the kernel is running on an A0
stepping SoC and disables the use of hardware offload.

Currently the quirk is only enabled for PlatHome Openblocks AX3. The
AX3 has been produced with both A0 and B0 stepping SoCs. The second
product is the Lenovo Iomega IX4-300d. It seems likely that this
device will also swap from A0 to B0 SoC sometime during its life.

If there are two products using A0, it seems likely there are more
products with A0. Also, since the number of A0 SoCs is limited, these
products are also likely to transition to B0. Hence detecting at run
time is the safest option. So enable the quirk for all Armada XP
boards.

Tested on an AX3 with A0 stepping.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Fixes: 930ab3d403ae: ("i2c: mv64xxx: Add I2C Transaction Generator support")
Link: https://lkml.kernel.org/r/1406395238-29758-2-git-send-email-andrew@lunn.ch
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-mvebu/board-v7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/board-v7.c b/arch/arm/mach-mvebu/board-v7.c
index b2524d689f21..b1e148d70876 100644
--- a/arch/arm/mach-mvebu/board-v7.c
+++ b/arch/arm/mach-mvebu/board-v7.c
@@ -174,7 +174,7 @@ static void __init thermal_quirk(void)
 
 static void __init mvebu_dt_init(void)
 {
-	if (of_machine_is_compatible("plathome,openblocks-ax3-4"))
+	if (of_machine_is_compatible("marvell,armadaxp"))
 		i2c_quirk();
 	if (of_machine_is_compatible("marvell,a375-db")) {
 		external_abort_quirk();
-- 
2.1.0

