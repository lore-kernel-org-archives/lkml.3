Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab3GCSgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:36:53 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35573 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab3GCSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:36:50 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 2/3] init/Kconfig: VIRT_CPU_ACCOUNTING_GEN: drop 64-bit requirement
Date: Wed,  3 Jul 2013 11:36:40 -0700
Message-Id: <1372876601-23881-3-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1372876601-23881-1-git-send-email-khilman@linaro.org>
References: <1372876601-23881-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit requirement can be removed after the conversion of the nsec
granularity cputime to work on !64_BIT, which was done in commit
8c23b80e (cputime_nsecs: use math64.h for nsec resolution conversion
helpers)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 2d9b831..e151022 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -325,7 +325,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
-	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_CONTEXT_TRACKING
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
-- 
1.8.3

