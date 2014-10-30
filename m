Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbaJ3LX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:23:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64132 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbaJ3LV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:27 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-8d-54521f2f4db1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 01/14] mfd: max77686/802: Map regulator driver to its own
 of_node
Date: Thu, 30 Oct 2014 12:20:40 +0100
Message-id: <1414668053-31370-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7r68kEhBj1r+C02zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW978eZbT4dqWDyWLT42usFpd3
	zWGzmHF+H5PF7cu8FmuP3GW3ON3N6iDo0dLcw+bx9/l1Fo+/q14we+ycdZfdY9OqTjaPO9f2
	sHnMOxnosXlJvUffllWMHp83yQVwRXHZpKTmZJalFunbJXBlrP+5k6VgPUfFwQdX2RoYn7B1
	MXJySAiYSBy/dYkJwhaTuHBvPVCci0NIYCmjxI1VZ6CcPiaJ5nnbGUGq2ASMJTYvXwKWEBHo
	ZJboOdjLDOIwC6xmkvh55RQzSJWwQJjEg5MTWEFsFgFVif7HZ4B2cHDwCrhLTJjmA7FOTuLk
	sclgJZwCHhJrPrazgpQIAZXc+6Y9gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	AP+6g3HpMatDjAIcjEo8vBHHAkKEWBPLiitzDzFKcDArifCuFgsKEeJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cBooLom5HHZs8+JHyf8ND5zdolSeALrR07mv1LHHDoYKrXW39n7epcH+5rGVgem
	4D3GKcUXz7Teyrm6Lm2JY2XFysBO/q9fk5kzJLNTateqTFFqrQtKq2xxbcq5fmrmG/Mfdv0z
	Vxmri9QWTcjfsYJje7SusU/GVz/RbqbN7xmC+mP3h8708FZiKc5INNRiLipOBAAP2Yn/TgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_compatible fields for max77686 and max77802 regulator drivers.
The driver's node should be the same as voltage-regulators node. This
simplifies parsing of regulators init data from DTS.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77686.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 929795eae9fc..9e1046bdef90 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -38,13 +38,19 @@
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
 static const struct mfd_cell max77686_devs[] = {
-	{ .name = "max77686-pmic", },
+	{
+		.name = "max77686-pmic",
+		.of_compatible = "maxim,max77686-pmic",
+	},
 	{ .name = "max77686-rtc", },
 	{ .name = "max77686-clk", },
 };
 
 static const struct mfd_cell max77802_devs[] = {
-	{ .name = "max77802-pmic", },
+	{
+		.name = "max77802-pmic",
+		.of_compatible = "maxim,max77802-pmic",
+	},
 	{ .name = "max77802-clk", },
 	{ .name = "max77802-rtc", },
 };
-- 
1.9.1

