Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3CULKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:10:14 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50762 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab3CULKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:10:08 -0400
Message-ID: <1363864206.1390.117.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: drop even more unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 12:10:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 11:10:07.0034 (UTC) FILETIME=[A510C1A0:01CE2624]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I submitted commit 6805ab6daa2b589fe3242d05ddc47a9dbb0c4eb1
("powerpc: drop unused Kconfig symbols") I apparently failed to notice
that my patch also made PREP_RESIDUAL and PPC_A2_DD2 unused. Drop these
now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) I investigated these Kconfig files a bit and discovered that PPC_PREP
is marked BROKEN since v2.6.15, see commit
5be396b00ca0f2f769c55cf69bbd7c77451c925e ("powerpc: Mark PREP and
embedded as broken for now"). Though it's not my problem, this does
suggest PReP support can be removed entirely.

 arch/powerpc/platforms/prep/Kconfig | 13 -------------
 arch/powerpc/platforms/wsp/Kconfig  |  4 ----
 2 files changed, 17 deletions(-)

diff --git a/arch/powerpc/platforms/prep/Kconfig b/arch/powerpc/platforms/prep/Kconfig
index 1547f66..2036e7e 100644
--- a/arch/powerpc/platforms/prep/Kconfig
+++ b/arch/powerpc/platforms/prep/Kconfig
@@ -8,16 +8,3 @@ config PPC_PREP
 	select PPC_UDBG_16550
 	select PPC_NATIVE
 	default n
-
-config PREP_RESIDUAL
-	bool "Support for PReP Residual Data"
-	depends on PPC_PREP
-	help
-	  Some PReP systems have residual data passed to the kernel by the
-	  firmware.  This allows detection of memory size, devices present and
-	  other useful pieces of information.  Sometimes this information is
-	  not present or incorrect, in which case it could lead to the machine 
-	  behaving incorrectly.  If this happens, either disable PREP_RESIDUAL
-	  or pass the 'noresidual' option to the kernel.
-
-	  If you are running a PReP system, say Y here, otherwise say N.
diff --git a/arch/powerpc/platforms/wsp/Kconfig b/arch/powerpc/platforms/wsp/Kconfig
index 79d2225..9eea710 100644
--- a/arch/powerpc/platforms/wsp/Kconfig
+++ b/arch/powerpc/platforms/wsp/Kconfig
@@ -29,7 +29,3 @@ config PPC_CHROMA
 	default y
 
 endmenu
-
-config PPC_A2_DD2
-	bool "Support for DD2 based A2/WSP systems"
-	depends on PPC_A2
-- 
1.7.11.7

