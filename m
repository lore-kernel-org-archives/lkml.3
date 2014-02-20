Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaBTXwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:52:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaBTXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.12 39/82] staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested
Date: Thu, 20 Feb 2014 15:52:22 -0800
Message-Id: <20140220235020.646061257@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hartmut Knaack <knaack.h@gmx.de>

commit 38408d056188be29a6c4e17f3703c796551bb330 upstream.

Only free an IRQ in error_free_irq, if it has been requested previously.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/ad799x_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/iio/adc/ad799x_core.c
+++ b/drivers/staging/iio/adc/ad799x_core.c
@@ -644,7 +644,8 @@ static int ad799x_probe(struct i2c_clien
 	return 0;
 
 error_free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq > 0)
+		free_irq(client->irq, indio_dev);
 error_cleanup_ring:
 	ad799x_ring_cleanup(indio_dev);
 error_disable_reg:


