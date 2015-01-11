Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbbAKTLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:11:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:3387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbbAKTLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:11:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,739,1413270000"; 
   d="scan'208";a="660161300"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 06/10] iio: core: Remove IIO_EV_TYPE_INSTANCE
Date: Sun, 11 Jan 2015 21:10:12 +0200
Message-Id: <1421003416-27557-7-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By introducing IIO_EV_TYPE_CHANGE, IIO_EV_TYPE_INSTANCE becomes redundant.
The effect of IIO_EV_TYPE_INSTANCE can be obtained by using IIO_EV_TYPE_CHANGE
with IIO_EV_INFO_VALUE set to 1.

Remove all instances of IIO_EV_TYPE_INSTANCE and replace them with
IIO_EV_TYPE_CHANGE where needed.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/iio/industrialio-event.c                      | 1 -
 drivers/staging/iio/Documentation/iio_event_monitor.c | 2 --
 drivers/staging/iio/iio_simple_dummy.c                | 2 +-
 drivers/staging/iio/iio_simple_dummy_events.c         | 4 ++--
 include/linux/iio/types.h                             | 1 -
 5 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 08c4a4c..b5663f6 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -197,7 +197,6 @@ static const char * const iio_ev_type_text[] = {
 	[IIO_EV_TYPE_ROC] = "roc",
 	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
 	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
-	[IIO_EV_TYPE_INSTANCE] = "instance",
 	[IIO_EV_TYPE_CHANGE] = "change",
 };
 
diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
index 2e78d58..72c96aa 100644
--- a/drivers/staging/iio/Documentation/iio_event_monitor.c
+++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
@@ -59,7 +59,6 @@ static const char * const iio_ev_type_text[] = {
 	[IIO_EV_TYPE_ROC] = "roc",
 	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
 	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
-	[IIO_EV_TYPE_INSTANCE] = "instance",
 	[IIO_EV_TYPE_CHANGE] = "change",
 };
 
@@ -179,7 +178,6 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_EV_TYPE_ROC:
 	case IIO_EV_TYPE_THRESH_ADAPTIVE:
 	case IIO_EV_TYPE_MAG_ADAPTIVE:
-	case IIO_EV_TYPE_INSTANCE:
 	case IIO_EV_TYPE_CHANGE:
 		break;
 	default:
diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
index 0b8611a..e452021 100644
--- a/drivers/staging/iio/iio_simple_dummy.c
+++ b/drivers/staging/iio/iio_simple_dummy.c
@@ -73,7 +73,7 @@ static const struct iio_event_spec iio_dummy_event = {
  * simple step detect event - triggered when a step is detected
  */
 static const struct iio_event_spec step_detect_event = {
-	.type = IIO_EV_TYPE_INSTANCE,
+	.type = IIO_EV_TYPE_CHANGE,
 	.dir = IIO_EV_DIR_NONE,
 	.mask_separate = BIT(IIO_EV_INFO_ENABLE),
 };
diff --git a/drivers/staging/iio/iio_simple_dummy_events.c b/drivers/staging/iio/iio_simple_dummy_events.c
index ac15a44..a5cd3bb 100644
--- a/drivers/staging/iio/iio_simple_dummy_events.c
+++ b/drivers/staging/iio/iio_simple_dummy_events.c
@@ -86,7 +86,7 @@ int iio_simple_dummy_write_event_config(struct iio_dev *indio_dev,
 		}
 	case IIO_STEPS:
 		switch (type) {
-		case IIO_EV_TYPE_INSTANCE:
+		case IIO_EV_TYPE_CHANGE:
 			st->event_en = state;
 			break;
 		default:
@@ -201,7 +201,7 @@ static irqreturn_t iio_simple_dummy_event_handler(int irq, void *private)
 		iio_push_event(indio_dev,
 			       IIO_EVENT_CODE(IIO_STEPS, 0, IIO_NO_MOD,
 					      IIO_EV_DIR_NONE,
-					      IIO_EV_TYPE_INSTANCE, 0, 0, 0),
+					      IIO_EV_TYPE_CHANGE, 0, 0, 0),
 			       iio_get_time_ns());
 		break;
 	default:
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 3ba3d66..580ed5b 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -78,7 +78,6 @@ enum iio_event_type {
 	IIO_EV_TYPE_ROC,
 	IIO_EV_TYPE_THRESH_ADAPTIVE,
 	IIO_EV_TYPE_MAG_ADAPTIVE,
-	IIO_EV_TYPE_INSTANCE,
 	IIO_EV_TYPE_CHANGE,
 };
 
-- 
1.9.1

