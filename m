Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbaJCXV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:21:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbaJCWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.14 137/238] iio: hid_sensor_hub: Fix indio_dev->trig assignment
Date: Fri,  3 Oct 2014 14:30:52 -0700
Message-Id: <20141003212918.057586534@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 55a6f9ddfdea0d2d343cd1b39baf8aa752664b6e upstream.

This can result in wrong reference count for trigger device, call
iio_trigger_get to increment reference.
Refer to http://www.spinics.net/lists/linux-iio/msg13669.html for discussion
with Jonathan.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
@@ -99,7 +99,8 @@ int hid_sensor_setup_trigger(struct iio_
 		dev_err(&indio_dev->dev, "Trigger Register Failed\n");
 		goto error_free_trig;
 	}
-	indio_dev->trig = attrb->trigger = trig;
+	attrb->trigger = trig;
+	indio_dev->trig = iio_trigger_get(trig);
 
 	return ret;
 


