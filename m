Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942AbaDKQJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbaDKQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Fu <danifu@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 06/41] cpuidle: Check the result of cpuidle_get_driver() against NULL
Date: Fri, 11 Apr 2014 09:09:37 -0700
Message-Id: <20140411160933.313940597@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/driver.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -251,7 +251,8 @@ struct cpuidle_driver *cpuidle_driver_re
 	spin_lock(&cpuidle_driver_lock);
 
 	drv = cpuidle_get_driver();
-	drv->refcnt++;
+	if (drv)
+		drv->refcnt++;
 
 	spin_unlock(&cpuidle_driver_lock);
 	return drv;


