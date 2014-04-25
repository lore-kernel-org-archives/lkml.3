Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaDYAmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:42:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDYAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:38 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-1b-5359af7a35ee
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Fri, 25 Apr 2014 09:42:20 +0900
Message-id: <1398386544-16295-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSolu1PjLYYNZSPouD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PVAvWCe5wVO3f8Z25gnMfRxcjB
	ISFgIrF9p0wXIyeQKSZx4d56ti5GLg4hgaWMEhs3/meESJhI/Fj6hR0iMZ1R4sCFf8wQThOT
	xLr2L0wgVWwCWhL7X9xgA7FFBBQkNvc+YwUpYhZ4xihx4uoJZpCEsECYxK0b78EaWARUJd48
	+MYOYvMKuEos6n3MDrFOTuLDnkdgNqeAm8ShE70sILYQUM2rc3OYIGq2sUucm8QNMUdA4tvk
	QywQ78hKbDrADFEiKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIExsHp
	f88m7mC8f8D6EGMy0LiJzFKiyfnAOMoriTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkbptoNBDDyirUrL2Dmvbp7MxijeKN1s9PnJzzvH726+Gnsu
	d/Jjdcn7kzMOneSeOHFG8Dz951NL7pp/5XMoYt2SI/siYnLzBrMTRhuV3ss5yMtu3T3xjMha
	RQepLKliedbft91ud8x2WnPv/ruOj6lnbiv/CV68i8HR95Ac14IfLDG14rx9vXuUWIozEg21
	mIuKEwFhtQQsmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd2q9ZHBBo3z2S0O3q+3mPrwCZvF
	vyk32C2uf3nOatG/xcXi9QtDiwtPe9gszja9Ybe4vGsOm8XtxhVsDlwem1Z1snm8nPibzaNv
	yypGj6lT/jJ6HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGE
	NYwZrxaoF9zjrNi54z9zA+M8ji5GTg4JAROJH0u/sEPYYhIX7q1n62Lk4hASmM4oceDCP2YI
	p4lJYl37FyaQKjYBLYn9L26wgdgiAgoSm3ufsYIUMQs8Y5Q4cfUEM0hCWCBM4taN92ANLAKq
	Em8efANbwSvgKrGo9zHUOjmJD3segdmcAm4Sh070soDYQkA1r87NYZrAyLuAkWEVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnCkPZPewbiqweIQowAHoxIP7wTZyGAh1sSy4srcQ4wSHMxK
	IrzKq4BCvCmJlVWpRfnxRaU5qcWHGJOBrprILCWanA9MAnkl8YbGJmZGlkbmhhZGxuakCSuJ
	8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLimOFRZsGiZ+651qX2BJ05XTKyV3uu4y9XfTXRP
	xfOvp5g2hizZ8WqPypsckSb7d/HnUjS+L2afK8UaWLM8KFWkOFnkZmnbQfUNqzOS/8UyZSqu
	vdRy54rmJN5jmYst0irO3Utq1nv2kWX/UteOa312DWfYnp/8suFzmJDfRNMCoYjbV1aFtSqx
	FGckGmoxFxUnAgCrYu9/+AIAAA==
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
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index d17dd4f..d49e891 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -739,14 +739,15 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL);
-	if (!info->edev) {
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max14577_extcon_cable);
+	if (IS_ERR(info->edev)) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
 
 	info->edev->name = dev_name(&pdev->dev);
-	info->edev->supported_cable = max14577_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

