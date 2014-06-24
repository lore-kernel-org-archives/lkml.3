Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965090AbaFXP4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:56:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbaFXP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 43/61] iio: adc: checking for NULL instead of IS_ERR() in probe
Date: Tue, 24 Jun 2014 11:51:26 -0400
Message-Id: <20140624154954.742618212@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e94f62e79f7f63a68574ee5e76c19837ec12f3db upstream.

mcb_request_mem() returns an ERR_PTR(), it doesn't return NULL.

Fixes: 74aeac4da66f ('iio: adc: Add MEN 16z188 ADC driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/men_z188_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -121,8 +121,8 @@ static int men_z188_probe(struct mcb_dev
 	indio_dev->num_channels = ARRAY_SIZE(z188_adc_iio_channels);
 
 	mem = mcb_request_mem(dev, "z188-adc");
-	if (!mem)
-		return -ENOMEM;
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
 
 	adc->base = ioremap(mem->start, resource_size(mem));
 	if (adc->base == NULL)


