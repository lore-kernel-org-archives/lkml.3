Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3GCSgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:36:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43422 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3GCSgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:36:48 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 1/3] nohz: Kconfig: remove redundant 64-bit dependency
Date: Wed,  3 Jul 2013 11:36:39 -0700
Message-Id: <1372876601-23881-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1372876601-23881-1-git-send-email-khilman@linaro.org>
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current 64-bit dependency is on VIRT_CPU_ACCOUNTING_GEN, which already
has its own dependency on 64-bit.  Remove it from NO_HZ_FULL.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/time/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 70f27e8..b78760f 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -99,8 +99,6 @@ config NO_HZ_FULL
 	depends on SMP
 	# RCU_USER_QS dependency
 	depends on HAVE_CONTEXT_TRACKING
-	# VIRT_CPU_ACCOUNTING_GEN dependency
-	depends on 64BIT
 	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
-- 
1.8.3

