Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaBUAId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:08:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaBTXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.13 54/99] iio: max1363: Use devm_regulator_get_optional for optional regulator
Date: Thu, 20 Feb 2014 15:52:49 -0800
Message-Id: <20140220235119.771348958@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 55b40d37311807a6bb2acdae0df904f54a0da3ae upstream.

In kernel version 3.13, devm_regulator_get() may return no error
if a regulator is undeclared. regulator_get_voltage() will return
-EINVAL if this happens. This causes the driver to fail loading if
the vref regulator is not declared.

Since vref is optional, call devm_regulator_get_optional instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/max1363.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -1560,7 +1560,7 @@ static int max1363_probe(struct i2c_clie
 	st->client = client;
 
 	st->vref_uv = st->chip_info->int_vref_mv * 1000;
-	vref = devm_regulator_get(&client->dev, "vref");
+	vref = devm_regulator_get_optional(&client->dev, "vref");
 	if (!IS_ERR(vref)) {
 		int vref_uv;
 


