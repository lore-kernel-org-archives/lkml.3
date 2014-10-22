Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaJVOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:33:27 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49762 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaJVObo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:44 -0400
X-ASG-Debug-ID: 1413988300-0759e74a717a4f50002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 09/13] power: reset: ltc2952: fix C++ style function pointers
Date: Wed, 22 Oct 2014 16:31:06 +0200
X-ASG-Orig-Subj: [PATCH 09/13] power: reset: ltc2952: fix C++ style function pointers
Message-ID: <1413988270-28092-10-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988301
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_RULE_7582B
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE_7582B         Custom Rule 7582B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointers for the timers and pm_power_off are assigned with
C++ style
	foo = &func;

Let's change it instead to the more C style
	foo = func;

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 70d8e3a..8ab1da6 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -182,10 +182,10 @@ static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 	data->trigger_delay = ktime_set(2, 500L*1E6L);
 
 	hrtimer_init(&data->timer_trigger, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	data->timer_trigger.function = &ltc2952_poweroff_timer_trigger;
+	data->timer_trigger.function = ltc2952_poweroff_timer_trigger;
 
 	hrtimer_init(&data->timer_wde, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	data->timer_wde.function = &ltc2952_poweroff_timer_wde;
+	data->timer_wde.function = ltc2952_poweroff_timer_wde;
 }
 
 static int ltc2952_poweroff_init(struct platform_device *pdev)
@@ -270,7 +270,7 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 
 	/* TODO: remove ltc2952_data */
 	ltc2952_data = data;
-	pm_power_off = &ltc2952_poweroff_kill;
+	pm_power_off = ltc2952_poweroff_kill;
 
 	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
 	atomic_notifier_chain_register(&panic_notifier_list,
-- 
2.1.0

