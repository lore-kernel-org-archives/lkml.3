Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaKFWnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaKFWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/162] iio: mxs-lradc: Propagate the real error code on platform_get_irq() failure
Date: Thu,  6 Nov 2014 14:36:14 -0800
Message-Id: <1415313426-9622-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 9610e08e97370ca7780bea977b03355fa0261635 upstream.

No need to return a 'fake' return value on platform_get_irq() failure.

Just return the error code itself instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ kamal: 3.13-stable prereq for
  75d7ed3 iio: adc: mxs-lradc: Disable the clock on probe failure ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 558a76c..cef5dde 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1308,7 +1308,7 @@ static int mxs_lradc_probe(struct platform_device *pdev)
 	for (i = 0; i < of_cfg->irq_count; i++) {
 		lradc->irq[i] = platform_get_irq(pdev, i);
 		if (lradc->irq[i] < 0)
-			return -EINVAL;
+			return lradc->irq[i];
 
 		ret = devm_request_irq(dev, lradc->irq[i],
 					mxs_lradc_handle_irq, 0,
-- 
1.9.1

