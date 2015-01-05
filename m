Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbbAEJJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31848 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbbAEJBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:45 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4a-54aa52f60434
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 05/14] mfd: lm3533: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:24 +0100
Message-id: <1420448493-9355-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7rfglaFGNx5qmnx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aNtctZC96y
	Vuw7f4S1gfE9SxcjB4eEgInEw1spXYycQKaYxIV769m6GLk4hASWMkpsbHvHCuH0MUnsazjJ
	AlLFJmAssXn5EjYQW0QgS+LHtNVgcWYBQ4mf7/6wg9jCAo4Sa4/3gtWwCKhKvLy6ggnE5hVw
	k9ixdzkbxDY5iZPHJrOCHMEp4C5x+3EkiCkEVPLvbcIERt4FjAyrGEVTS5MLipPSc430ihNz
	i0vz0vWS83M3MUJC5OsOxqXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfdLaAQb0pi
	ZVVqUX58UWlOavEhRiYOTqkGRuuQTVs6+6+k9mVEXLAVcLbVv1vkMk1Yu1K9MVnBSTKqoNkj
	s2HZ+do3QYH8Zjw+dzhdOhnEeO6YrbJ3DTdv9Lts2G3CbBrGzZjOwuRtv69eeHsqq6dO+LtL
	ButzdGqFP1w5+2ibxWPvzybWXKZ8/JoC6Qyi99T4lksIvQqfJCQxQVvMQYmlOCPRUIu5qDgR
	AO9gSLPvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/lm3533-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 8c29f7b27324..d42fbb667d8c 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -583,7 +583,7 @@ static bool lm3533_precious_register(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config regmap_config = {
+static const struct regmap_config regmap_config = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
 	.max_register	= LM3533_REG_MAX,
-- 
1.9.1

