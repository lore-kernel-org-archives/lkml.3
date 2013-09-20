Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3ITUOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3ITUOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 39/93] cpuidle: coupled: disable interrupts after entering safe state
Date: Fri, 20 Sep 2013 13:08:34 -0700
Message-Id: <1379707768-1804-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Cross <ccross@android.com>

commit 59e998561103a93f294c8d3138dd659af772a5da upstream.

Calling cpuidle_enter_state is expected to return with interrupts
enabled, but interrupts must be disabled before starting the
ready loop synchronization stage.  Call local_irq_disable after
each call to cpuidle_enter_state for the safe state.

Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpuidle/coupled.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index dc9e647..5d39627 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -470,6 +470,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
 		}
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
+		local_irq_disable();
 	}
 
 	/* Read barrier ensures online_count is read after prevent is cleared */
@@ -514,6 +515,7 @@ retry:
 
 		entered_state = cpuidle_enter_state(dev, drv,
 			dev->safe_state_index);
+		local_irq_disable();
 	}
 
 	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
-- 
1.8.1.2

