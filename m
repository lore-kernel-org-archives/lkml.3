Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaKJMpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:45:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:10698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbaKJMo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:44:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="634415466"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: [PATCH v4 3/7] iio: core: Introduce IIO_EV_DIR_NONE
Date: Mon, 10 Nov 2014 14:45:31 +0200
Message-Id: <1415623535-24337-4-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

For some events (e.g.: step detector) a direction does not make sense.

Add IIO_EV_DIR_NONE to be used with such events and generate sysfs event
attributes that do not contain direction.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/industrialio-event.c | 12 +++++++++---
 include/linux/iio/types.h        |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 0c1e37e..1290290 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -327,9 +327,15 @@ static int iio_device_add_event(struct iio_dev *indio_dev,
 	for_each_set_bit(i, mask, sizeof(*mask)*8) {
 		if (i >= ARRAY_SIZE(iio_ev_info_text))
 			return -EINVAL;
-		postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
-				iio_ev_type_text[type], iio_ev_dir_text[dir],
-				iio_ev_info_text[i]);
+		if (dir != IIO_EV_DIR_NONE)
+			postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
+					iio_ev_type_text[type],
+					iio_ev_dir_text[dir],
+					iio_ev_info_text[i]);
+		else
+			postfix = kasprintf(GFP_KERNEL, "%s_%s",
+					iio_ev_type_text[type],
+					iio_ev_info_text[i]);
 		if (postfix == NULL)
 			return -ENOMEM;
 
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index b3a241d..52cb532 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -86,6 +86,7 @@ enum iio_event_direction {
 	IIO_EV_DIR_EITHER,
 	IIO_EV_DIR_RISING,
 	IIO_EV_DIR_FALLING,
+	IIO_EV_DIR_NONE,
 };
 
 #define IIO_VAL_INT 1
-- 
1.9.1

