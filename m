Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaBUNSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:18:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115AbaBUNCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hartmut Knaack <knaack.h@gmx.de>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 28/60] staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested
Date: Fri, 21 Feb 2014 13:00:55 +0000
Message-Id: <1392987687-15367-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hartmut Knaack <knaack.h@gmx.de>

commit 38408d056188be29a6c4e17f3703c796551bb330 upstream.

Only free an IRQ in error_free_irq, if it has been requested previously.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/adc/ad799x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/ad799x_core.c b/drivers/staging/iio/adc/ad799x_core.c
index 80e0c6e..b50d1df 100644
--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@ -911,7 +911,8 @@ static int __devinit ad799x_probe(struct i2c_client *client,
 	return 0;
 
 error_free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq > 0)
+		free_irq(client->irq, indio_dev);
 error_cleanup_ring:
 	ad799x_ring_cleanup(indio_dev);
 error_disable_reg:
-- 
1.9.0

