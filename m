Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3GOOXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:23:00 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:47002 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab3GOOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:22:57 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Vasut <marex@denx.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/5] ARM: mxs-lradc: Simplify mxs_lradc_trigger_init error handle
Date: Mon, 15 Jul 2013 11:22:37 -0300
Message-Id: <1373898160-8460-2-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have a 'ret' variable with the iio_trigger_register return, this
can be used as result.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 drivers/staging/iio/adc/mxs-lradc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index d92c97a..6d41846 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -671,14 +671,12 @@ static int mxs_lradc_trigger_init(struct iio_dev *iio)
 	trig->ops = &mxs_lradc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret) {
+	if (ret)
 		iio_trigger_free(trig);
-		return ret;
-	}
 
 	iio->trig = trig;
 
-	return 0;
+	return ret;
 }
 
 static void mxs_lradc_trigger_remove(struct iio_dev *iio)
-- 
1.8.3.2

