Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3EaWXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:23:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54112 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab3EaWXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-pm@vger.kernel.org
Subject: [PATCH 06/15] cpuidle: calxeda: select ARM_CPU_SUSPEND
Date: Sat,  1 Jun 2013 00:22:43 +0200
Message-Id: <1370038972-2318779-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DVQJWHK0PLR6LjzFFWj5kg8bqXUa0ukVQeoBE9pKNx0
 YKlgiL1VwwiQtBpmeDQx4RmoPBiw8iAaVjYnyjzB5Bbnmmxzgq
 46+jaGdEn5w89/VDr1XoqdUyKe0ySqUOpoV19hpjh9P2f8S5n9
 M/g7u4vMgrmqTkEloIufZMNK/YJKuI/C0Rnay3s6KUkXkP74/v
 1f+59c88Lkf8dR3RnChKeYhth8ehvle1T0GhAPryUvyOORrw1A
 DYE7+NIphIJU9ezK5vavWP5VFn8sZ36SXhKzqUZ2D014VQFPTE
 KECIDtDYnEPg8gTGir5xyxm1F7fx+/bASoLszr8po4IloRau8G
 vsLzbzppRIeSsUW3F2XjTPWiP+/Y50ezjufeBHAxz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other ARM specific drivers, this one requires ARM_CPU_SUSPEND,
as shown by this linker error:

drivers/built-in.o: In function `calxeda_pwrdown_idle':
drivers/cpuidle/cpuidle-calxeda.c:84: undefined reference to `cpu_suspend'
drivers/cpuidle/cpuidle-calxeda.c:86: undefined reference to `cpu_resume'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
---
 drivers/cpuidle/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index c4cc27e..e21cdfa 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -36,6 +36,7 @@ if CPU_IDLE
 config CPU_IDLE_CALXEDA
 	bool "CPU Idle Driver for Calxeda processors"
 	depends on ARCH_HIGHBANK
+	select ARM_CPU_SUSPEND
 	help
 	  Select this to enable cpuidle on Calxeda processors.
 
-- 
1.8.1.2

