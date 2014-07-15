Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaGORWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:22:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59979 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbaGORWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:22:38 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 49/94] ARM: l2c: fix revision checking
Date: Tue, 15 Jul 2014 20:01:04 +0300
Message-Id: <1405443709-15288-49-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

The revision checking in l2c310_enable() was not correct; we were
masking the part number rather than the revision number.  Fix this
to use the correct macro.

Fixes: 4374d64933b1 ("ARM: l2c: add automatic enable of early BRESP")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/mm/cache-l2x0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 076172b..7c3fb41 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -664,7 +664,7 @@ static int l2c310_cpu_enable_flz(struct notifier_block *nb, unsigned long act, v
 
 static void __init l2c310_enable(void __iomem *base, u32 aux, unsigned num_lock)
 {
-	unsigned rev = readl_relaxed(base + L2X0_CACHE_ID) & L2X0_CACHE_ID_PART_MASK;
+	unsigned rev = readl_relaxed(base + L2X0_CACHE_ID) & L2X0_CACHE_ID_RTL_MASK;
 	bool cortex_a9 = read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9;
 
 	if (rev >= L310_CACHE_ID_RTL_R2P0) {
-- 
1.7.10.4

