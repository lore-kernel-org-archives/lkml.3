Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaG3Fvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 01:51:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60293 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaG3Fvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 01:51:31 -0400
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lejun Zhu <lejun.zhu@linux.intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH] input: ads7846: Release resources on failure for clean exit
Date: Wed, 30 Jul 2014 11:24:37 +0530
Message-Id: <1406699677-1347-1-git-send-email-pramod.gurav.etc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pramod Gurav <pramod.gurav@smartplayin.com>

Input device must be released(input_free_device) when ads7846_probe_dt
fails. This fixes the same by releasing resources on failure.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Lejun Zhu <lejun.zhu@linux.intel.com>
CC: Sachin Kamat <sachin.kamat@linaro.org>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/touchscreen/ads7846.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index da201b8..e57ba52 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -1302,8 +1302,10 @@ static int ads7846_probe(struct spi_device *spi)
 	pdata = dev_get_platdata(&spi->dev);
 	if (!pdata) {
 		pdata = ads7846_probe_dt(&spi->dev);
-		if (IS_ERR(pdata))
-			return PTR_ERR(pdata);
+		if (IS_ERR(pdata)) {
+			err = PTR_ERR(pdata);
+			goto err_free_mem;
+		}
 	}
 
 	ts->model = pdata->model ? : 7846;
-- 
1.7.9.5

