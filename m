Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaE2Fe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:34:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaE2Ee7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 033/140] init/Kconfig: move the trusted keyring config option to general setup
Date: Wed, 28 May 2014 21:32:52 -0700
Message-Id: <20140529043053.624996788@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1621,6 +1621,18 @@ config MMAP_ALLOW_UNINITIALIZED
 
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
@@ -1656,18 +1668,6 @@ config BASE_SMALL
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


