Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab3CZPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:21:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53554 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934760Ab3CZPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/150] hwmon: (sht15) Fix memory leak if regulator_enable() fails
Date: Tue, 26 Mar 2013 15:18:39 +0000
Message-Id: <1364311249-14454-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Commit 3e78080f8148 ('hwmon: (sht15) Check return value of
regulator_enable()') depends on the use of devm_kmalloc() for automatic
resource cleanup in the failure cases, which was introduced in 3.7.  In
older stable branches, explicit cleanup is needed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/sht15.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index eb01802..c689630 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -930,7 +930,7 @@ static int __devinit sht15_probe(struct platform_device *pdev)
 		if (ret != 0) {
 			dev_err(&pdev->dev,
 				"failed to enable regulator: %d\n", ret);
-			return ret;
+			goto err_free_data;
 		}
 
 		/*
-- 
1.8.1.2

