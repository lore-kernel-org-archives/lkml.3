Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbaEMLCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:02:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58814 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760651AbaEMK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:06 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-6d-5371faf59e0d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 11/16] mfd: max8998: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:48 +0200
Message-id: <1399978733-13662-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xy7pffxUGG+y4YGbx+oWhxdmmN+wW
	978eZbS4vGsOm8XpblYHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGX/n
	3Wcp2MResWPxDKYGxnlsXYycHBICJhIPzz9hhrDFJC7cWw8U5+IQEljKKHH2RyMrhNPHJPHr
	yl6wKjYBY4nNy5eAdYsIZEn8mLaaBcRmFoiTOP1iOViNsICTxPFl+8DiLAKqEr3r7rOD2LwC
	HhI7FnxihdgmJ3Hy2GQwmxMo/uL2WTBbSMBd4saqSSwTGHkXMDKsYhRNLU0uKE5KzzXSK07M
	LS7NS9dLzs/dxAgJma87GJceszrEKMDBqMTD68FcECzEmlhWXJl7iFGCg1lJhNf9U2GwEG9K
	YmVValF+fFFpTmrxIUYmDk6pBkYtkRYJTiPDqcoN803l+H+G6/9f1JrDsOApj+r35HPffE/a
	G0QtvX8/6Wz6io1HQhfMePYgYPMuNcbzb19H7923eHtqs6C6pclrzwz/H49CP4b9FpXk+eI0
	KUquayWzrpozZ4BCl8JXh3LRHXPDU0ICVpyb+0BTwORuLIewTLoNM0+KxsbV+UosxRmJhlrM
	RcWJAMW+/l73AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by both
of_match_table field and of_match_node() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max8998.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 592db06098e6..a37cb7444b6e 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -132,7 +132,7 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 EXPORT_SYMBOL(max8998_update_reg);
 
 #ifdef CONFIG_OF
-static struct of_device_id max8998_dt_match[] = {
+static const struct of_device_id max8998_dt_match[] = {
 	{ .compatible = "maxim,max8998", .data = (void *)TYPE_MAX8998 },
 	{ .compatible = "national,lp3974", .data = (void *)TYPE_LP3974 },
 	{ .compatible = "ti,lp3974", .data = (void *)TYPE_LP3974 },
-- 
1.9.1

