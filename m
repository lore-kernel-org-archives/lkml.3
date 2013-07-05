Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab3GEQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59496 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3GEQWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/8] ARM: omap5: omap5 has SCU and TWD
Date: Fri,  5 Jul 2013 18:23:31 +0200
Message-Id: <1373041417-217728-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:f7n8yJVGm40LShAkV4rHi0zS/Hz+0sN6Rj5VizI+Fsi
 NFNZ0+L//59tNQb79NGIafdnR25/IdcZDCUji9BNM1AkoWUGbL
 1FBj6lF8pVs8immOsyRs9RkeQFq7PWI8Rf2l2GliYVsAX3DF2U
 MNuSdB02uabik/3/ot03CqFwH2J9YMAhMdlyl9NajCHqu46vih
 bK40/BvRvaz2Iet5Nqmmbo3Z8wUpgW5+6cQttCw4DKTnCFENG0
 +6EafEfqghtBC8zxfsb91rZq1FgjOquW+28FocHYJsbfqVtCJa
 8OH9XE2FJCZ/vRa7PLe2aUSoZUIJeNfefekT5Q6bTdlLzj9k06
 kv4RV7bcd5NKekwAZ1o+RFuCio7+RxsHP/PvbNgWV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are selected by omap4 but used in common omap4/5
SMP code, so building an omap5-only kernel is actually
broken without this patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 1fdb462..1f8127a 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -110,6 +110,8 @@ config SOC_OMAP5
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select CPU_V7
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select COMMON_CLK
 	select HAVE_ARM_ARCH_TIMER
-- 
1.8.3.1

