Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3EGN7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:59:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185Ab3EGNly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/118] ARM: omap3: cpuidle: enable time keeping
Date: Tue,  7 May 2013 14:38:47 +0100
Message-Id: <1367933964-1564-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

commit 0d97558901c446a989de202a5d9ae94ec53644e5 upstream.

The TIME_VALID flag is specified for the different states but
the time residency computation is not done, no tk flag, no time
computation in the idle function.

Set the en_core_tk_irqen flag to activate it.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-omap2/cpuidle34xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 207bc1c..36f65a8 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -284,8 +284,9 @@ select_state:
 DEFINE_PER_CPU(struct cpuidle_device, omap3_idle_dev);
 
 struct cpuidle_driver omap3_idle_driver = {
-	.name = 	"omap3_idle",
-	.owner = 	THIS_MODULE,
+	.name             = "omap3_idle",
+	.owner            = THIS_MODULE,
+	.en_core_tk_irqen = 1,
 	.states = {
 		{
 			.enter		  = omap3_enter_idle,
-- 
1.8.1.2

