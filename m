Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaLJP6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:58:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:64506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbaLJP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496704492"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 2/4] iio: accel: kxcjk-1013: only set power state if CONFIG_PM is defined
Date: Wed, 10 Dec 2014 18:23:52 +0200
Message-Id: <1418228634-10505-3-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM is not defined and the driver tries to power off the device,
kxcjk1013_set_power_state will call pm_runtime_put_autosuspend, which is
not implemented (wil return -ENOSYS).

Only call pm_runtime calls to change power state  when CONFIG_PM is defined.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/accel/kxcjk-1013.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index aed3777..7b0a9da 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -376,6 +376,7 @@ static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
 
 static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
 {
+#ifdef CONFIG_PM
 	int ret;
 
 	if (on)
@@ -389,6 +390,7 @@ static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
 			"Failed: kxcjk1013_set_power_state for %d\n", on);
 		return ret;
 	}
+#endif
 
 	return 0;
 }
-- 
1.7.9.5

