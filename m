Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3GQWuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:50:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab3GQWul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jason Liu <r64343@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 128/145] ARM: 7778/1: smp_twd: twd_update_frequency need be run on all online CPUs
Date: Wed, 17 Jul 2013 15:47:40 -0700
Message-Id: <1374101277-7915-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Liu <r64343@freescale.com>

commit cbbe6f82b489e7ceba4ad7c833bd3a76cd0084cb upstream.

When the local timer freq changed, the twd_update_frequency function
should be run all the CPUs include itself, otherwise, the twd freq will
not get updated and the local timer will not run correcttly.

smp_call_function will run functions on all other CPUs, but not include
himself, this is not correct,use on_each_cpu instead to fix this issue.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jason Liu <r64343@freescale.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/smp_twd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 49f335d..64ac3f1 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -121,7 +121,7 @@ static int twd_rate_change(struct notifier_block *nb,
 	 * changing cpu.
 	 */
 	if (flags == POST_RATE_CHANGE)
-		smp_call_function(twd_update_frequency,
+		on_each_cpu(twd_update_frequency,
 				  (void *)&cnd->new_rate, 1);
 
 	return NOTIFY_OK;
-- 
1.8.1.2

