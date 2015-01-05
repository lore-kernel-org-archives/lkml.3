Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbbAEJBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:01:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39513 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:43 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4e-54aa52f49482
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 03/14] mfd: intel_soc_pmic: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:22 +0100
Message-id: <1420448493-9355-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xa7pfglaFGEx8oWvx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aB28uYCj5w
	VszrLWtg3MjRxcjJISFgItG44QUbhC0mceHeeiCbi0NIYCmjxNH1S9lBEkICfUwSh56agths
	AsYSm5cvAWsQEciS+DFtNQuIzSxgKPHz3R+wemEBT4mjb6awgtgsAqoSTctugNXzCrhJfNv2
	jRlimZzEyWOTgWo4ODgF3CVuP44EMYWASv69TZjAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWle
	ul5yfu4mRkiAfNnBuPiY1SFGAQ5GJR5ejxMrQ4RYE8uKK3MPMUpwMCuJ8K67BRTiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAuJCvcWnBb825G+aYMLEtfXf3udyctOwNIT5zLggvWVmbWH+kpGZz
	hwhjnk5Ezk5f+bVBCk2bnXoaJC19E7oW5plrTZm+wPvy0mUpf6/VZU7d/if/1IPHXuKzOy84
	Whx0eHRUZ7+YefgXH9XtxhsUDTZwytVIv5Fnmf49+wSfl+HzPI55N1stlFiKMxINtZiLihMB
	6mNui+4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/intel_soc_pmic_core.h | 2 +-
 drivers/mfd/intel_soc_pmic_crc.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/intel_soc_pmic_core.h b/drivers/mfd/intel_soc_pmic_core.h
index 33aacd9baddc..9498d6719847 100644
--- a/drivers/mfd/intel_soc_pmic_core.h
+++ b/drivers/mfd/intel_soc_pmic_core.h
@@ -23,7 +23,7 @@ struct intel_soc_pmic_config {
 	unsigned long irq_flags;
 	struct mfd_cell *cell_dev;
 	int n_cell_devs;
-	struct regmap_config *regmap_config;
+	const struct regmap_config *regmap_config;
 	struct regmap_irq_chip *irq_chip;
 };
 
diff --git a/drivers/mfd/intel_soc_pmic_crc.c b/drivers/mfd/intel_soc_pmic_crc.c
index c85e2ecb868a..4cc1b324e971 100644
--- a/drivers/mfd/intel_soc_pmic_crc.c
+++ b/drivers/mfd/intel_soc_pmic_crc.c
@@ -111,7 +111,7 @@ static struct mfd_cell crystal_cove_dev[] = {
 	},
 };
 
-static struct regmap_config crystal_cove_regmap_config = {
+static const struct regmap_config crystal_cove_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-- 
1.9.1

