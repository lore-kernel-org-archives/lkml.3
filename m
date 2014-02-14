Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaBNVWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:22:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:58150 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaBNVWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="455752564"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/19] Kbuild, lto: add ld-version and ld-ifversion macros
Date: Fri, 14 Feb 2014 22:21:34 +0100
Message-Id: <1392412903-25733-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

To check the linker version. Used by the LTO makefile.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/Kbuild.include | 9 +++++++++
 scripts/ld-version.sh  | 8 ++++++++
 2 files changed, 17 insertions(+)
 create mode 100755 scripts/ld-version.sh

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 547e15d..93a0da2 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -155,6 +155,15 @@ ld-option = $(call try-run,\
 # Important: no spaces around options
 ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
 
+# ld-version
+# Usage: $(call ld-version)
+# Note this is mainly for HJ Lu's 3 number binutil versions
+ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
+
+# ld-ifversion
+# Usage:  $(call ld-ifversion, -ge, 22252, y)
+ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
+
 ######
 
 ###
diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
new file mode 100755
index 0000000..198580d
--- /dev/null
+++ b/scripts/ld-version.sh
@@ -0,0 +1,8 @@
+#!/usr/bin/awk -f
+# extract linker version number from stdin and turn into single number
+	{
+	gsub(".*)", "");
+	split($1,a, ".");
+	print a[1]*10000000 + a[2]*100000 + a[3]*10000 + a[4]*100 + a[5];
+	exit
+	}
-- 
1.8.5.2

