Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaDORy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:54:59 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:49002 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaDORy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:54:58 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, akpm@linux-foundation.org
Subject: [PATCH] init: move the trusted keyring config option to general setup.
Date: Tue, 15 Apr 2014 13:54:50 -0400
Message-Id: <1397584490-15775-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SYSTEM_TRUSTED_KEYRING config option is not in any menu,
causing it to show up in the toplevel of the kernel configuration.
Fix this by moving it under the General Setup menu.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 init/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 765018c..9d3585b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1646,6 +1646,18 @@ config MMAP_ALLOW_UNINITIALIZED
 
 	  See Documentation/nommu-mmap.txt for more information.
 
+config SYSTEM_TRUSTED_KEYRING
+	bool "Provide system-wide ring of trusted keys"
+	depends on KEYS
+	help
+	  Provide a system keyring to which trusted keys can be added.  Keys in
+	  the keyring are considered to be trusted.  Keys may be added at will
+	  by the kernel from compiled-in data and from hardware key stores, but
+	  userspace may only add extra keys if those keys can be verified by
+	  keys already in the keyring.
+
+	  Keys in this keyring are used by module signature checking.
+
 config PROFILING
 	bool "Profiling support"
 	help
@@ -1681,18 +1693,6 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
-config SYSTEM_TRUSTED_KEYRING
-	bool "Provide system-wide ring of trusted keys"
-	depends on KEYS
-	help
-	  Provide a system keyring to which trusted keys can be added.  Keys in
-	  the keyring are considered to be trusted.  Keys may be added at will
-	  by the kernel from compiled-in data and from hardware key stores, but
-	  userspace may only add extra keys if those keys can be verified by
-	  keys already in the keyring.
-
-	  Keys in this keyring are used by module signature checking.
-
 menuconfig MODULES
 	bool "Enable loadable module support"
 	option modules
-- 
1.9.2

