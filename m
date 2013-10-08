Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3JHMeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:34:11 -0400
Received: from mail.abilis.ch ([195.70.19.74]:19736 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3JHMeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:34:07 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 08:34:05 EDT
From: Christian Ruppert <christian.ruppert@abilis.com>
To: linux-kernel@vger.kernel.org
Cc: alexander.stein@systec-electronic.com,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH REBASE] Add option to disable kernel compression
Date: Tue,  8 Oct 2013 14:33:32 +0200
Message-Id: <1381235612-23988-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <2065777.DKEM6dSyjc@ws-stein>
References: <2065777.DKEM6dSyjc@ws-stein>
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
index fed81b5..7db419b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -118,7 +118,6 @@ config HAVE_KERNEL_LZ4
 choice
 	prompt "Kernel compression mode"
 	default KERNEL_GZIP
-	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
 	help
 	  The linux kernel is a kind of self-extracting executable.
 	  Several compression algorithms are available, which differ
@@ -137,6 +136,13 @@ choice
 
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

