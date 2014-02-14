Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaBNVW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:22:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbaBNVWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="475474898"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/19] lto: Disable LTO for hweight functions
Date: Fri, 14 Feb 2014 22:21:26 +0100
Message-Id: <1392412903-25733-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

x86 calls the hweight library functions with special calling conventions.
LTO doesn't support compiling individual files with special options.
Just disable LTO for the file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 48140e3..2057304 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -46,7 +46,9 @@ obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 
 GCOV_PROFILE_hweight.o := n
-CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS)) \
+		   $(DISABLE_LTO)
+
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 
 obj-$(CONFIG_BTREE) += btree.o
-- 
1.8.5.2

