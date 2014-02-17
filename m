Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaBQIko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:40:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38453 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBQIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:40 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-b1-5301cb05d60f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 01/13] mfd: sec: Add maximum RTC register for regmap config
Date: Mon, 17 Feb 2014 09:40:15 +0100
Message-id: <1392626427-4518-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xK7qspxmDDY6eM7fYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjBZrJ/xmsVizvR3TA7cHneu7WHz
	mHcy0KNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy5jRNYy04wFExZydrA2MrexcjO4eEgInE
	xdouRk4gS0ziwr31bF2MXBxCAksZJU73rWeCcPqYJO5cPcAMUsUmYCyxefkSsCoRgc2MEou/
	X2UFcZgFZjJJ/Ln5gAmkSljAT2LFlVPsIDaLgKrEn/lLwWxeATeJK4sbWboYOYD2KUjMmWQD
	EuYUcJd42jeVFSQsBFSyf2PYBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCAu3r
	Dsalx6wOMQpwMCrx8BpUMwYLsSaWFVfmHmKU4GBWEuG1XQcU4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwLi8fk3BUrvsm/vn3PK4+2/b9pI1nn3lcq33m14d2B+dlKMSw7RYNjxHvy3pw55XnIqO
	WxKOfP/QJ1YudPXGb5ngS3seKj9Ufr1YRP7HrsjJexVu/W4X3lG2tWhu74Gvpd11mnk31918
	t8/3TszX067vWrfOmW30YJvyRpdlR/70XIp/cfIUQ3qJEktxRqKhFnNRcSIAVMdT2BICAAA=
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

