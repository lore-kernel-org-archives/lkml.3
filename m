Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaI3Brp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:47:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31200 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaI3Brj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:47:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 1/5] mm: add poisoning basics
Date: Mon, 29 Sep 2014 21:47:15 -0400
Message-Id: <1412041639-23617-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add poisining basics along with a config option to enable poisoning.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/poison.h | 6 ++++++
 lib/Kconfig.debug      | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..db4d03e 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -86,4 +86,10 @@
 /********** sound/oss/ **********/
 #define OSS_POISON_FREE		0xAB
 
+/********** include/linux/mm_types.h **********/
+#ifdef CONFIG_DEBUG_VM_POISON
+#define MM_POISON_BEGIN		0x89ABCDEF
+#define MM_POISON_END		0xFEDCBA98
+#endif /* DEBUG_VM_POISON */
+
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c366c8a..3b82772 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -543,6 +543,15 @@ config DEBUG_VM_RB
 
 	  If unsure, say N.
 
+config DEBUG_VM_POISON
+	bool "Poison VM structures"
+	depends on DEBUG_VM
+	help
+	  Add poison to the beggining and end of various VM structure to
+	  detect memory corruption in VM management code.
+
+	  If unsure, say N.
+
 config DEBUG_VIRTUAL
 	bool "Debug VM translations"
 	depends on DEBUG_KERNEL && X86
-- 
1.9.1

