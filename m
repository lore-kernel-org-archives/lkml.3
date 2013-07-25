Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3GYWOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 18:14:22 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55311 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3GYWOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 18:14:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] SH: cpuidle: Add missing parameter for cpuidle_register()
Date: Fri, 26 Jul 2013 00:14:04 +0200
Message-Id: <1374790444-25473-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/sh/kernel/cpu/shmobile/cpuidle.c: In function 'sh_mobile_setup_cpuidle':
arch/sh/kernel/cpu/shmobile/cpuidle.c:102:2: error: too few arguments to function 'cpuidle_register'
include/linux/cpuidle.h:129:12: note: declared here
arch/sh/kernel/cpu/shmobile/cpuidle.c:94:6: warning: unused variable 'ret' [-Wunused-variable]

Add the missing parameter, and remove the unused variable.

Both introduced by commit b181a3b03f866776211f22390c185c4da1dc45ff ("SH:
cpuidle: use init/exit common routine").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sh/kernel/cpu/shmobile/cpuidle.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
index d306225..e3abfd4 100644
--- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
+++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
@@ -91,13 +91,11 @@ static struct cpuidle_driver cpuidle_driver = {
 
 int __init sh_mobile_setup_cpuidle(void)
 {
-	int ret;
-
 	if (sh_mobile_sleep_supported & SUSP_SH_SF)
 		cpuidle_driver.states[1].disabled = false;
 
 	if (sh_mobile_sleep_supported & SUSP_SH_STANDBY)
 		cpuidle_driver.states[2].disabled = false;
 
-	return cpuidle_register(&cpuidle_driver);
+	return cpuidle_register(&cpuidle_driver, NULL);
 }
-- 
1.7.9.5

