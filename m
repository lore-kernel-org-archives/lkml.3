Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaC1Av3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:51:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55334 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbaC1Av2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:51:28 -0400
X-AuditID: cbfee68f-b7f156d00000276c-93-5334c78efd72
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2] charger-manager: Fix checking of wrong return type
Date: Fri, 28 Mar 2014 09:51:27 +0900
Message-id: <1395967887-30866-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkULfvuEmwweGtghbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDL+L1zNWrCds+LjutOMDYzv2bsYOTkkBEwkrjTsYIOwxSQu3FsPZHNxCAksZZRY+amH
	Fabo6L637BCJRYwSy0/8YIVwGpkkzrS3g41iE9CS2P/iBtgoEQFdiZs9l8HizAK1EvuuNYFN
	EhbwkZg5fyUziM0ioCrx/s97sHpeAVeJ05sWMkJsk5P4sOcR2DYJgfdsEj1HL7FCNAhIfJt8
	iKWLkQMoISux6QAzRL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREY
	oqf/PevfwXj3gPUhxmSgcROZpUST84EhnlcSb2hsZmRhamJqbGRuaUaasJI47/2HSUFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGEMSvndrZDt86rj7JINN7nNF4rVZ1ZkcrGF2M4XrjdiP
	tH+cy79z0hLpnPnZtvL8oQF6Szvv3nuglllde+P24/gJKULrVx1aEOaYpeBeM+u+zK1fk5NL
	K38ydKkv/LLqzItvrbz7Hy9n4DmbvfjBwcbd31c+uPwk7OD9Ly/KcwISWe5F96+SmKPEUpyR
	aKjFXFScCADQTkyuZwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAd2+4ybBBj/XcVlc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+L9wNWvBds6Kj+tOMzYwvmfvYuTkkBAwkTi6
	7y2ULSZx4d56ti5GLg4hgUWMEstP/GCFcBqZJM60t4NVsQloSex/cYMNxBYR0JW42XMZLM4s
	UCux71oTK4gtLOAjMXP+SmYQm0VAVeL9n/dg9bwCrhKnNy1khNgmJ/FhzyP2CYzcCxgZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIER8AzqR2MKxssDjEKcDAq8fA6WJgEC7EmlhVX5h5i
	lOBgVhLhTZgGFOJNSaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+MDrzSuINjU3MjCyNzA0tjIzN
	SRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFRvOZ2NferGzKGDAqst619zp9kY3vZr3Lu
	j/1LFZd7J3r+cCle+HLg3ZPmPhP3d2+mGf9ULVa2mbhSScJlXYSt0e+Jcy1tb8xbXTzzhFKB
	cOSrjOy7rzKZL+cV+X5V2JIc/FA6IEgs8LnwLMb0lxL/H/zZE6v4aLPFlxCVNWLT3lspv4h8
	eyNAiaU4I9FQi7moOBEA/EV9gsQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix minor issue about checking wrong return type.

The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
in this function. But, charger_manager_probe() has only checked whether
desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
DT, charger_manager_probe() can't detect error of desc instance.

Changes from v1:
- Fix return value from -ENODEV to PTR_ERR(desc)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..cf40fa1 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1677,9 +1677,9 @@ static int charger_manager_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!desc) {
+	if (IS_ERR(desc)) {
 		dev_err(&pdev->dev, "No platform data (desc) found\n");
-		return -ENODEV;
+		return PTR_ERR(desc);
 	}
 
 	cm = devm_kzalloc(&pdev->dev,
-- 
1.8.0

