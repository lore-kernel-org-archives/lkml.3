Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbbAEI5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:57:38 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39218 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbbAEI47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:56:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d7-54aa51db61eb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] clk: si570: Constify struct regmap_config
Date: Mon, 05 Jan 2015 09:56:49 +0100
Message-id: <1420448209-8033-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448209-8033-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448209-8033-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t/xy7q3A1eFGCx+yG7x+oWhxeVdc9gs
	nk64yGbx40w3iwOLx+W+XiaPO9f2sHn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuHL7AXv
	WSue3n3I2MD4kaWLkZNDQsBE4sehE+wQtpjEhXvr2boYuTiEBJYySlxd/pgVJCEk0MckcflT
	LYjNJmAssXn5EjYQW0QgX2LWuttgg5gFDCV+vvsDNkhYwE7iX/87RhCbRUBV4uWnCWD1vAJu
	Ere2XINaLCdx8thksPmcAu4SL/tXsUPscpOY+PMq6wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OL
	S/PS9ZLzczcxQgLl6w7GpcesDjEKcDAq8fB6nFgZIsSaWFZcmXuIUYKDWUmEd90toBBvSmJl
	VWpRfnxRaU5q8SFGJg5OqQbGuiVB380Dpr9oT3k3yfKvXqF/qGHJ4xdnuewWa9Uu4S6qWiF6
	MmXxT3+xPT3LDXaJ7TnGpOHsyPmNyWVu541Jc17O3zkhPz7247rKU7PqZf7vcQsr23fWjXnl
	y5/vnTLrV6SquG0MjJ9hr6SxQ0l4w8xt/VUfvB8nfd239E6eVl2Swpaj11WSlFiKMxINtZiL
	ihMBVwgV6PIBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-si570.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
index fc167b3f8919..20a5aec98b1a 100644
--- a/drivers/clk/clk-si570.c
+++ b/drivers/clk/clk-si570.c
@@ -393,7 +393,7 @@ static bool si570_regmap_is_writeable(struct device *dev, unsigned int reg)
 	}
 }
 
-static struct regmap_config si570_regmap_config = {
+static const struct regmap_config si570_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
-- 
1.9.1

