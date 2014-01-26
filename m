Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaAZKiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:38:52 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:43909 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZKiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:38:50 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] mfd: max14577: max14577_{suspend,resume}() should depend on CONFIG_PM_SLEEP
Date: Sun, 26 Jan 2014 11:38:42 +0100
Message-Id: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_SLEEP=n:

drivers/mfd/max14577.c:177: warning: ‘max14577_suspend’ defined but not used
drivers/mfd/max14577.c:200: warning: ‘max14577_resume’ defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/max14577.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index ac514fb2b877..71aa14a6bfbb 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
 
+#ifdef CONFIG_PM_SLEEP
 static int max14577_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static struct of_device_id max14577_dt_match[] = {
 	{ .compatible = "maxim,max14577", },
-- 
1.7.9.5

