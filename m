Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161666Ab3LFNC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44261 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161578Ab3LFNCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 149/272] cpufreq: highbank-cpufreq: Enable Midway/ECX-2000
Date: Fri,  6 Dec 2013 12:57:18 +0000
Message-Id: <1386334761-25517-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Langsdorf <mark.langsdorf@calxeda.com>

commit fbbc5bfb44a22e7a8ef753a1c8dfb448d7ac8b85 upstream.

Calxeda's new ECX-2000 part uses the same cpufreq interface as highbank,
so add it to the driver's compatibility list.

This is a minor change that can safely be applied to the 3.10 and 3.11
stable trees.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/highbank-cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index b61b5a3..8c4771d 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -66,7 +66,8 @@ static int hb_cpufreq_driver_init(void)
 	struct device_node *np;
 	int ret;
 
-	if (!of_machine_is_compatible("calxeda,highbank"))
+	if ((!of_machine_is_compatible("calxeda,highbank")) &&
+		(!of_machine_is_compatible("calxeda,ecx-2000")))
 		return -ENODEV;
 
 	for_each_child_of_node(of_find_node_by_path("/cpus"), np)
-- 
1.8.3.2

