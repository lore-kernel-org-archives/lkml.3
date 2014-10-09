Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaJIVTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:19:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJIVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 070/163] iio:trigger: modify return value for iio_trigger_get
Date: Thu,  9 Oct 2014 14:01:35 -0700
Message-Id: <1412888588-26755-71-git-send-email-kamal@canonical.com>
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

commit f153566570fb9e32c2f59182883f4f66048788fb upstream.

Instead of a void function, return the trigger pointer.

Whilst not in of itself a fix, this makes the following set of
7 fixes cleaner than they would otherwise be.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/iio/trigger.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/iio/trigger.h b/include/linux/iio/trigger.h
index 369cf2c..68f46cd 100644
--- a/include/linux/iio/trigger.h
+++ b/include/linux/iio/trigger.h
@@ -84,10 +84,12 @@ static inline void iio_trigger_put(struct iio_trigger *trig)
 	put_device(&trig->dev);
 }
 
-static inline void iio_trigger_get(struct iio_trigger *trig)
+static inline struct iio_trigger *iio_trigger_get(struct iio_trigger *trig)
 {
 	get_device(&trig->dev);
 	__module_get(trig->ops->owner);
+
+	return trig;
 }
 
 /**
-- 
1.9.1

