Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbbAEIwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:52:03 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31250 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbAEIwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:52:00 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e7-54aa50ae95c2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] power: bq24190: Fix ignored supplicants
Date: Mon, 05 Jan 2015 09:51:48 +0100
Message-id: <1420447908-4389-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJMWRmVeSWpSXmKPExsVy+t/xa7rrAlaFGLx/rW0x6cl7ZouJKycz
	W7x+YWhxedccNovPvUcYLU7vLrFYsPERowO7x85Zd9k9Nq/Q8ti0qpPNo2/LKkaPz5vkAlij
	uGxSUnMyy1KL9O0SuDJ2/ZjCXHCAu+Jie0kDYydXFyMHh4SAicTl+W5djJxAppjEhXvr2boY
	uTiEBJYySux6+QDK6WOSWPt/CitIFZuAscTm5UvAEiICuxklJkxdzgKSYBbwlHj39yE7iC0s
	YCGxZO4SsAYWAVWJBfO2MIHYvAJuEq39r9gh1slJnDw2mXUCI/cCRoZVjKKppckFxUnpuYZ6
	xYm5xaV56XrJ+bmbGCHh8WUH4+JjVocYBTgYlXh4PU6sDBFiTSwrrsw9xCjBwawkwrvuFlCI
	NyWxsiq1KD++qDQntfgQIxMHp1QDI/PH4Jfqxay8nEzHV2c96+Rdcu7jH7vLUZOmn3G5YdI8
	9/2hCfIJ4r4Kbnc3/dq3ePtZboOTkmvUghfs3qO81I5pqtCqFUknXvYkNtzdY9Jk9HfV9H0b
	Jlc7Xq/0uDl95+ZJpkydk4pv5p8Qddnhqlj62+b5h1N+Yh88Hv+uOvfgi9HnL8LS0ROUWIoz
	Eg21mIuKEwHTGVfK7QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver mismatched 'num_supplicants' with 'num_supplies' of
power_supply structure.

It provided list of supplicants (power_supply.supplied_to) but did
not set the number of supplicants. Instead it set the num_supplies which
is used when iterating over number of supplies (power_supply.supplied_from).

As a result the list of supplicants was ignored by core because its size
was 0.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: d7bf353fd0aa ("bq24190_charger: Add support for TI BQ24190 Battery Charger")
---
 drivers/power/bq24190_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index ad3ff8fbfbbb..e4c95e1a6733 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -929,7 +929,7 @@ static void bq24190_charger_init(struct power_supply *charger)
 	charger->properties = bq24190_charger_properties;
 	charger->num_properties = ARRAY_SIZE(bq24190_charger_properties);
 	charger->supplied_to = bq24190_charger_supplied_to;
-	charger->num_supplies = ARRAY_SIZE(bq24190_charger_supplied_to);
+	charger->num_supplicants = ARRAY_SIZE(bq24190_charger_supplied_to);
 	charger->get_property = bq24190_charger_get_property;
 	charger->set_property = bq24190_charger_set_property;
 	charger->property_is_writeable = bq24190_charger_property_is_writeable;
-- 
1.9.1

