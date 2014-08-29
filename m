Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaH2NQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:16:10 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:59618 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbaH2NQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:16:08 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 09:16:08 EDT
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jkosina@suse.cz, paul.gortmaker@windriver.com,
        mhocko@suse.cz, mattst88@gmail.com, josh@joshtriplett.org,
        geert@linux-m68k.org, khilman@linaro.org,
        Stefan Hengelein <stefan.hengelein@fau.de>,
        Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] init/Kconfig: move RCU_NOCB_CPU dependencies to choice
Date: Fri, 29 Aug 2014 15:08:20 +0200
Message-Id: <1409317700-3836-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every choice item of the "Build-forced no-CBs CPUs" choice had a
dependency to RCU_NOCB_CPU. It's more comprehensible if the choice
itself has the dependency instead of every choice item.
The choice itself doesn't need to be visible if there are no items
selectable (i.e. on arch/frv) or RCU_NOCB_CPU is not defined.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 init/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 197b563..d604000 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -729,6 +729,7 @@ config RCU_NOCB_CPU
 choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
+	depends on RCU_NOCB_CPU
 	help
 	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
 	  from kthreads rather than from softirq context) to be specified
@@ -737,7 +738,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on !NO_HZ_FULL_ALL
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +752,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on !NO_HZ_FULL_ALL
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
@@ -766,7 +767,6 @@ config RCU_NOCB_CPU_ZERO
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 	  boot parameter will be ignored.  All CPUs' RCU callbacks will
-- 
1.9.1

