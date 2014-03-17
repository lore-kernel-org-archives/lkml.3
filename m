Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaCQLcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:32:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24453 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbaCQLcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:32:01 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-a2-5326dd308fc1
From: y@samsung.com
To: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] charger-manager: Fix checking of wrong return type
Date: Mon, 17 Mar 2014 20:31:50 +0900
Message-id: <1395055910-13593-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t9jQV2Du2rBBkffSltc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mr4cbCRveAuR8XCPUoNjKvYuxg5OSQETCSO7VrBDGGLSVy4t56ti5GLQ0hgOqPE9Ffr
	2CGcRiaJpd0HWLsYOTjYBIQlph7QAmkQEXCXmPhwKSuIzSyQLPFz+3oWEFtYwFni7JvljCA2
	i4CqxK7b7WALeAVsJY5OvcoIsUxO4sOeR+wTGLkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAgOhmdSOxhXNlgcYhTgYFTi4Z2grBYsxJpYVlyZe4hRgoNZSYQ37RpQiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA2NfgDR35U2Le/Ga1e+WMHeu
	TjhyqXt+AKexcHFDnNpt02d50ZzLlNdsc1U2jDw2If5eYZSxeN5PG7sPLqqMjZG9U5c/KXhV
	ElLQE3PD3VQz+fKthBNPs1Lyb/R+2TNl1vN5wvanSz7a/zi/S79/tuySqcYhVV6y77+8K/14
	WLY3aAXTnuOqIkosxRmJhlrMRcWJAJVcdVYCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

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

