Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3CEWQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:16:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CEWQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:16:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 9/9] ARM: spear3xx: Use correct pl080 header file
Date: Tue,  5 Mar 2013 23:16:49 +0100
Message-Id: <1362521809-22989-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:h/CxWSjkua89siXGEQ0lPTgaeKSQjrdvq6yZSE1Rsde
 3bjmfLN70Wp38tEE34OaXkllOMoIXLF0uvw7AzFM2idz/YRBVy
 7urjOjy/ulEgJN6OYh1ba1wa1aFsoC2qE/Sg/a17ZsLJRfreMs
 n3yu83jDzHlttauVDpgCvujMlD0eVeDvC2UExkLnV827ejiMe7
 4BMMHOO1lVBKPfcdOwvkpsHoVQwiLp+s0ibVvnHrhpnyrMPeeQ
 GFmWs0iFW6VUMU7RSfx0U7BDfV6QZ9JDJ0pPKJgoh0SQi08WjE
 8NMgZFSAXg1N+hU8V8xyMI4jAFWk0MGG3zhHjm2YFDapwDaLwF
 mA/i6Ufr/t9LbMR9sKU2RyJpzrYj1bGUGcyE+5aef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions have move around recently, causing build errors
in spear3xx for all configurations:

spear3xx.c:47:5: error: 'PL080_BSIZE_16' undeclared here (not in a function)
spear3xx.c:47:23: error: 'PL080_CONTROL_SB_SIZE_SHIFT' undeclared here (not in a function)
spear3xx.c:48:22: error: 'PL080_CONTROL_DB_SIZE_SHIFT' undeclared here (not in a function)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@gnudd.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-spear3xx/spear3xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index f9d754f..d2b3937 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -14,7 +14,7 @@
 #define pr_fmt(fmt) "SPEAr3xx: " fmt
 
 #include <linux/amba/pl022.h>
-#include <linux/amba/pl08x.h>
+#include <linux/amba/pl080.h>
 #include <linux/io.h>
 #include <plat/pl080.h>
 #include <mach/generic.h>
-- 
1.8.1.2

