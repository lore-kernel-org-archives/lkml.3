Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3JAPlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:41:42 -0400
Received: from smtp141.dfw.emailsrvr.com ([67.192.241.141]:35713 "EHLO
	smtp141.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3JAPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:41:40 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 11:41:40 EDT
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH] cpufreq: highbank-cpufreq: Enable Midway/ECX-2000
Date: Tue,  1 Oct 2013 10:30:24 -0500
Message-Id: <1380641424-5666-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calxeda's new ECX-2000 part uses the same cpufreq interface as highbank,
so add it to the driver's compatibility list.

This is a minor change that can safely be applied to the 3.10 and 3.11
stable trees.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
 drivers/cpufreq/highbank-cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index 794123f..bf8902a 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -66,7 +66,8 @@ static int hb_cpufreq_driver_init(void)
 	struct device_node *np;
 	int ret;
 
-	if (!of_machine_is_compatible("calxeda,highbank"))
+	if ((!of_machine_is_compatible("calxeda,highbank")) &&
+		(!of_machine_is_compatible("calxeda,ecx-2000")))
 		return -ENODEV;
 
 	cpu_dev = get_cpu_device(0);
-- 
1.8.1.2

