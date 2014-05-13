Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbaEMK7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58814 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497AbaEMK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:04 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-68-5371faf577d9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 09/16] mfd: sec-core: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:46 +0200
Message-id: <1399978733-13662-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xy7pffxUGG+x7LGDx+oWhxf2vRxkt
	Lu+aw2Zx8k8vo8XpblaLiyu+MDmwedy5tofNY97JQI++LasYPT5vkgtgieKySUnNySxLLdK3
	S+DKePa0tmAxW8W+l90sDYxzWbsYOTkkBEwkzrz6zwxhi0lcuLeerYuRi0NIYCmjxOUHfxgh
	nD4miV9X9oJVsQkYS2xevoQNxBYRyJL4MW01C4jNLFAvcWv+TkYQW1jAWWL91NNg9SwCqhJ7
	d90Bs3kF3CU2Hb0NtU1O4uSxyWBXcAp4SLy4fRbMFgKqubFqEssERt4FjAyrGEVTS5MLipPS
	c430ihNzi0vz0vWS83M3MUJC5+sOxqXHrA4xCnAwKvHwejAXBAuxJpYVV+YeYpTgYFYS4XX/
	VBgsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgZHXk+Mm6+JSscb9fVrhk2L2TJ3GsV77wc/lxVG3
	9x1v1jEsfL9T/hRHeLpJT0uy+TJOhoRnT+NEhJo4vQrvbhT2ST13qeDiniCmqmomZ+do9ZBH
	JluWZVlP2N+gq6byI6hJYldZ9KzYM/cPJwkGu55orkw/vPpOzyLtXH/xpZEPTO7xOtlbKLEU
	ZyQaajEXFScCAHgfdzL7AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by both
of_match_table field and of_match_node() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/sec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 09fd256abcf6..bc29ccd8dd58 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -90,7 +90,7 @@ static const struct mfd_cell s2mpa01_devs[] = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id sec_dt_match[] = {
+static const struct of_device_id sec_dt_match[] = {
 	{	.compatible = "samsung,s5m8767-pmic",
 		.data = (void *)S5M8767X,
 	}, {
-- 
1.9.1

