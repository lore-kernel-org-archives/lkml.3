Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaAFUaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:30:17 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62138 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbaAFUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:30:15 -0500
Message-ID: <1389040212.2562.3.camel@x41>
Subject: [PATCH] cpufreq: speedstep: remove unused speedstep_get_state
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 21:30:12 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2014 20:30:13.0631 (UTC) FILETIME=[1A5DC0F0:01CF0B1E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only caller of speedstep_get_state() was removed in commit d4019f0a92ab
("cpufreq: move freq change notifications to cpufreq core"). So building
speedstep-smi.o now triggers a GCC warning:
    drivers/cpufreq/speedstep-smi.c:148:12: warning: 'speedstep_get_state' defined but not used [-Wunused-function]

Remove this unused function.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This seems to be a rather obvious fix. Hasn't it been submitted before?

 drivers/cpufreq/speedstep-smi.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index 0f5326d..998c17b 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -141,38 +141,6 @@ static int speedstep_smi_get_freqs(unsigned int *low, unsigned int *high)
 }
 
 /**
- * speedstep_get_state - set the SpeedStep state
- * @state: processor frequency state (SPEEDSTEP_LOW or SPEEDSTEP_HIGH)
- *
- */
-static int speedstep_get_state(void)
-{
-	u32 function = GET_SPEEDSTEP_STATE;
-	u32 result, state, edi, command, dummy;
-
-	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
-
-	pr_debug("trying to determine current setting with command %x "
-		"at port %x\n", command, smi_port);
-
-	__asm__ __volatile__(
-		"push %%ebp\n"
-		"out %%al, (%%dx)\n"
-		"pop %%ebp\n"
-		: "=a" (result),
-		  "=b" (state), "=D" (edi),
-		  "=c" (dummy), "=d" (dummy), "=S" (dummy)
-		: "a" (command), "b" (function), "c" (0),
-		  "d" (smi_port), "S" (0), "D" (0)
-	);
-
-	pr_debug("state is %x, result is %x\n", state, result);
-
-	return state & 1;
-}
-
-
-/**
  * speedstep_set_state - set the SpeedStep state
  * @state: new processor frequency state (SPEEDSTEP_LOW or SPEEDSTEP_HIGH)
  *
-- 
1.8.1.4

