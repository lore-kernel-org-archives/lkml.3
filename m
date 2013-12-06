Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3LFHIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:08:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15404 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LFHIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:08:40 -0500
X-AuditID: cbfee68e-b7fee6d000003b32-72-52a177f6fd05
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
In-reply-to: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
Subject: [PATCH 2/6] regulator: db8500-prcmu: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:08:38 +0900
Message-id: <000b01cef251$fc6df360$f549da20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAAAxYw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI91v5QuDDP7tk7BY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/v/S8wFW3gqdnTeYG5gXMDVxcjJISFgInFlShszhC0mceHeerYuRi4OIYFljBKT
	L2xlgina2jCZCSIxnVFi+6GPjBDOL0aJIxs3gbWzCahJfPlymL2LkYNDREBV4v8rd5AaZoGF
	jBJTljxgBokLCdhKrLpfDVLOKWAn8efoG7BWYQFvibdHPoEtYwFqnX/6ICuIzQtU/vz9fShb
	UOLH5HssIDazgJbE+p3HmSBseYnNa96CjZcQUJd49FcXJCwiYCTxb9tudogSEYl9L96BnSwh
	8IhdYtLCCewQuwQkvk0+xALRKyux6QA0ICQlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y0itOzC0uzUvXS87P3cQIidS+HYw3D1gfYkwGWj+RWUo0OR8Y6Xkl8YbGZkYW
	piamxkbmlmakCSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbGt68qxrS//7tyo
	qzPn6gWOfXx/V82rdv6Q1+r/y9+DT2THB1HWXxP91Ktf8RjsXXe4/8dpwdlm9xY49c416DNw
	Xqj7/W3pt7on1haLtNZ9/ugT+cy6t0PRbqbXkof35a7sWvxF4iJHvnBgUKNrduPuXxlZk2/7
	xB7yzRSc2iW/7tWhbMua1VuUWIozEg21mIuKEwEUa+Kf6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1v5QuDDFatEbFY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP7/0vMBVt4KnZ03mBuYFzA1cXIySEhYCKx
	tWEyE4QtJnHh3nq2LkYuDiGB6YwS2w99ZIRwfjFKHNm4iRmkik1ATeLLl8PsXYwcHCICqhL/
	X7mD1DALLGSUmLLkATNIXEjAVmLV/WqQck4BO4k/R9+AtQoLeEu8PfIJbBkLUOv80wdZQWxe
	oPLn7+9D2YISPybfYwGxmQW0JNbvPM4EYctLbF7zFmy8hIC6xKO/uiBhEQEjiX/bdrNDlIhI
	7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgPP
	pHYwrmywOMQowMGoxMPLsWpBkBBrYllxZe4hRgkOZiUR3h7xhUFCvCmJlVWpRfnxRaU5qcWH
	GJOBHp3ILCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwGg+8xDny43ytZ1TGqWuy1q5XRBLrfGO86qMnLj6f+WpM69zTeeXCkVaq22+vsXwu/f1
	larRUSf2Ttdv0t9VvFF8TdbHV+zH40rM027rMmeLHdo85aLGY2WHrNRjL6b/aBbxEVzkW/7/
	bgXPN3H3j41Si1we5X93f/m5yuu+aYa6y8xLRU0XDymxFGckGmoxFxUnAgBBi+63RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/db8500-prcmu.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index a53c11a..846acf2 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -431,17 +431,11 @@ static int db8500_regulator_register(struct platform_device *pdev,
 	config.of_node = np;
 
 	/* register with the regulator framework */
-	info->rdev = regulator_register(&info->desc, &config);
+	info->rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
 	if (IS_ERR(info->rdev)) {
 		err = PTR_ERR(info->rdev);
 		dev_err(&pdev->dev, "failed to register %s: err %i\n",
 			info->desc.name, err);
-
-		/* if failing, unregister all earlier regulators */
-		while (--id >= 0) {
-			info = &dbx500_regulator_info[id];
-			regulator_unregister(info->rdev);
-		}
 		return err;
 	}
 
@@ -530,20 +524,8 @@ static int db8500_regulator_probe(struct platform_device *pdev)
 
 static int db8500_regulator_remove(struct platform_device *pdev)
 {
-	int i;
-
 	ux500_regulator_debug_exit();
 
-	for (i = 0; i < ARRAY_SIZE(dbx500_regulator_info); i++) {
-		struct dbx500_regulator_info *info;
-		info = &dbx500_regulator_info[i];
-
-		dev_vdbg(rdev_get_dev(info->rdev),
-			"regulator-%s-remove\n", info->desc.name);
-
-		regulator_unregister(info->rdev);
-	}
-
 	return 0;
 }
 
-- 
1.7.10.4


