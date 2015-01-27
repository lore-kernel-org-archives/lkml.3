Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbbA0MTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673AbbA0MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 095/126] ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT
Date: Tue, 27 Jan 2015 12:16:40 +0000
Message-Id: <1422361031-19364-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit 5adba7c2daaecccf377e7ed5a2996caedd5384f1 upstream.

There's no card detection for the eMMC, so this patch adds the missing
broken-cd property. This patch also sets bus width as 8 to add
MMC_CAP_8_BIT_DATA in the Host capabilities.

Fixes: 3047086dfd56 ("ARM: dts: berlin: enable SD card reader and eMMC for the BG2Q DMP")
Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 995150f93795..22e5dfe77f09 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -30,6 +30,8 @@
 };
 
 &sdhci2 {
+	broken-cd;
+	bus-width = <8>;
 	non-removable;
 	status = "okay";
 };
-- 
2.1.4

