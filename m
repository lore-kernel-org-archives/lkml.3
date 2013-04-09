Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936733Ab3DILuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:50:02 -0400
Received: from mail.abilis.ch ([195.70.19.74]:19460 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763884Ab3DILuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:50:00 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] Add option to disable kernel compression
Date: Tue,  9 Apr 2013 13:49:21 +0200
Message-Id: <1365508161-32154-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now, kernel compression can only be disabled by deselecting
HAVE_<compression> in the architecture Kconfig. However, some
users/platforms within the same architecture might want to use
compression while others might want to disable it.
This patch is a solution to the dilemma.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 init/Kconfig |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 5341d72..0924c51 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -101,7 +101,6 @@ config HAVE_KERNEL_LZO
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -120,6 +119,13 @@ choice
 
 	  If in doubt, select 'gzip'
 
+config KERNEL_UNCOMPRESSED
+	bool "No compression"
+	help
+	  No compression at all. The kernel is huge but the compression and
+	  decompression times are zero.
+	  This is usually not what you want.
+
 config KERNEL_GZIP
 	bool "Gzip"
 	depends on HAVE_KERNEL_GZIP
-- 
1.7.1

