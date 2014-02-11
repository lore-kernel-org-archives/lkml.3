Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaBKNEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:04:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34136 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaBKNEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-1d-52fa1fcc5e46
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 01/14] mfd: sec: Add maximum RTC register for regmap config
Date: Tue, 11 Feb 2014 14:03:44 +0100
Message-id: <1392123837-5517-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7pn5H8FGXw6K2CxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlTFr+nvWgikcFU1zGtkbGO+xdTFyckgImEj83PWNEcIWk7hw
	bz1QnItDSGApo8TMD9egnD4miZ+nL7GDVLEJGEtsXr4ELCEisJlRYvH3q6wgDrPAUUaJ6b1v
	mUCqhAW8JVYs3MoMYrMIqErMO7AMrJtXwE3i7fQOIJsDaJ+CxJxJNiBhTgF3ib5P/9lAwkJA
	Jcv7Yycw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJaX3cwLj1mdYhRgINRiYdX
	4+uPICHWxLLiytxDjBIczEoivF+EfwUJ8aYkVlalFuXHF5XmpBYfYmTi4JRqYGSuDY3asHxL
	gUl3fJgu859jTxmuvKpNFzzx588TxVs/VL7WWESF/nNo0DsfudxEpTf55aXFKyXyRJ5myHGw
	KL/J9rlbWPaPW9vzRvf35oCpVxQKZfg//7m21/G+XtV/6za5Vzst2M/fDZzxledr4mGXJ2tf
	S8kcaGj5zy8jY3tkc/eTl/kx0kosxRmJhlrMRcWJALbI0aELAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add maximum register to the regmap used by rtc-s5m driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/sec-core.c          |    2 ++
 include/linux/mfd/samsung/rtc.h |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 7c6ce2e4aaa6..6021c54f74cf 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -141,6 +141,8 @@ static const struct regmap_config s5m8767_regmap_config = {
 static const struct regmap_config sec_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
+
+	.max_register = SEC_RTC_REG_MAX,
 };
 
 #ifdef CONFIG_OF
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
index 94b7cd6d8891..4627f59ebd84 100644
--- a/include/linux/mfd/samsung/rtc.h
+++ b/include/linux/mfd/samsung/rtc.h
@@ -43,6 +43,8 @@ enum sec_rtc_reg {
 	SEC_RTC_STATUS,
 	SEC_WTSR_SMPL_CNTL,
 	SEC_RTC_UDR_CON,
+
+	SEC_RTC_REG_MAX,
 };
 
 #define RTC_I2C_ADDR		(0x0C >> 1)
-- 
1.7.9.5

