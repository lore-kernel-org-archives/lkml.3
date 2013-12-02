Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3LBTS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab3LBTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 173/212] cpufreq: highbank-cpufreq: Enable Midway/ECX-2000
Date: Mon,  2 Dec 2013 11:16:04 -0800
Message-Id: <20131202191307.523815922@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/highbank-cpufreq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


