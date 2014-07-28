Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaG1Xpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:45:52 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37712 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaG1Xpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:45:49 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH] Staging: android: timed_output.c: use kstrtoint() instead of sscanf()
Date: Mon, 28 Jul 2014 20:45:06 -0300
Message-Id: <1406591106-2234-1-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes checkpatch.pl happy by fixing the following warning:

WARNING: Prefer kstrto<type> to single variable sscanf

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/android/timed_output.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/timed_output.c b/drivers/staging/android/timed_output.c
index c341ac1..b41429f 100644
--- a/drivers/staging/android/timed_output.c
+++ b/drivers/staging/android/timed_output.c
@@ -41,8 +41,10 @@ static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
 {
 	struct timed_output_dev *tdev = dev_get_drvdata(dev);
 	int value;
+	int rc;
 
-	if (sscanf(buf, "%d", &value) != 1)
+	rc = kstrtoint(buf, 0, &value);
+	if (rc != 0)
 		return -EINVAL;
 
 	tdev->enable(tdev, value);
-- 
1.7.10.4

