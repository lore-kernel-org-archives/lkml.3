Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaCCTJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:09:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56073 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaCCS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hartmut Knaack <knaack.h@gmx.de>, Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 21/67] staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested
Date: Mon,  3 Mar 2014 10:55:09 -0800
Message-Id: <1393872955-28810-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hartmut Knaack <knaack.h@gmx.de>

commit 38408d056188be29a6c4e17f3703c796551bb330 upstream.

Only free an IRQ in error_free_irq, if it has been requested previously.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/adc/ad799x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/ad799x_core.c b/drivers/staging/iio/adc/ad799x_core.c
index 077eedb..01ba328 100644
--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@ -918,7 +918,8 @@ static int ad799x_probe(struct i2c_client *client,
 	return 0;
 
 error_free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq > 0)
+		free_irq(client->irq, indio_dev);
 error_cleanup_ring:
 	ad799x_ring_cleanup(indio_dev);
 error_disable_reg:
-- 
1.8.3.2

