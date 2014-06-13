Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaFMQil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:38:41 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43277 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaFMQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:38:40 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] powerpc: Fix build warning
Date: Fri, 13 Jun 2014 09:38:19 -0700
Message-Id: <1402677499-28289-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If compiled with W=1, the following warning is seen in powerpc builds.

arch/powerpc/kernel/smp.c:750:18: warning:
	type qualifiers ignored on function return type
static const int powerpc_smt_flags(void)
                 ^

This is caused by a function returning 'const int', which doesn't
make sense to gcc. Drop 'const' to fix the problem.

Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/powerpc/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 10ffffe..49d5d4e 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -768,7 +768,7 @@ int setup_profiling_timer(unsigned int multiplier)
 
 #ifdef CONFIG_SCHED_SMT
 /* cpumask of CPUs with asymetric SMT dependancy */
-static const int powerpc_smt_flags(void)
+static int powerpc_smt_flags(void)
 {
 	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
 
-- 
1.9.1

