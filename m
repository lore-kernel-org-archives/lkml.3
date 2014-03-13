Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaCMQqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:46:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42824 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbaCMQqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:46:47 -0400
Date: Thu, 13 Mar 2014 09:46:43 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH] iio: force snprintf for PAGE_SIZE bufs
Message-ID: <20140313164643.GA19171@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a tiny preventative measure to make sure we can't write beyond
PAGE_SIZE on the buffers being used in sysfs for iio. There is currently
no way for this to happen, but the change makes this code more robust
for the future.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/iio/industrialio-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index acc911a836ca..64bb64f35af8 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -340,7 +340,7 @@ ssize_t iio_enum_read(struct iio_dev *indio_dev,
 	else if (i >= e->num_items)
 		return -EINVAL;
 
-	return sprintf(buf, "%s\n", e->items[i]);
+	return snprintf(buf, PAGE_SIZE, "%s\n", e->items[i]);
 }
 EXPORT_SYMBOL_GPL(iio_enum_read);
 
@@ -836,7 +836,7 @@ static ssize_t iio_show_dev_name(struct device *dev,
 				 char *buf)
 {
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
-	return sprintf(buf, "%s\n", indio_dev->name);
+	return snprintf(buf, PAGE_SIZE, "%s\n", indio_dev->name);
 }
 
 static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
