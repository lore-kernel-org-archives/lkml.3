Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3IYAVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:21:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab3IYAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Brown <broonie@linaro.org>, Bryan Wu <cooloney@gmail.com>
Subject: [ 092/117] leds: wm831x-status: Request a REG resource
Date: Tue, 24 Sep 2013 17:19:18 -0700
Message-Id: <20130925001750.966065104@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 61abeba5222895d6900b13115f5d8eba7988d7d6 upstream.

The wm831x-status driver was not converted to use a REG resource when they
were introduced and the rest of the wm831x drivers converted, causing it
to fail to probe due to requesting the wrong resource type.

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/leds/leds-wm831x-status.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -230,9 +230,9 @@ static int wm831x_status_probe(struct pl
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


