Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaJJOry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:47:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:15342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaJJOrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:47:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398229175"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: [PATCH] io: accel: kxcjk-1013: Fix iio_event_spec direction
Date: Fri, 10 Oct 2014 17:53:32 +0300
Message-Id: <1412952812-974-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because IIO_EV_DIR_* are not bitmasks but enums,
IIO_EV_DIR_RISING | IIO_EV_DIR_FALLING is not equal
with IIO_EV_DIR_EITHER.

This could lead to potential misformatted sysfs attributes
like:
	* in_accel_x_thresh_(null)_en
	* in_accel_x_thresh_(null)_period
	* in_accel_x_thresh_(null)_value

or even memory corruption.

Fixes: b4b491c083 (iio: accel: kxcjk-1013: Support threshold)
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/accel/kxcjk-1013.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 98909a9..a23e58c 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -894,7 +894,7 @@ static const struct attribute_group kxcjk1013_attrs_group = {
 
 static const struct iio_event_spec kxcjk1013_event = {
 		.type = IIO_EV_TYPE_THRESH,
-		.dir = IIO_EV_DIR_RISING | IIO_EV_DIR_FALLING,
+		.dir = IIO_EV_DIR_EITHER,
 		.mask_separate = BIT(IIO_EV_INFO_VALUE) |
 				 BIT(IIO_EV_INFO_ENABLE) |
 				 BIT(IIO_EV_INFO_PERIOD)
-- 
1.9.1

