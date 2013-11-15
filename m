Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3KOGqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:46:18 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:60717 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3KOGqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:46:07 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        David Daney <david.daney@cavium.com>, Michal Marek <mmarek@suse.cz>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: [PATCH] ARC: extable: Enable sorting at build time
Date: Fri, 15 Nov 2013 12:15:42 +0530
Message-ID: <1384497942-26810-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids wasting cycles at boot specially on slower simulators

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Francois Bedard <fbedard@synopsys.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/arc/Kconfig      | 1 +
 scripts/sortextable.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 91dbb2757afd..080580216301 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -8,6 +8,7 @@
 
 config ARC
 	def_bool y
+	select BUILDTIME_EXTABLE_SORT
 	select CLONE_BACKWARDS
 	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
 	select DEVTMPFS if !INITRAMFS_SOURCE=""
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 7c2310c5b996..e3fb1c36ed0f 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -31,6 +31,10 @@
 #include <tools/be_byteshift.h>
 #include <tools/le_byteshift.h>
 
+#ifndef EM_ARCOMPACT
+#define EM_ARCOMPACT	93
+#endif
+
 #ifndef EM_AARCH64
 #define EM_AARCH64	183
 #endif
@@ -244,6 +248,7 @@ do_file(char const *const fname)
 	case EM_S390:
 		custom_sort = sort_relative_table;
 		break;
+	case EM_ARCOMPACT:
 	case EM_ARM:
 	case EM_AARCH64:
 	case EM_MIPS:
-- 
1.8.1.2

