Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaEMDKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:10:21 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54617 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEMDKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:10:20 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Paul Bolle <pebolle@tiscali.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc/pseries: relocate "config DTL" so KConfig nests properly
Date: Mon, 12 May 2014 20:09:55 -0700
Message-Id: <1399950599-24826-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051303-7164-0000-0000-000001B4CEC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/Kconfig | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 2cb8b77..e00dd4d 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -33,6 +33,16 @@ config PPC_SPLPAR
 	  processors, that is, which share physical processors between
 	  two or more partitions.
 
+config DTL
+	bool "Dispatch Trace Log"
+	depends on PPC_SPLPAR && DEBUG_FS
+	help
+	  SPLPAR machines can log hypervisor preempt & dispatch events to a
+	  kernel buffer. Saying Y here will enable logging these events,
+	  which are accessible through a debugfs file.
+
+	  Say N if you are unsure.
+
 config PSERIES_MSI
        bool
        depends on PCI_MSI && PPC_PSERIES && EEH
@@ -122,13 +132,3 @@ config HV_PERF_CTRS
 	  systems. 24x7 is available on Power 8 systems.
 
           If unsure, select Y.
-
-config DTL
-	bool "Dispatch Trace Log"
-	depends on PPC_SPLPAR && DEBUG_FS
-	help
-	  SPLPAR machines can log hypervisor preempt & dispatch events to a
-	  kernel buffer. Saying Y here will enable logging these events,
-	  which are accessible through a debugfs file.
-
-	  Say N if you are unsure.
-- 
1.9.3

