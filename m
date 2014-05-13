Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbaEMK7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59978 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbaEMK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:03 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-65-5371faf4b83d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@linaro.org>, patches@opensource.wolfsonmicro.com
Subject: [PATCH 08/16] mfd: wm8400-core: Make mfd_cell array const
Date: Tue, 13 May 2014 12:58:45 +0200
Message-id: <1399978733-13662-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsVy+t/xy7pffhUGGyx/aWKx6fp1VovXLwwt
	7n89ymhxedccNovlb/+zWZzuZnVg87hzbQ+bx7yTgR4vJ/5m8+jbsorR4/MmuQDWKC6blNSc
	zLLUIn27BK6M699PMxX8Yq3o2X2BrYGxkbWLkZNDQsBEYuek/WwQtpjEhXvrgWwuDiGBpYwS
	e78sYYdw+pgktu0/DtbBJmAssXn5ErAOEYEsiR/TVrOA2MwClRLfn7aA2cICThIL3x4Aq2ER
	UJW4t/ETE4jNK+AusfHCU0aIbXISJ49NBpvJKeAh8eL2WTBbCKjmxqpJLBMYeRcwMqxiFE0t
	TS4oTkrPNdIrTswtLs1L10vOz93ECAmjrzsYlx6zOsQowMGoxMPrwVwQLMSaWFZcmXuIUYKD
	WUmE1/1TYbAQb0piZVVqUX58UWlOavEhRiYOTqkGRse4OWItd/urag/uy5rdzC7etY5r8UQO
	bYly0aWd2565VzPqpMgs0bz0J1j3N++rj8wHC78xGgZ/0Vh8d0NW7JlL597/W+8pdDVY8for
	oy3X0iclTwq9UKzh+DKkVPOdt7Z/vfn5hOc+fW2XFBrMpfL2vbLamSb98d7JeUuenBRpXHj/
	9rrcEiWW4oxEQy3mouJEAAd26IcBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() expects array of struct mfd_cell to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@linaro.org>
Cc: patches@opensource.wolfsonmicro.com
---
 drivers/mfd/wm8400-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index e5eae751aa1b..c6fb5d16ca09 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -64,7 +64,7 @@ EXPORT_SYMBOL_GPL(wm8400_block_read);
 
 static int wm8400_register_codec(struct wm8400 *wm8400)
 {
-	struct mfd_cell cell = {
+	const struct mfd_cell cell = {
 		.name = "wm8400-codec",
 		.platform_data = wm8400,
 		.pdata_size = sizeof(*wm8400),
-- 
1.9.1

