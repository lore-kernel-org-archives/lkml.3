Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaJPIXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:23:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21716 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaJPIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:23:45 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-7a-543f808f7b9c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: s2mps11: Don't zero allocated memory for external
 control
Date: Thu, 16 Oct 2014 10:23:28 +0200
Message-id: <1413447808-16429-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xq7r9DfYhBlsPs1hMffiEzeL1C0OL
	b1c6mCwu75rDZnFxxRcmB1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	765IFvxiq2g68YWpgfEraxcjJ4eEgInE/nl3mCFsMYkL99azdTFycQgJLGWU2PluBjtIQkig
	j0ni6z0+EJtNwFhi8/IlYEUiAj2MEi+3fgbrZhYwlPj57g9Yg7BAuMSzWxeZuhg5OFgEVCXu
	L9EBMXkF3CVm/hGH2CUncfLYZNYJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE
	wNcdjEuPWR1iFOBgVOLh1Qi2DxFiTSwrrsw9xCjBwawkwttcCBTiTUmsrEotyo8vKs1JLT7E
	yMTBKdXA2G2ppBYYuPVcp9ynqWeaUlwOvDi2qGxNjFsUd/pnO1N1wQ2RHySW27av2rcx7u4l
	rUviUtPWPmTbPZsrxCXzb4ZTDrta7kOmCzZX5Ge/bvF77lLHdTE3JGJ3aaXWkYcMX/LDN1wQ
	0FxYdyc6IuR1duU8t9UhH/suOc4Iq9v0hM/jHMuryuI/SizFGYmGWsxFxYkAaiHn7d4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was allocating memory for storing GPIOs for external control
with unnecessary GFP_ZERO flag. Then right after allocation it
initialized memory to -EINVAL in loop. Skip the GFP_ZERO flag.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/s2mps11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index adab82d5279f..7f59e67252e7 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -845,7 +845,7 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		return -EINVAL;
 	};
 
-	s2mps11->ext_control_gpio = devm_kzalloc(&pdev->dev,
+	s2mps11->ext_control_gpio = devm_kmalloc(&pdev->dev,
 			sizeof(*s2mps11->ext_control_gpio) * s2mps11->rdev_num,
 			GFP_KERNEL);
 	if (!s2mps11->ext_control_gpio)
-- 
1.9.1

