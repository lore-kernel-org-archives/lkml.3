Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3EUGSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:18:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58173 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3EUGSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:18:33 -0400
X-AuditID: cbfee691-b7fef6d000002d62-b8-519b11b80c71
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 7/8] rtc: rtc-rx8025: use devm_*() functions
Date: Tue, 21 May 2013 15:18:32 +0900
Message-id: <000a01ce55eb$04a28b80$0de7a280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6wPXuMhJRRFdSKm3yJqXJJERlQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI90dgrMDDRp6VCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWHXrLWPBeYGKa6+aWRsY1/F2MXJySAiYSKz5fYUdwhaTuHBvPVsXIxeHkMAyRomL
	e3tYYYp2rjoIlZjOKPH5UjcLhPOLUaJ1yn2wKjYBNYkvXw4DjeLgEBHQl2hr0QCpYRboZpR4
	1DyXGaRGWMBGovHPWTCbRUBVou3tRrDVvAKWEttnrmKBsAUlfky+B2YzC2hJrN95nAnClpfY
	vOYtM8RFChI7zr5mBLFFBPQkDn8+xQhRIyKx78U7RpDFEgLH2CU2H7rLBrFMQOLb5EMsIMdJ
	CMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MkOibuIPx/gHrQ4zJQOsnMkuJJucDozevJN7Q2MzIwtTE1NjI3NKMNGElcV71FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwTP9kE5573iZivMndZq2oFQ27uz6A7lbnTmBq2
	nDziFn3MjEFKov/hN8bK3AOvt70QlH2wQ27CbHtBHbHWiaY/53xxZvpyU/hFVmm/16Pw8HUs
	23OuPys7rcNv+t7ukOHBbxz1S8Ja/VoOGXL19/buPc1qvkTtXeWD9zePKBX/Nl97XCmlmkWJ
	pTgj0VCLuag4EQBjgaoL1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd0dgrMDDQ5PVbBYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPVrbeMBecFKq69amZtYFzH28XIySEhYCKx
	c9VBNghbTOLCvfVANheHkMB0RonPl7pZIJxfjBKtU+6zglSxCahJfPlymL2LkYNDREBfoq1F
	A6SGWaCbUeJR81xmkBphARuJxj9nwWwWAVWJtrcb2UFsXgFLie0zV7FA2IISPybfA7OZBbQk
	1u88zgRhy0tsXvOWGeIiBYkdZ18zgtgiAnoShz+fYoSoEZHY9+Id4wRGgVlIRs1CMmoWklGz
	kLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc28+kdjCubLA4xCjAwajEwytgOCtQ
	iDWxrLgy9xCjBAezkgjv92agEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucD005eSbyhsYmZ
	kaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAu99Hdf2Pdf88Ps+3O+lzP
	PpN37eeikvC9Z3dvmj8nOcRwvd20pmWsvgIh6e47U3frfCjL+fw/QLyUS+BijVj/frstO0Ru
	zJFI77JOPOnRNp/r5xXfh2te1UjJbfvIHeBec+nVR60j5oliER3HpeLOyvjyZDZcr1wYe1zi
	6JsoqZk6nbIGQRZKLMUZiYZazEXFiQDGDjPIMQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rx8025.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index 0722d36..8fa23ea 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -549,7 +549,7 @@ static int rx8025_probe(struct i2c_client *client,
 		goto errout;
 	}
 
-	rx8025 = kzalloc(sizeof(*rx8025), GFP_KERNEL);
+	rx8025 = devm_kzalloc(&client->dev, sizeof(*rx8025), GFP_KERNEL);
 	if (!rx8025) {
 		dev_err(&adapter->dev, "failed to alloc memory\n");
 		err = -ENOMEM;
@@ -562,7 +562,7 @@ static int rx8025_probe(struct i2c_client *client,
 
 	err = rx8025_init_client(client, &need_reset);
 	if (err)
-		goto errout_free;
+		goto errout;
 
 	if (need_reset) {
 		struct rtc_time tm;
@@ -572,12 +572,12 @@ static int rx8025_probe(struct i2c_client *client,
 		rx8025_set_time(&client->dev, &tm);
 	}
 
-	rx8025->rtc = rtc_device_register(client->name, &client->dev,
+	rx8025->rtc = devm_rtc_device_register(&client->dev, client->name,
 					  &rx8025_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rx8025->rtc)) {
 		err = PTR_ERR(rx8025->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
-		goto errout_free;
+		goto errout;
 	}
 
 	if (client->irq > 0) {
@@ -586,7 +586,7 @@ static int rx8025_probe(struct i2c_client *client,
 				  0, "rx8025", client);
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			goto errout_reg;
+			goto errout;
 		}
 	}
 
@@ -603,12 +603,6 @@ errout_irq:
 	if (client->irq > 0)
 		free_irq(client->irq, client);
 
-errout_reg:
-	rtc_device_unregister(rx8025->rtc);
-
-errout_free:
-	kfree(rx8025);
-
 errout:
 	dev_err(&adapter->dev, "probing for rx8025 failed\n");
 	return err;
@@ -629,8 +623,6 @@ static int rx8025_remove(struct i2c_client *client)
 	}
 
 	rx8025_sysfs_unregister(&client->dev);
-	rtc_device_unregister(rx8025->rtc);
-	kfree(rx8025);
 	return 0;
 }
 
-- 
1.7.10.4


