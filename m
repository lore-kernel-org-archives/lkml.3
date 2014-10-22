Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaJVOeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:34:07 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49712 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaJVObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:40 -0400
X-ASG-Debug-ID: 1413988296-0759e74a717a4f20002-xx1T2L
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
Subject: [PATCH 07/13] power: reset: ltc2952: drop empty suspend/resume functions
Date: Wed, 22 Oct 2014 16:31:04 +0200
X-ASG-Orig-Subj: [PATCH 07/13] power: reset: ltc2952: drop empty suspend/resume functions
Message-ID: <1413988270-28092-8-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988297
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/SubmittingDrivers suggests these be implemented even when
they do nothing. On the other hand, the platform code calls these
functions 'legacy'. Suspend and resume operations should go into a
pm_ops structure, pointed at by the driver's pm field. This approach
would lead to a lot of boiler plate, while achieving nothing. Drop the
functions instead.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index bc8d228..af3cb6e 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -184,17 +184,6 @@ static void ltc2952_poweroff_kill(void)
 	gpiod_set_value(ltc2952_data->gpio_kill, 1);
 }
 
-static int ltc2952_poweroff_suspend(struct platform_device *pdev,
-	pm_message_t state)
-{
-	return -ENOSYS;
-}
-
-static int ltc2952_poweroff_resume(struct platform_device *pdev)
-{
-	return -ENOSYS;
-}
-
 static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
 	data->wde_interval = ktime_set(0, 300L*1E6L);
@@ -323,8 +312,6 @@ static struct platform_driver ltc2952_poweroff_driver = {
 		.owner = THIS_MODULE,
 		.of_match_table = of_ltc2952_poweroff_match,
 	},
-	.suspend = ltc2952_poweroff_suspend,
-	.resume = ltc2952_poweroff_resume,
 };
 
 module_platform_driver(ltc2952_poweroff_driver);
-- 
2.1.0

