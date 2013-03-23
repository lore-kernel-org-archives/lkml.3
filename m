Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423186Ab3CWB2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:28:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:62847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422834Ab3CWBZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="283455605"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/29] x86, tsx: Add a minimal RTM tester at bootup
Date: Fri, 22 Mar 2013 18:24:59 -0700
Message-Id: <1364001923-10796-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

May be removed later, but useful for basic sanity checking.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/Makefile   |    2 ++
 arch/x86/kernel/rtm-test.c |   22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/rtm-test.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd3..f46aebd 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -114,3 +114,5 @@ ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
 endif
+
+obj-y					+= rtm-test.o
diff --git a/arch/x86/kernel/rtm-test.c b/arch/x86/kernel/rtm-test.c
new file mode 100644
index 0000000..5e138c1
--- /dev/null
+++ b/arch/x86/kernel/rtm-test.c
@@ -0,0 +1,22 @@
+#include <asm/rtm.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+
+int x;
+
+static __init int rtm_test(void)
+{
+	unsigned status;
+
+	pr_info("simple rtm test\n");
+	if ((status = _xbegin()) == _XBEGIN_STARTED) {
+		x++;
+		_xend();
+		pr_info("transaction committed\n");
+	} else {
+		pr_info("transaction aborted %x\n", status);
+	}
+	return 0;
+}
+
+device_initcall(rtm_test);
-- 
1.7.7.6

