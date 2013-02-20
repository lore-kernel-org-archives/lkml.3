Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab3BTGOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:14:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37629 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab3BTGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:14:07 -0500
X-AuditID: cbfee68e-b7fc26d000001938-4a-512469aeccbd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 10/11] mfd: tps65010: use devm_request_irq() and devm_kzalloc()
Date: Wed, 20 Feb 2013 15:14:05 +0900
Message-id: <002f01ce0f31$7cb08380$76118a80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAJYnA
Content-language: ko
x-cr-hashedpuzzle: F6IC F9nW Gj+G GzQq HVF/ N0sR QNz/ QZ9K QyAi S1cV Xr/K Y8YB
 ZcZz Zhjz aw07
 be27;3;agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAGEAbQBlAG8AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA=;Sosha1_v1;7;{C02CAADF-419E-4806-860D-C5E97BCE9C85};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 20 Feb 2013 06:14:01
 GMT;WwBQAEEAVABDAEgAIAAxADAALwAxADEAXQAgAG0AZgBkADoAIAB0AHAAcwA2ADUAMAAxADAAOgAgAHUAcwBlACAAZABlAHYAbQBfAHIAZQBxAHUAZQBzAHQAXwBpAHIAcQAoACkAIABhAG4AZAAgAGQAZQB2AG0AXwBrAHoAYQBsAGwAbwBjACgAKQA=
x-cr-puzzleid: {C02CAADF-419E-4806-860D-C5E97BCE9C85}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zY911mSqBBlMfC1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MT5t+MBZ08Vec/HyeuYGxnaeLkZNDQsBEYn1nJzuELSZx4d56
	ti5GLg4hgWWMEu/XnGCBKbo47QkTRGI6o8TanSdYIZzZTBI9dxcxg1SxCahJfPlyGGyUiICW
	RPex80CjODiYBVwkjk4TAQkLCdhKfF/7jxXE5hSwk9j16DyYLSzgL3H/4F8wm0VAVeL73Nlg
	i3mB6n+9fcEEYQtK/Jh8DyzODDR+/c7jTBC2vMTmNW+ZQVZJCKhLPPqrC3GBkUTXokZ2iBIR
	iX0v3jGCnCwh8IZF4sTyO6wQ9aYSR7pFIH7cxy5xa3cqxAkCEt8mH2KBKJGV2HSAGaJEUuLg
	ihssExilZiE5aBaSg2YhOWgWks0LGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoTEYd8O
	xpsHrA8xJgOtn8gsJZqcD4zjvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgtFJu00vjn8m49MuxLZuOBC7h4CrL9zwzs4PdquVz3t2UTy42L8++
	ce2dwXTg+/KNrxP3/Jz16lW5z0kWf98Y19fl9TmuzIfvZwSvWzf9G/fSPo9Vv2N+ff2UFtx5
	yef1JJs/ygXNz5jSulUy5EVOql7fe1Xu76Rd+yNr+u/42bUebbcWdkjxVGIpzkg01GIuKk4E
	AO2sJjHZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd11mSqBBtsm8lhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE+bfjAWdPFXnPx8nrmB
	sZ2ni5GTQ0LAROLitCdMELaYxIV769m6GLk4hASmM0qs3XmCFcKZzSTRc3cRM0gVm4CaxJcv
	h9lBbBEBLYnuY+eBOjg4mAVcJI5OEwEJCwnYSnxf+48VxOYUsJPY9eg8mC0s4C9x/+BfMJtF
	QFXi+9zZLCA2L1D9r7cvmCBsQYkfk++BxZmBxq/feZwJwpaX2LzmLTPIKgkBdYlHf3UhLjCS
	6FrUyA5RIiKx78U7RpCTJQTesEicWH6HFaLeVOJIt8gERpFZSDbMQrJhFpINs5CMWsDIsopR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOM6fSe1gXNlgcYhRgINRiYdXY75yoBBrYllxZe4h
	RgkOZiUR3mYnlUAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWanA9MQXkl8YbGJmZGlkZmFkYm
	5uakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJg1OqgXHOj9M3UufPt+I3flzwaP+JN4fOioWY
	Fe2/efC6tcitH38uHZ+uqGrNpfv+DGvJ3fMr7i8pvqh+Kevvq9VXJn/bfqq8c1/nv7ZlGQy3
	aytidDfOv5LYmjBne87SNY9T7nKFrv37lPdms8aNBWWeorOPfIsJSepbxb/u56UV+3jl91dW
	PPh6eNu/N0osxRmJhlrMRcWJAI5b+U03AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_irq() and devm_kzalloc() to make cleanup paths
more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/tps65010.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index da2691f..a5438cc 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -525,11 +525,8 @@ static int __exit tps65010_remove(struct i2c_client *client)
 			dev_dbg(&client->dev, "board %s %s err %d\n",
 				"teardown", client->name, status);
 	}
-	if (client->irq > 0)
-		free_irq(client->irq, tps);
 	cancel_delayed_work_sync(&tps->work);
 	debugfs_remove(tps->file);
-	kfree(tps);
 	the_tps = NULL;
 	return 0;
 }
@@ -549,7 +546,7 @@ static int tps65010_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EINVAL;
 
-	tps = kzalloc(sizeof *tps, GFP_KERNEL);
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps)
 		return -ENOMEM;
 
@@ -562,12 +559,13 @@ static int tps65010_probe(struct i2c_client *client,
 	 * so this driver uses falling-edge triggers instead.
 	 */
 	if (client->irq > 0) {
-		status = request_irq(client->irq, tps65010_irq,
-				     IRQF_TRIGGER_FALLING, DRIVER_NAME, tps);
+		status = devm_request_irq(&client->dev, client->irq,
+					tps65010_irq, IRQF_TRIGGER_FALLING,
+					DRIVER_NAME, tps);
 		if (status < 0) {
 			dev_dbg(&client->dev, "can't get IRQ %d, err %d\n",
 					client->irq, status);
-			goto fail1;
+			return status;
 		}
 		/* annoying race here, ideally we'd have an option
 		 * to claim the irq now and enable it later.
@@ -667,9 +665,6 @@ static int tps65010_probe(struct i2c_client *client,
 	}
 
 	return 0;
-fail1:
-	kfree(tps);
-	return status;
 }
 
 static const struct i2c_device_id tps65010_id[] = {
-- 
1.7.2.5


