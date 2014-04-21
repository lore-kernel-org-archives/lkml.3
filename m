Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaDUJhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:37:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21881 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaDUJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:36:29 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-ab-5354e698ed13
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, gg@slimlogic.co.uk, kishon@ti.com, balbi@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        sangjung.woo@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 18:36:22 +0900
Message-id: <1398072986-17386-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
References: <1398072986-17386-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSqDvjWUiwQc9WTYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbxYI9JQ7cHptWdbJ5vJz4
	m82jb8sqRo+pU/4yehy/sZ3J4/MmuQC2KC6blNSczLLUIn27BK6Mnt0X2Aoec1Q8+HCGpYFx
	A3sXIyeHhICJxOszW1ggbDGJC/fWs4HYQgJLGSVmrbaBqTm5ciZzFyMXUHwRo8TJ9TtYIZwm
	JolZ35eBdbMJaEnsf3EDrFtEQEFic+8zsCJmgQYmiTmfFjCBJIQFQiRuTJrGDGKzCKhK3F+w
	FSzOK+AqMeXeA0aIdXISH/Y8AjuPU8BNYt2PblaIk1wlOt73MYIMlRDYxy7R8qKDCWKQgMS3
	yYeAruAASshKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQI
	jInT/55N3MF4/4D1IcZkoHETmaVEk/OBMZVXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx62RfO83Ft386dxNy3Mdx0Je9ys1O6ES93HBaXi9ti
	5pUe/UTuTyZnB6dE6uIPK56feD/j9YRXxyd+tPv38ufzy1dtt9obsx1iEq3s+3ymdn1FkJlV
	uza7c8DlGeqnZ+3+WbBcy/E0X2POnkOyu0zyWWR277900S1qD1e7tYZeU+YFfS/f9D1KLMUZ
	iYZazEXFiQDIosZTnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd0Zz0KCDWY+VrQ4eL/eYurDJ2wW
	/6bcYLe4/uU5q0X/FheL1y8MLS487WGzONv0ht3i8q45bBa3G1ewWSzYU+LA7bFpVSebx8uJ
	v9k8+rasYvSYOuUvo8fxG9uZPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBOk5JoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjDmNGz+wJbwWOOigcfzrA0MG5g72Lk5JAQMJE4uXImM4QtJnHh3nq2LkYuDiGBRYwS
	J9fvYIVwmpgkZn1fxgJSxSagJbH/xQ02EFtEQEFic+8zsCJmgQYmiTmfFjCBJIQFQiRuTJoG
	NpZFQFXi/oKtYHFeAVeJKfceMEKsk5P4sOcR2BmcAm4S6350s4LYQkA1He/7GCcw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxzz6R3MK5qsDjEKMDBqMTD+yI/JFiINbGsuDL3
	EKMEB7OSCG/EeqAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wPTQV5JvKGxiZmRpZG5oYWR
	sTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MG7dOGexmy+HuP6De57sTG1N6x5/tgqa
	rnuTN23WK6YE/TC3narSX1Y75/OtFsw6cWFTAdMnhp7pXw+0n+ibIKQsv/ee/Dr1HzIzrye7
	8t95Hn9/wqS8KxMyEssE7gobFV39H73ve69zi8dTqTOHz+5pXVP36kS8tZdUVqXyxrev5C7N
	lJl1NE+JpTgj0VCLuag4EQB8N3cY/QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 1fef08d..c869a86 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -668,13 +668,14 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max14577_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
 	info->edev->name = DEV_NAME;
-	info->edev->supported_cable = max14577_extcon_cable;
+
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

