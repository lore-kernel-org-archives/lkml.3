Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaGVIRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:17:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10995 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaGVIRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:17:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-68-53ce1e0fd5ea
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH] mfd: max14577: Don't pass IRQ domain to mfd_add_devices
Date: Tue, 22 Jul 2014 10:17:14 +0200
Message-id: <1406017034-4023-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xK7r8cueCDaYvULd4/cLQ4v7Xo4wW
	l3fNYbM43c3qwOJx59oeNo95JwM9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+NJf0nBNdaK
	9W/3MDYwXmHpYuTkkBAwkbi+ahKULSZx4d56ti5GLg4hgaWMEue+bGeEcPqYJB69nsoKUsUm
	YCyxefkSNhBbRCBL4se01WDdzAKGEj/f/WHvYuTgEBbwl1i2KQ8kzCKgKtG9dRY7iM0r4CYx
	aclpJohlchInj01mncDIvYCRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGiNe/7mBceszq
	EKMAB6MSDy/Hi1PBQqyJZcWVuYcYJTiYlUR42/ecDRbiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	mDotyMz+IpuFPvfxRyXH7HSV1O+sncffmLd+0eSFDbz7nC+czuBZX/Fy5syWboO//7zYV6Tq
	PvC+9dhzoqzdiXQuC5G5vPeFb8r+7w2cp7KSgaP69KzlHwXTQ158UJvi7D3nru7l4zf3HPYo
	bb/1jrs0Wmf6n7DdK89vXHjErkc4b5+hkKHHZSWW4oxEQy3mouJEAFd3//nYAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max14577 MFD cells do not have any resources so the IRQ domain
passed to mfd_add_devices is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max14577.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 4a5e885383f8..ba2ac9c10b12 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -372,8 +372,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	}
 
 	ret = mfd_add_devices(max14577->dev, -1, mfd_devs,
-			mfd_devs_size, NULL, 0,
-			regmap_irq_get_domain(max14577->irq_data));
+			mfd_devs_size, NULL, 0, NULL);
 	if (ret < 0)
 		goto err_mfd;
 
-- 
1.9.1

