Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaB1Kl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:41:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9691 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaB1Klx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:41:53 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-6a-531067efd882
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] mfd: sec: Add maximum RTC register for regmap config
Date: Fri, 28 Feb 2014 11:41:41 +0100
Message-id: <1393584104-18912-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
References: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7rv0wWCDf6tErbYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjBZrJ/xmsWBy+POtT1sHvNOBnr0
	bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqsDcxgLDnBU3Pq2j72BsZW9i5GTQ0LAROLP9N2s
	ELaYxIV769m6GLk4hASWMkocuLSRBcLpY5KY2P2XCaSKTcBYYvPyJWBVIgKbGSUWf78K1s4s
	8JxR4un3cBBbWMBTYueFbrA4i4CqxOPDr8GaeQXcJc7M6gNazQG0TkFiziQbkDCngIfE7PnP
	wcqFgEqetV1gnsDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSJB93cG49JjVIUYB
	DkYlHt4JnvzBQqyJZcWVuYcYJTiYlUR489wFgoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUw1l3g
	mc7ekPjWcnX5lyAF1nVegQp6B7ceOzfj+f+MmtpDf9bN7Sh7HPn7C+/xzALh0h8HJmw7bhma
	rVD4bm9R0bTEh1GbvO//Wle3Mv34B+lzzYt5/5uFzGrsSL7/ZdHvnc+25Wm9CHM8d4ZVbe0X
	wa+F/g+ZApZ56n098k449rlq1ZQXl35sFVRiKc5INNRiLipOBADna9AAEAIAAA==
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
index a76cd85a2868..074939c9bd42 100644
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

