Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbbAEIvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:51:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31190 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbAEIvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:51:08 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-25-54aa507abf6b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] power: max17042: Constify struct regmap_config
Date: Mon, 05 Jan 2015 09:50:17 +0100
Message-id: <1420447817-4262-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xq7pVAatCDOaeMbCY9OQ9s8XElZOZ
	LV6/MLS4vGsOm8Xn3iOMFqd3lziweeycdZfdY/MKLY9NqzrZPPq2rGL0+LxJLoA1issmJTUn
	syy1SN8ugStj9oGTLAV9bBXH1y9jbmCcxtrFyMEhIWAisWmjXRcjJ5ApJnHh3nq2LkYuDiGB
	pYwSz+5NY4Fw+pgkFk5+xQRSxSZgLLF5+RKwKhGB3YwSE6YuZwFJMAsYSvx894cdxBYWsJfo
	PbSRFcRmEVCVuNg7gRHE5hVwk5g29RszxDo5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgx
	t7g0L10vOT93EyMkLL7uYFx6zOoQowAHoxIPr8eJlSFCrIllxZW5hxglOJiVRHjX3QIK8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYOx95PGqf1n3bkHz0zvVYn3OPpGNMCk2+fdWz9955sLnB24z
	Ojlf2uoqU3d60pd4xhyGP3F7/lxyfFXX/fiie4RcQsnJjZ5S7IE3/+9bphjmtaN2pYUnx7R5
	U2wul08OU2uv+Hz05rfSRf5Srvfs1AOyxE+uCDNJ6fwfdeHOg6MHPaXXzfp+u1qJpTgj0VCL
	uag4EQB4m34B6QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/max17042_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index 66da691c41cf..1da6c5fbdff5 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -658,7 +658,7 @@ max17042_get_pdata(struct device *dev)
 }
 #endif
 
-static struct regmap_config max17042_regmap_config = {
+static const struct regmap_config max17042_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 16,
 	.val_format_endian = REGMAP_ENDIAN_NATIVE,
-- 
1.9.1

