Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbaCQLeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:34:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49054 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742AbaCQLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:33:58 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-77-5326dda4f8e4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] charger-manager: Fix checking of wrong return type
Date: Mon, 17 Mar 2014 20:33:51 +0900
Message-id: <1395056031-13666-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkRHfJXbVgg4ZLhhbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJeXP3HXLCeo+LKd/0Gxmb2LkZODgkBE4nph2dA2WISF+6tZ+ti5OIQEljKKDF9XjcL
	TNHhjvnsEInpjBIvNj+DchqZJLrPvmUCqWIT0JLY/+IGG4gtIuAuMfHhUlYQm1kgWeLn9vVg
	k4QFnCXOvlnO2MXIwcEioCqxYEcESJhXwFVi/qFXzBDL5CQ+7HkENl9C4DObxKXnDWAJFgEB
	iW+TD7GA9EoIyEpsOgBVLylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525i
	BIbn6X/Pencw3j5gfYgxGWjcRGYp0eR8YHjnlcQbGpsZWZiamBobmVuakSasJM6b9DApSEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVANj4PWTqb21HH5FovOl33ffOHzkAtt2xm2uP9+lqvT9
	edI4aZ7IxA63SlM+6ytq7v1PfXgdbTd47xY1Cb6/m/3lvkC7cyHLvpTcSd0sc26GQe42td9z
	Y94vP3krzS/yDb89V2/4s1n7tik18xZNqlXQevvGVT1DhJ/X7cxxxkgLO529dSqRHv5KLMUZ
	iYZazEXFiQAhFuBfZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jQd0ld9WCDS50a1tc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeHH1H3PBeo6KK9/1Gxib2bsYOTkkBEwkDnfM
	h7LFJC7cW8/WxcjFISQwnVHixeZn7BBOI5NE99m3TCBVbAJaEvtf3GADsUUE3CUmPlzKCmIz
	CyRL/Ny+ngXEFhZwljj7ZjljFyMHB4uAqsSCHREgYV4BV4n5h14xQyyTk/iw5xH7BEbuBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCg/+Z1A7GlQ0WhxgFOBiVeHgnKKsFC7EmlhVX
	5h5ilOBgVhLhTbsGFOJNSaysSi3Kjy8qzUktPsSYDLR8IrOUaHI+MDLzSuINjU3MjCyNzA0t
	jIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFR6XTQhSiZV2U9R/MrzFednp50s1W3
	4PsrbaOYxMYDSss4+F9Iup1hKeXq0eR89v9H0Il9DlM/3/rsObvKZ32cvMjRc6FFXpfaj76M
	Dbm5oEiK/+L0utaCkByRtln5cwwnr5lvKBLuZtGvqLnu6bGkR1uPbL3c5xv/hn9Zc77wn6pL
	TD9WtusqsRRnJBpqMRcVJwIA/2IjJsICAAA=
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

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..a10fb57 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!desc) {
+	if (IS_ERR(desc)) {
 		dev_err(&pdev->dev, "No platform data (desc) found\n");
 		return -ENODEV;
 	}
-- 
1.8.0

