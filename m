Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3HTJa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:30:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35467 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3HTJa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:26 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 19/19] cpufreq: pmac32-cpufreq: remove device tree parsing for cpu nodes
Date: Tue, 20 Aug 2013 10:30:21 +0100
Message-Id: <1376991021-12160-20-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:22.0927 (UTC) FILETIME=[E50C7DF0:01CE9D87]
X-MC-Unique: 113082010302412001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9VJw2012263

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Now that the cpu device registration initialises the of_node(if available)
appropriately for all the cpus, parsing here is redundant.

This patch removes DT parsing and uses cpu->of_node instead.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/cpufreq/pmac32-cpufreq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3104fad..56bfb6f 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/hardirq.h>
+#include <linux/of_device.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/irq.h>
@@ -649,8 +650,8 @@ static int __init pmac_cpufreq_setup(void)
 	if (strstr(cmd_line, "nocpufreq"))
 		return 0;
 
-	/* Assume only one CPU */
-	cpunode = of_find_node_by_type(NULL, "cpu");
+	/* Get first CPU node */
+	cpunode = of_cpu_device_node_get(0);
 	if (!cpunode)
 		goto out;
 
-- 
1.8.1.2


