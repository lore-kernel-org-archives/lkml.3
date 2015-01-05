Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbbAEJM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:12:29 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31337 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbAEJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:43 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-54-54aa52f676cb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 08/14] mfd: pcf50633: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:27 +0100
Message-id: <1420448493-9355-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xa7rfglaFGFxq5rZ4/cLQ4v7Xo4wW
	l3fNYbM43c3qwOJx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2P31hVsBVPZ
	Kr6te8bUwDibtYuRk0NCwERi181NTBC2mMSFe+vZuhi5OIQEljJKLNl6iBHC6WOSuDFlEzNI
	FZuAscTm5UvYQGwRgSyJH9NWs4DYzAKGEj/f/WEHsYUFnCXmrzoHtoFFQFXiyPovYHFeATeJ
	bc/OMUJsk5M4eWwyUA0HB6eAu8Ttx5EgphBQyb+3CRMYeRcwMqxiFE0tTS4oTkrPNdQrTswt
	Ls1L10vOz93ECAmSLzsYFx+zOsQowMGoxMPrcWJliBBrYllxZe4hRgkOZiUR3nW3gEK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoY6z99Y7fxjL2Vz27d0r7U7rB3bO/O40fCrVXyD1n/XRSdW7OA
	dWYqu0mFKXvGS3al+Xs4gyJzPNd3hKxq+pIn5X78+gohxvhvVstXNiyeej7mr1nYQam0dyc2
	uPasavnKutQl6Y12c+DJCv7SHXGtN59pL4n7XqCQqWQirm+usL9r4YHAh9VKLMUZiYZazEXF
	iQBpztMt8AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/pcf50633-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 43664eb69c93..6155d123a84e 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -183,7 +183,7 @@ static int pcf50633_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(pcf50633_pm, pcf50633_suspend, pcf50633_resume);
 
-static struct regmap_config pcf50633_regmap_config = {
+static const struct regmap_config pcf50633_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

