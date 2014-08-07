Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaHGXCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:02:33 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1161 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaHGXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:02:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Aug 2014 15:49:21 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 3/3] cpuidle: big.LITTLE: Use of_match_machine
Date: Fri, 8 Aug 2014 02:01:55 +0300
Message-ID: <1407452515-2390-4-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper function, also fixing a device_node refcount leak.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
Compile tested only.

 drivers/cpuidle/cpuidle-big_little.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index 344d79fa..53524c8 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -172,15 +172,11 @@ static const struct of_device_id compatible_machine_match[] = {
 static int __init bl_idle_init(void)
 {
 	int ret;
-	struct device_node *root = of_find_node_by_path("/");
-
-	if (!root)
-		return -ENODEV;
 
 	/*
 	 * Initialize the driver just for a compliant set of machines
 	 */
-	if (!of_match_node(compatible_machine_match, root))
+	if (!of_match_machine(compatible_machine_match))
 		return -ENODEV;
 	/*
 	 * For now the differentiation between little and big cores
-- 
1.8.1.5

