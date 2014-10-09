Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaJIVRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:17:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbaJIVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 150/163] cpufreq: integrator: fix integrator_cpufreq_remove return type
Date: Thu,  9 Oct 2014 14:02:55 -0700
Message-Id: <1412888588-26755-151-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit d62dbf77f7dfaa6fb455b4b9828069a11965929c upstream.

When building this driver as a module, we get a helpful warning
about the return type:

drivers/cpufreq/integrator-cpufreq.c:232:2: warning: initialization from incompatible pointer type
  .remove = __exit_p(integrator_cpufreq_remove),

If the remove callback returns void, the caller gets an undefined
value as it expects an integer to be returned. This fixes the
problem by passing down the value from cpufreq_unregister_driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/integrator-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
index 7d8ab000d..572955f 100644
--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -212,9 +212,9 @@ static int __init integrator_cpufreq_probe(struct platform_device *pdev)
 	return cpufreq_register_driver(&integrator_driver);
 }
 
-static void __exit integrator_cpufreq_remove(struct platform_device *pdev)
+static int __exit integrator_cpufreq_remove(struct platform_device *pdev)
 {
-	cpufreq_unregister_driver(&integrator_driver);
+	return cpufreq_unregister_driver(&integrator_driver);
 }
 
 static const struct of_device_id integrator_cpufreq_match[] = {
-- 
1.9.1

