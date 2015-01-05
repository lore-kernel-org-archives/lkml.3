Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbbAEJJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32293 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEJBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:45 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-57-54aa52f68664
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 09/14] mfd: retu: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:28 +0100
Message-id: <1420448493-9355-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJMWRmVeSWpSXmKPExsVy+t/xa7rfglaFGNxcKGfx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bOF4uYC06x
	VsyYvJapgfE8SxcjJ4eEgIlEQ8NNKFtM4sK99WwgtpDAUkaJ56vFuxi5gOw+JokbUzYxgyTY
	BIwlNi9fAlYkIpAl8WPaarBmZgFDiZ/v/rB3MXJwCAvYS5ybpA9isgioSlz7WgJSwSvgJrHl
	7XRGiFVyEiePTWYFKeEUcJe4/TgSxBQCKvn3NmECI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGCHh8WUH4+JjVocYBTgYlXh4PU6sDBFiTSwrrsw9xCjBwawkwrvuFlCINyWxsiq1
	KD++qDQntfgQIxMHp1QDo7A/87m0GzoZoToOR48mP35/Y63Gg7DNp4wnX5+7OOHv2kkeU5J2
	bTgz6euWmLVbEzd7lLXdTErp2M+8aOp3qaySrghZr/MWs9NCdmTd9F5ea94QlbnRV/j+nneh
	T73NzL7HH19UrMZ/yfT4NsWo2L5Di/s6uCOc3k58fXbZg9apEd2F+69ITlFiKc5INNRiLipO
	BABe3Z547QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/retu-mfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
index 663f8a37aa6b..2d64430c719b 100644
--- a/drivers/mfd/retu-mfd.c
+++ b/drivers/mfd/retu-mfd.c
@@ -222,7 +222,7 @@ static struct regmap_bus retu_bus = {
 	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 };
 
-static struct regmap_config retu_config = {
+static const struct regmap_config retu_config = {
 	.reg_bits = 8,
 	.val_bits = 16,
 };
-- 
1.9.1

