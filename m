Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbbAYSY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:24:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbbAYSKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 3.18 171/183] ARM: dts: berlin: add broken-cd and set bus width for eMMC in Marvell DMP DT
Date: Sun, 25 Jan 2015 10:08:13 -0800
Message-Id: <20150125180817.603789820@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit 5adba7c2daaecccf377e7ed5a2996caedd5384f1 upstream.

There's no card detection for the eMMC, so this patch adds the missing
broken-cd property. This patch also sets bus width as 8 to add
MMC_CAP_8_BIT_DATA in the Host capabilities.

Fixes: 3047086dfd56 ("ARM: dts: berlin: enable SD card reader and eMMC for the BG2Q DMP")
Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts |    2 ++
 1 file changed, 2 insertions(+)

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


