Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaLEVxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:53:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:34419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaLEVwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:52:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,525,1413270000"; 
   d="scan'208";a="633469727"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 1/4] iio: accel: kxcjk-1013: always power on device in resume
Date: Sat,  6 Dec 2014 00:18:07 +0200
Message-Id: <1417817890-10252-2-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com>
References: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system resumes, it will first call system resume and
then runtime suspend (if CONFIG_RUNTIME_PM is enabled).
There is no need to conditionally power on the device in
system resume, so always power it on and leave runtime
suspend to power it off if needed.

Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/accel/kxcjk-1013.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 1720e9a..aed3777 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1354,10 +1354,7 @@ static int kxcjk1013_resume(struct device *dev)
 	int ret = 0;
 
 	mutex_lock(&data->mutex);
-	/* Check, if the suspend occured while active */
-	if (data->dready_trigger_on || data->motion_trigger_on ||
-							data->ev_enable_state)
-		ret = kxcjk1013_set_mode(data, OPERATION);
+	ret = kxcjk1013_set_mode(data, OPERATION);
 	mutex_unlock(&data->mutex);
 
 	return ret;
-- 
1.7.9.5

