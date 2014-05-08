Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaEHO56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:57:58 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56029 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaEHO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Robert Tivy <rtivy@ti.com>
Subject: [PATCH] remoteproc: da8xx: don't select CMA on no-MMU
Date: Thu,  8 May 2014 16:56:29 +0200
Message-Id: <1399560990-1402858-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:GTKis3N2lfki1S+2buo+ZnAqtWYnn8f2RS8gpLyFNHp
 8j+wxq7ZdZ4WkqCn3JN2lHwOpTUVQbFF2ORfVaM39ikTuxA6f/
 U/AneOg76zs3d+eDdyaIxfEI99NhkdvQ1Q7jIpMHCrUyYR77OD
 oygftVlw0Rfr2sygPPY2Ubiq+dQVM26W78SHnsjG72xzsNES3g
 Bjv+uVAZayCI+Xmd1kinkUvWw89cLvv4p81R1kGg0E4dyTfOEF
 7VmnJii4E13DROD5s6kQGF8i2UI6MFvePqP5dZvAKJCENasvlh
 WDoTvFagPtpQAuuOknkw8OyFQOgVxcqFlIbXZD20WrWHNlHuE/
 vDdu9g4a/QeABijSiscP1zsBNfbtBjMUrGuIWcuiq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only use CMA on systems that have an MMU, because of
the requirement to use memory migration. NOMMU systems are
rather constrained to start with, but it seems reasonable
to assume that DMA allocations can still succeed in the
constrained case for remoteproc on NOMMU, so this patch
changes the da8xx implementation to not rely on CMA when
the MMU is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Robert Tivy <rtivy@ti.com>
---
 drivers/remoteproc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ce1743d..5e343ba 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -44,7 +44,7 @@ config STE_MODEM_RPROC
 config DA8XX_REMOTEPROC
 	tristate "DA8xx/OMAP-L13x remoteproc support"
 	depends on ARCH_DAVINCI_DA8XX
-	select CMA
+	select CMA if MMU
 	select REMOTEPROC
 	select RPMSG
 	help
-- 
1.8.3.2

