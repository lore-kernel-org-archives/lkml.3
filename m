Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3I3OHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:07:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53764 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3I3OHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:07:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] nohz: Drop generic vtime obsolete dependency on CONFIG_64BIT
Date: Mon, 30 Sep 2013 16:06:51 +0200
Message-Id: <1380550012-7321-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
References: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

The CONFIG_64BIT requirement on vtime can finally be removed
since we now depend on HAVE_VIRT_CPU_ACCOUNTING_GEN which
already takes care of the arch ability to handle nsecs based
cputime_t safely.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arm Linux <linux-arm-kernel@lists.infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 init/Kconfig        | 2 +-
 kernel/time/Kconfig | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 68c1a0e..841e79c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -354,7 +354,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
-	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_CONTEXT_TRACKING
 	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f148475..3ce6e8c 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -100,7 +100,6 @@ config NO_HZ_FULL
 	# RCU_USER_QS dependency
 	depends on HAVE_CONTEXT_TRACKING
 	# VIRT_CPU_ACCOUNTING_GEN dependency
-	depends on 64BIT
 	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select NO_HZ_COMMON
 	select RCU_USER_QS
-- 
1.8.3.1

