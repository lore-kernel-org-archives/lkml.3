Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbaKSWWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:22:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaKSUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17 073/141] ARM: mvebu: armada xp: Generalize use of i2c quirk
Date: Wed, 19 Nov 2014 12:51:36 -0800
Message-Id: <20141119205153.064861665@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/board-v7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-mvebu/board-v7.c
+++ b/arch/arm/mach-mvebu/board-v7.c
@@ -188,7 +188,7 @@ static void __init thermal_quirk(void)
 
 static void __init mvebu_dt_init(void)
 {
-	if (of_machine_is_compatible("plathome,openblocks-ax3-4"))
+	if (of_machine_is_compatible("marvell,armadaxp"))
 		i2c_quirk();
 	if (of_machine_is_compatible("marvell,a375-db")) {
 		external_abort_quirk();


