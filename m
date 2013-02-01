Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab3BAUoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:44:44 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21467 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3BAUnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:19 -0500
Message-ID: <201302012043.r11KhI09024368@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 13:00:38 -0500
Subject: [PATCH] tile: provide "screen_info" when enabling VT
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids a link-time failure when building allyesconfig.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6a649a4..d1e15f7 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/timex.h>
 #include <linux/hugetlb.h>
 #include <linux/start_kernel.h>
+#include <linux/screen_info.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
@@ -49,6 +50,10 @@ static inline int ABS(int x) { return x >= 0 ? x : -x; }
 /* Chip information */
 char chip_model[64] __write_once;
 
+#ifdef CONFIG_VT
+struct screen_info screen_info;
+#endif
+
 struct pglist_data node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-- 
1.7.10.3

