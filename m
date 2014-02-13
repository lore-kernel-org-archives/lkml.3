Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaBMJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:32 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48550 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaBMJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:24 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c0-52fc8ceeb3d7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 01/14] mfd: sec: Add maximum RTC register for regmap config
Date: Thu, 13 Feb 2014 10:13:54 +0100
Message-id: <1392282847-25444-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7rvev4EGRz8ymaxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlTGnaRprwQGOijk7WRsYW9m7GDk5JARMJD58/cwGYYtJXLi3
	Hsjm4hASWMoocWJpFzuE08cksbn9KxNIFZuAscTm5UvAqkQENjNKLP5+lRXEYRY4yigxvfct
	WJWwgJ/EjX19jF2MHBwsAqoSL1e6gYR5Bdwlruyawg4SlhBQkJgzyQYkzCngIfHvx29mEFsI
	qKRn8Sz2CYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNbXHYxLj1kdYhTgYFTi
	4X2w+HeQEGtiWXFl7iFGCQ5mJRFeGYk/QUK8KYmVValF+fFFpTmpxYcYmTg4pRoYuyp478ef
	1v7oKPx5H8vCi8pXwoxPBT3ZVaUWK/rUXe5v9Y/d6w011u5m8pq7lM1674pUkT3fP+ze59rq
	/EX0Io/Bp8jZ277IhyQk6Qt7f1Dy2BHK5DHtZIBdcRbv3ws8Z0JS/8WKFIn/CUgT4FHc56vO
	32XGlmsnYJzWf7X9tUZjn1Jw7yYlluKMREMt5qLiRADdcdpVCgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add maximum register to the regmap used by rtc-s5m driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
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

