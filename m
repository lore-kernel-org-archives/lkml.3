Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3IRMVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:21:33 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47191 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3IRMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:15:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/41] ARM: ux500: Don't attempt to enable the Nomadik System Timer twice
Date: Wed, 18 Sep 2013 13:14:17 +0100
Message-Id: <1379506478-16625-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with DT enabled we already call clocksource_of_init(),
which in turn calls the OF version of nmdk_timer_init().

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/timer.c b/arch/arm/mach-ux500/timer.c
index b6bd0ef..05a4ff7 100644
--- a/arch/arm/mach-ux500/timer.c
+++ b/arch/arm/mach-ux500/timer.c
@@ -97,8 +97,8 @@ dt_fail:
 	 * sched_clock with higher rating then MTU since is always-on.
 	 *
 	 */
-
-	nmdk_timer_init(mtu_timer_base, IRQ_MTU0);
+	if (!of_have_populated_dt())
+		nmdk_timer_init(mtu_timer_base, IRQ_MTU0);
 	clksrc_dbx500_prcmu_init(prcmu_timer_base);
 	ux500_twd_init();
 }
-- 
1.8.1.2

