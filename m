Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaLJP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:58:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:25936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635AbaLJP6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:58:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496704465"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 1/4] iio: accel: kxcjk-1013: always power on device in resume
Date: Wed, 10 Dec 2014 18:23:51 +0200
Message-Id: <1418228634-10505-2-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
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

