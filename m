Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaETLVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:21:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:53691 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbaETLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:21:51 -0400
Message-ID: <1400584909.4912.35.camel@x220>
Subject: [PATCH] MIPS: remove checks for CONFIG_SGI_IP35
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 13:21:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 11:21:49.0476 (UTC) FILETIME=[B150A640:01CF741D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since (shortly before) v2.4.0 there have been checks for
CONFIG_SGI_IP35. But a Kconfig symbol SGI_IP35 was never added to the
tree. Remove these checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

For some reason CONFIG_SGI_IP35 was heavily used in arch/ia64 too.
Anyhow, IA64 has dropped that macro years ago.

 arch/mips/include/asm/sn/addrs.h    |  2 --
 arch/mips/include/asm/sn/agent.h    |  4 +---
 arch/mips/include/asm/sn/klconfig.h | 18 +-----------------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/mips/include/asm/sn/addrs.h b/arch/mips/include/asm/sn/addrs.h
index 66814f8ba8e8..b18772778a79 100644
--- a/arch/mips/include/asm/sn/addrs.h
+++ b/arch/mips/include/asm/sn/addrs.h
@@ -20,8 +20,6 @@
 
 #if defined(CONFIG_SGI_IP27)
 #include <asm/sn/sn0/addrs.h>
-#elif defined(CONFIG_SGI_IP35)
-#include <asm/sn/sn1/addrs.h>
 #endif
 

diff --git a/arch/mips/include/asm/sn/agent.h b/arch/mips/include/asm/sn/agent.h
index e33d09293019..fe84c1fc8551 100644
--- a/arch/mips/include/asm/sn/agent.h
+++ b/arch/mips/include/asm/sn/agent.h
@@ -16,9 +16,7 @@
 
 #if defined(CONFIG_SGI_IP27)
 #include <asm/sn/sn0/hub.h>
-#elif defined(CONFIG_SGI_IP35)
-#include <asm/sn/sn1/hub.h>
-#endif	/* !CONFIG_SGI_IP27 && !CONFIG_SGI_IP35 */
+#endif
 
 /*
  * NIC register macros
diff --git a/arch/mips/include/asm/sn/klconfig.h b/arch/mips/include/asm/sn/klconfig.h
index 467c313d5767..f0ec614afa92 100644
--- a/arch/mips/include/asm/sn/klconfig.h
+++ b/arch/mips/include/asm/sn/klconfig.h
@@ -40,26 +40,10 @@
 //#include <sys/graph.h>
 //#include <sys/xtalk/xbow.h>
 
-#elif defined(CONFIG_SGI_IP35)
-
-#include <asm/sn/sn1/addrs.h>
-#include <sys/sn/router.h>
-#include <sys/graph.h>
-#include <asm/xtalk/xbow.h>
-
-#endif /* !CONFIG_SGI_IP27 && !CONFIG_SGI_IP35 */
-
-#if defined(CONFIG_SGI_IP27) || defined(CONFIG_SGI_IP35)
 #include <asm/sn/agent.h>
 #include <asm/fw/arc/types.h>
 #include <asm/fw/arc/hinv.h>
-#if defined(CONFIG_SGI_IP35)
-// The hack file has to be before vector and after sn0_fru....
-#include <asm/hack.h>
-#include <asm/sn/vector.h>
-#include <asm/xtalk/xtalk.h>
-#endif /* CONFIG_SGI_IP35 */
-#endif /* CONFIG_SGI_IP27 || CONFIG_SGI_IP35 */
+#endif
 
 typedef u64  nic_t;
 
-- 
1.9.0

