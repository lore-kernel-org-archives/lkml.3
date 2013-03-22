Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3CVCPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:15:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49318 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab3CVCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:15:00 -0400
X-AuditID: cbfee68d-b7f786d000005188-7b-514bbea2aed8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] rtc: rtc-ds1374: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Fri, 22 Mar 2013 11:14:58 +0900
Message-id: <00bb01ce26a3$0d69b800$283d2800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4mow1NhbkZdmKeSwuK3nkgccWzIw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ91F+7wDDdatNbdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/bz/awFr7grLv0Ja2B8ytnFyMkhIWAisfb0eyYIW0ziwr31bF2MXBxCAssYJX5t
	3sEMU9S+ZB4TRGI6o8S7u3cZIZxfjBIv/85lAaliE1CT+PLlMHsXIweHiIC+RFuLBkgNs0Av
	o8SZ3t3sIDXCAuESE3u3soHYLAKqEsunvQHr5RWwlTg6fxoThC0o8WPyPbA4s4CWxPqdx5kg
	bHmJzWveMoPMlxBQl3j0VxckLCKgJ3GvcwMzRImIxL4X78BukxA4xi7x8XcjK8QuAYlvkw+x
	QPTKSmw6APWYpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV5
	6XrJ+bmbGCGR17uD8fYB60OMyUDrJzJLiSbnAyM3ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MR3+XyBx5asatvN3rmlzT0/7iXxPb8nK+CE5r
	DFMNnLmr9WPGlDLvF+u81m7fUKv/LIan40hV/urmyORZnxYtt61b3v5Iyk5n4V1PnTDR0xGO
	1yoeZi9XvWdRfHQJk/ivxfzqMXXPP52ZyFD4YOGlYwqJnBa3f1fqfL2yQWzfysxKu1Bh2dsc
	SizFGYmGWsxFxYkAnweletICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd1F+7wDDVauNLZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP28/2sBa+4Ky79CWtgfMrZxcjJISFgItG+
	ZB4ThC0mceHeerYuRi4OIYHpjBLv7t5lhHB+MUq8/DuXBaSKTUBN4suXw+xdjBwcIgL6Em0t
	GiA1zAK9jBJnenezg9QIC4RLTOzdygZiswioSiyf9gasl1fAVuLo/GlMELagxI/J98DizAJa
	Eut3HmeCsOUlNq95ywwyX0JAXeLRX12QsIiAnsS9zg3MECUiEvtevGOcwCgwC8mkWUgmzUIy
	aRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP6mfQOxlUNFocYBTgYlXh4NXS8
	A4VYE8uKK3MPMUpwMCuJ8EamAIV4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5hy8kriDY1N
	zIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBMf731Ac+TK6tF/dKevT/
	PFO8LXzl8jW87Ev+KfgKvp57obh0/lTOxIqHHN4rxBK4hMK+2e/T8+Y4av6WY+mR5uddj6NY
	Dj4+otC7TU5c6nWY07XQTTonTb8JKL5lMzn2YHX7sTnb3lxgXmPatzn6nG9kmO+OQ1rnDt7/
	8qQvn1+Gu8pqf5HRBiWW4oxEQy3mouJEAINP/UMvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/rtc/rtc-ds1374.c:413:12: warning: 'ds1374_suspend' defined but not used [-Wunused-function]
drivers/rtc/rtc-ds1374.c:422:12: warning: 'ds1374_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1374.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index fef7686..67cd1e3 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -409,7 +409,7 @@ static int ds1374_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int ds1374_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -427,19 +427,15 @@ static int ds1374_resume(struct device *dev)
 		disable_irq_wake(client->irq);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ds1374_pm, ds1374_suspend, ds1374_resume);
 
-#define DS1374_PM (&ds1374_pm)
-#else
-#define DS1374_PM NULL
-#endif
-
 static struct i2c_driver ds1374_driver = {
 	.driver = {
 		.name = "rtc-ds1374",
 		.owner = THIS_MODULE,
-		.pm = DS1374_PM,
+		.pm = &ds1374_pm,
 	},
 	.probe = ds1374_probe,
 	.remove = ds1374_remove,
-- 
1.7.2.5


