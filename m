Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaAZKi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:38:57 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:54954 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAZKix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:38:53 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] mfd: sec-core: sec_pmic_{suspend,resume}() should depend on CONFIG_PM_SLEEP
Date: Sun, 26 Jan 2014 11:38:43 +0100
Message-Id: <1390732723-7129-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_SLEEP=n:

drivers/mfd/sec-core.c:349: warning: ‘sec_pmic_suspend’ defined but not used
drivers/mfd/sec-core.c:371: warning: ‘sec_pmic_resume’ defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/sec-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index e4671088f075..dbc39e676cbd 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -345,6 +345,7 @@ static int sec_pmic_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int sec_pmic_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -379,6 +380,7 @@ static int sec_pmic_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(sec_pmic_pm_ops, sec_pmic_suspend, sec_pmic_resume);
 
-- 
1.7.9.5

