Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3ITUZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:25:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ITUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>, Bryan Wu <cooloney@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 42/93] leds: wm831x-status: Request a REG resource
Date: Fri, 20 Sep 2013 13:08:37 -0700
Message-Id: <1379707768-1804-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 61abeba5222895d6900b13115f5d8eba7988d7d6 upstream.

The wm831x-status driver was not converted to use a REG resource when they
were introduced and the rest of the wm831x drivers converted, causing it
to fail to probe due to requesting the wrong resource type.

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/leds/leds-wm831x-status.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index 74a24cf..cb9ee1e 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -230,9 +230,9 @@ static int wm831x_status_probe(struct platform_device *pdev)
 	int id = pdev->id % ARRAY_SIZE(chip_pdata->status);
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (res == NULL) {
-		dev_err(&pdev->dev, "No I/O resource\n");
+		dev_err(&pdev->dev, "No register resource\n");
 		ret = -EINVAL;
 		goto err;
 	}
-- 
1.8.1.2

