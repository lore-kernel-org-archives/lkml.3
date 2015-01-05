Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbbAEJHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:07:14 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32697 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbAEJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:07:11 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-fc-54aa543e6b45
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] spi: meson: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:07:01 +0100
Message-id: <1420448821-9942-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJMWRmVeSWpSXmKPExsVy+t/xy7p2IatCDPZ+Y7aY+vAJm8XrF4YW
	l3fNYbNo/HiT3YHFY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyph3cipTwW3WivbL
	e5gbGB+wdDFyckgImEjs2vsYyhaTuHBvPVsXIxeHkMBSRom2NwfYIZw+JokdRx6zg1SxCRhL
	bF6+hA3EFhGIk7i+8w9YnFnAUOLnOwhbWMBKYsu8s6wgNouAqkT3pVZmEJtXwE3i/aHzTBDb
	5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MEJ9/2cG4+JjVIUYBDkYl
	Hl6PEytDhFgTy4orcw8xSnAwK4nwrrsFFOJNSaysSi3Kjy8qzUktPsTIxMEp1cCYMWNXlFHR
	P/+JR2f4zPynrvTrkvzplKQZnAw7D/yvsHllt26i2T/pe1dsixZ8jbWx3yuoeXiuum1uq8iK
	jLvK2m+21d9bV+P/LddJMPqiIkvY/a7dolJ17h1+wR8uJ6js5mG///R04a8iFTfH47/ZNLTf
	fvvz5IXNxe+tHxbuuplQ/0sieeEHJZbijERDLeai4kQANG3CLdcBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/spi/spi-meson-spifc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-meson-spifc.c b/drivers/spi/spi-meson-spifc.c
index 1bbac0378bf7..5468fc70dbf8 100644
--- a/drivers/spi/spi-meson-spifc.c
+++ b/drivers/spi/spi-meson-spifc.c
@@ -85,7 +85,7 @@ struct meson_spifc {
 	struct device *dev;
 };
 
-static struct regmap_config spifc_regmap_config = {
+static const struct regmap_config spifc_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-- 
1.9.1

