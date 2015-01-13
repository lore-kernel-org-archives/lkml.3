Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbbAMTyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:54:20 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:38218 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbbAMTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:54:18 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 14:53:57 EST
X-CheckPoint: {54B577D4-2-2100090A-C0000000}
Message-ID: <201501131948.t0DJmWNH027004@lab-37.internal.tilera.com>
From: Chris Metcalf <cmetcalf@ezchip.com>
Date: Tue, 13 Jan 2015 10:04:43 -0500
Subject: [PATCH] tile: default to little endian on older toolchains
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older toolchains may not specify __LITTLE_ENDIAN__, but older
toolchains were all little endian.  Don't make things unnecessarily
hard for those toolchains.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 arch/tile/include/uapi/asm/byteorder.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/tile/include/uapi/asm/byteorder.h b/arch/tile/include/uapi/asm/byteorder.h
index fb72ecf49218..6b8fa2e1cf6e 100644
--- a/arch/tile/include/uapi/asm/byteorder.h
+++ b/arch/tile/include/uapi/asm/byteorder.h
@@ -14,8 +14,6 @@
 
 #if defined (__BIG_ENDIAN__)
 #include <linux/byteorder/big_endian.h>
-#elif defined (__LITTLE_ENDIAN__)
-#include <linux/byteorder/little_endian.h>
 #else
-#error "__BIG_ENDIAN__ or __LITTLE_ENDIAN__ must be defined."
+#include <linux/byteorder/little_endian.h>
 #endif
-- 
2.1.2

