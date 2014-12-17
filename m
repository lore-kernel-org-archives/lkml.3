Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaLQP7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:59:17 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:58263 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaLQP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:59:16 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] extcon: adc-jack: Release IIO channel on driver remove
Date: Wed, 17 Dec 2014 17:59:27 +0200
Message-Id: <1418831967-26066-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release IIO channel acquired during driver probe.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/extcon/extcon-adc-jack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index d860229..ce8c6ff 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -173,6 +173,7 @@ static int adc_jack_remove(struct platform_device *pdev)
 
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
+	iio_channel_release(data->chan);
 
 	return 0;
 }
-- 
1.9.1

