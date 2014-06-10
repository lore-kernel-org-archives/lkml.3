Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaFJTyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:54:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaFJTyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Foley <pefoley2@pefoley.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/160] init/Kconfig: move the trusted keyring config option to general setup
Date: Tue, 10 Jun 2014 12:44:42 -0700
Message-Id: <1402429600-20477-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Foley <pefoley2@pefoley.com>

commit 82c04ff89eba09d0e46e3f3649c6d3aa18e764a0 upstream.

The SYSTEM_TRUSTED_KEYRING config option is not in any menu, causing it
to show up in the toplevel of the kernel configuration.  Fix this by
moving it under the General Setup menu.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 init/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 66e6759..c3a1d7c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1633,6 +1633,18 @@ config MMAP_ALLOW_UNINITIALIZED
 
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
@@ -1668,18 +1680,6 @@ config BASE_SMALL
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
1.9.1

