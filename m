Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3IKF37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:29:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3IKE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:23 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1HREAyyL-O0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yR6sNtVFCkkA:10 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=O3P8gX5oau-EmJ4nuaoA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042913.201187364@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [126/251] powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0126-powerpc-windfarm-Fix-noisy-slots-fan-on-Xserve-rm31.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit fe956a1d4081ce1a959f87df397a15e252201f10 ]

slots-fan on G5 Xserve is always running at full speed with windfarm_rm31
driver, resulting in a very high acoustic noise level. It seems the fan
parameters are incorrect, and have been copied from the Drive Bay fan
(RPM, not present on rm31) of the legacy therm_pm72 driver. This patch
changes the parameters to match the Slots fan (PWM) of therm_pm72. With
the patch, slots-fan speed drops from 99% to 19% during normal use,
and slots-temp settle to ~42'C.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <stable@vger.kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/macintosh/windfarm_rm31.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/macintosh/windfarm_rm31.c b/drivers/macintosh/windfarm_rm31.c
index 3eca6d4..e13d9fd 100644
--- a/drivers/macintosh/windfarm_rm31.c
+++ b/drivers/macintosh/windfarm_rm31.c
@@ -439,15 +439,15 @@ static void backside_setup_pid(void)
 
 /* Slots fan */
 static const struct wf_pid_param slots_param = {
-	.interval	= 5,
-	.history_len	= 2,
-	.gd		= 30 << 20,
-	.gp		= 5 << 20,
-	.gr		= 0,
-	.itarget	= 40 << 16,
-	.additive	= 1,
-	.min		= 300,
-	.max		= 4000,
+	.interval	= 1,
+	.history_len	= 20,
+	.gd		= 0,
+	.gp		= 0,
+	.gr		= 0x00100000,
+	.itarget	= 3200000,
+	.additive	= 0,
+	.min		= 20,
+	.max		= 100,
 };
 
 static void slots_fan_tick(void)
-- 
1.7.10.4


