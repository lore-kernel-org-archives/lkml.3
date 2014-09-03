Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaICPMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:12:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:54189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbaICPMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:12:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,458,1406617200"; 
   d="scan'208";a="585676983"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: accel: kxcjk-1013: Fix defined but unused warning
Date: Wed,  3 Sep 2014 18:13:12 +0300
Message-Id: <1409757192-17546-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed when compiling with CONFIG_PM_RUNTIME not set:
kxcjk-1013.c: warning: ‘kxcjk1013_get_startup_times’ defined but not used [-Wunused-function]

Introduced by commit 124e1b1d (iio: accel: kxcjk-1013: support runtime pm).

Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/accel/kxcjk-1013.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 736231d..eb1b8b6 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -307,6 +307,7 @@ static int kxcjk1013_chip_init(struct kxcjk1013_data *data)
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
 {
 	int i;
@@ -318,6 +319,7 @@ static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
 
 	return KXCJK1013_MAX_STARTUP_TIME_US;
 }
+#endif
 
 static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
 {
-- 
1.9.1

