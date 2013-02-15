Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161265Ab3BOKmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:42:02 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34295 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760995Ab3BOKl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:56 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 6/6] metag: cleanup metag_ksyms.c includes
Date: Fri, 15 Feb 2013 10:41:41 +0000
Message-ID: <1360924901-21404-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimise metag_ksyms.c includes to directly include the <asm/*.h> files
that declare a particular symbol, and not include any unnecessary ones.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 559ea6f..08e9b6f 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -1,12 +1,9 @@
 #include <linux/export.h>
-#include <linux/linkage.h>
-#include <linux/string.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/hardirq.h>
 
-#include <asm/checksum.h>
+#include <asm/div64.h>
 #include <asm/ftrace.h>
+#include <asm/page.h>
+#include <asm/string.h>
 #include <asm/tbx.h>
 
 EXPORT_SYMBOL(clear_page);
-- 
1.7.7.6


