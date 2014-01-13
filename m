Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaAMQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:34 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34351 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753573AbaAMQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] iio: mxs-lradc: fix buffer overflow
Date: Mon, 13 Jan 2014 17:02:01 +0100
Message-Id: <1389628923-8689-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
drivers/staging/iio/adc/mxs-lradc.c:1556 mxs_lradc_probe() error: buffer
overflow 'iio->channels' 15 <= 15

The reported available scales for in_voltage15 were also wrong.

The realbits lookup is not necessary as all the channels of the LRADC have the
same resolution, use LRADC_RESOLUTION instead.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index df71669bb60e..aa86849daeba 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1613,7 +1613,7 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 			 * of the array.
 			 */
 			scale_uv = ((u64)lradc->vref_mv[i] * 100000000) >>
-				   (iio->channels[i].scan_type.realbits - s);
+				   (LRADC_RESOLUTION - s);
 			lradc->scale_avail[i][s].nano =
 					do_div(scale_uv, 100000000) * 10;
 			lradc->scale_avail[i][s].integer = scale_uv;
-- 
1.8.3.2

