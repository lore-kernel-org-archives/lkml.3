Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaEBPng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:43:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaEBPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 021/151] ARM: Fix default CPU selection for ARCH_MULTI_V5
Date: Fri,  2 May 2014 08:36:49 -0700
Message-Id: <1399045139-4531-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit 12567bbdee7ea553237085a2bbc0ffa5240f5248 upstream.

CPU_ARM926T should be selected if no other CPU is. Put the ! in the
right place so this works.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Fixes: 24e860fbfdb1c ("ARM: multiplatform: always pick one CPU type")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 47085a0..31e1f44 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -871,7 +871,7 @@ config ARCH_MULTI_V5
 	bool "ARMv5 based platforms (ARM926T, XSCALE, PJ1, ...)"
 	depends on !ARCH_MULTI_V6_V7
 	select ARCH_MULTI_V4_V5
-	select CPU_ARM926T if (!CPU_ARM946E || CPU_ARM1020 || \
+	select CPU_ARM926T if !(CPU_ARM946E || CPU_ARM1020 || \
 		CPU_ARM1020E || CPU_ARM1022 || CPU_ARM1026 || \
 		CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_FEROCEON)
 
-- 
1.9.1

