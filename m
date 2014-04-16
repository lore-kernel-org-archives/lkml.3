Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaDPKdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:33:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaDPKdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Fu <danifu@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 38/46] cpuidle: Check the result of cpuidle_get_driver() against NULL
Date: Wed, 16 Apr 2014 11:31:54 +0100
Message-Id: <1397644322-13905-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Fu <danifu@nvidia.com>

commit 3b9c10e98021e1f92e6f8c7ce1778b86ba68db10 upstream.

If the current CPU has no cpuidle driver, drv will be NULL in
cpuidle_driver_ref().  Check if that is the case before trying
to bump up the driver's refcount to prevent the kernel from
crashing.

[rjw: Subject and changelog]
Signed-off-by: Daniel Fu <danifu@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpuidle/driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 3ac499d..6e11701 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -331,7 +331,8 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
 	spin_lock(&cpuidle_driver_lock);
 
 	drv = cpuidle_get_driver();
-	drv->refcnt++;
+	if (drv)
+		drv->refcnt++;
 
 	spin_unlock(&cpuidle_driver_lock);
 	return drv;
-- 
1.9.1

