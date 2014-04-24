Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaDXMI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:08:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37463 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318AbaDXMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:07:47 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        eparis@redhat.com, paul.gortmaker@windriver.com, vapier@gentoo.org,
        kyungsik.lee@lge.com, jslaby@suse.cz, dwight.engen@oracle.com,
        pefoley2@pefoley.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 1/1] init/Kconfig: improve CC_OPTIMIZE_FOR_SIZE documentation
Date: Thu, 24 Apr 2014 14:07:34 +0200
Message-Id: <1398341254-4626-2-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1398341254-4626-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 init/Kconfig | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d3585bb2a7a..b6394a9ddc38 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1251,7 +1251,19 @@ config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
 	  Enabling this option will pass "-Os" instead of "-O2" to gcc
-	  resulting in a smaller kernel.
+	  resulting in a smaller but slower kernel.
+
+	  This option can be useful in very small systems where every
+	  byte counts.
+
+	  A smaller kernel will also be slightly faster to load and start.
+	  However, experiments have shown that such early speedups are
+	  quickly offset by the slower kernel speed. Unless you are running
+	  a very simple user space, the total boot time should be degraded
+	  by this option.
+
+	  Anyway, kernel code will be slower to execute and overall system
+  	  performance will be degraded.
 
 	  If unsure, say N.
 
-- 
1.8.3.2

