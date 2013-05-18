Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3ERCaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:30:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab3ERCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:46 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1sG_TC4Nb0UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fkzfQ3cOVdcA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=wkzLfugtW1I-i3wnKuEA:9 a=WwgC8nHKvroA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021642.329058020@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [ 003/136 ] ARM: omap3: cpuidle: enable time keeping
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0003-ARM-omap3-cpuidle-enable-time-keeping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

[ Upstream commit 0d97558901c446a989de202a5d9ae94ec53644e5 ]

The TIME_VALID flag is specified for the different states but
the time residency computation is not done, no tk flag, no time
computation in the idle function.

Set the en_core_tk_irqen flag to activate it.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-omap2/cpuidle34xx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index f2a49a4..6fa5ac4 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -265,8 +265,9 @@ static int omap3_enter_idle_bm(struct cpuidle_device *dev,
 DEFINE_PER_CPU(struct cpuidle_device, omap3_idle_dev);
 
 struct cpuidle_driver omap3_idle_driver = {
-	.name = 	"omap3_idle",
-	.owner = 	THIS_MODULE,
+	.name             = "omap3_idle",
+	.owner            = THIS_MODULE,
+	.en_core_tk_irqen = 1,
 	.states = {
 		{
 			.enter		  = omap3_enter_idle_bm,
-- 
1.7.10.4


