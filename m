Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaJIVL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbaJIVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 073/163] iio: hid_sensor_hub: Fix indio_dev->trig assignment
Date: Thu,  9 Oct 2014 14:01:38 -0700
Message-Id: <1412888588-26755-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 55a6f9ddfdea0d2d343cd1b39baf8aa752664b6e upstream.

This can result in wrong reference count for trigger device, call
iio_trigger_get to increment reference.
Refer to http://www.spinics.net/lists/linux-iio/msg13669.html for discussion
with Jonathan.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
index 7dcf839..1be235b 100644
--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -99,7 +99,8 @@ int hid_sensor_setup_trigger(struct iio_dev *indio_dev, const char *name,
 		dev_err(&indio_dev->dev, "Trigger Register Failed\n");
 		goto error_free_trig;
 	}
-	indio_dev->trig = attrb->trigger = trig;
+	attrb->trigger = trig;
+	indio_dev->trig = iio_trigger_get(trig);
 
 	return ret;
 
-- 
1.9.1

