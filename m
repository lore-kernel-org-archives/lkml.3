Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628Ab3BTGOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:14:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18594 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934429Ab3BTGOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:14:31 -0500
X-AuditID: cbfee691-b7f556d000001a24-38-512469c6b131
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 11/11] mfd: tc3589x: use devm_request_irq() and devm_kzalloc()
Date: Wed, 20 Feb 2013 15:14:30 +0900
Message-id: <003001ce0f31$8b5460a0$a1fd21e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAKSpQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY91jmSqBBs0vjSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGordrmQs+8Fac/TOPtYHxN1cXIyeHhICJxK65nxkhbDGJC/fW
	s4HYQgLLGCXeNkvB1Fz494Cpi5ELKD6dUeLQllUsEEWzmSR+vhUGsdkE1CS+fDnMDmKLCGhJ
	dB87DzSIg4NZwEXi6DQRiHJbie9r/7GC2JwCdhK7Hp0Hs4UF/CRWfekFs1kEVCX+vp8LNp4X
	qH7P4VXsELagxI/J98DizEDj1+88zgRhy0tsXvOWGWSVhIC6xKO/uhAXGElcefGODaJERGLf
	i3eMIOdLCCxil1g3YT4LxC4BiW+TD7FA9MpKbDrADPGupMTBFTdYJjBKzEKyeRaSzbOQbJ6F
	ZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFRNXEH4/0D1ocYk4HWT2SWEk3OB0Zl
	Xkm8obGxiZmJqYm5pam5KWnCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwLl1x
	ZV89E6OZ04OgaKbydQ2Hkq4vlWYXrHq0I1h7doz4k1s1NrbBMzkF9bU/Lr6+MC1OfOH3nha2
	qZ32tWpxx9X2L3Tz2NJyJ1PpmnjiMsZwh7okvh+Zc1J+qBmcfht6cJJa1+Nk9+kNe+NWrZvg
	5bHC/0tMcR+/ZMbDrv2WnVvss+a0v5FSYinOSDTUYi4qTgQAp/GkP8ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO6xTJVAgxn9ehaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY9HbtcwFH3grzv6Zx9rA
	+Juri5GTQ0LAROLCvwdMELaYxIV769m6GLk4hASmM0oc2rKKBSQhJDCbSeLnW2EQm01ATeLL
	l8PsILaIgJZE97HzQA0cHMwCLhJHp4lAlNtKfF/7jxXE5hSwk9j16DyYLSzgJ7HqSy+YzSKg
	KvH3/Vyw8bxA9XsOr2KHsAUlfky+BxZnBhq/fudxJghbXmLzmrfMIKskBNQlHv3VhbjASOLK
	i3dsECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxgqP2mdQOxpUNFocYBTgYlXh4NeYrBwqxJpYVV+YeYpTgYFYS4W12UgkU4k1JrKxKLcqP
	LyrNSS0+xJgM9OhEZinR5HxgQskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTU
	gtQimC1MHJxSDYzC1X9mGFxS/PbWnHPJSQvWX28+PjzdGddmy6Kr/7JnboGQw8NzHP8sn1Vl
	RforFFp27zw7Ufr37n/vnWZxVmyz5bHkkvV87nwq+1vWH282qc/POpXt+vw+1W+4ObvnV1lX
	spWB2K1Al4l8DUpr+0TOHz+1+kin+MKZG1uO8F/4unhbutWjsH1KLMUZiYZazEXFiQABERnL
	HgMAAA==
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
 drivers/mfd/tc3589x.c |   21 ++++++---------------
 1 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index ecc092c..4cb92bb 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -350,7 +350,8 @@ static int tc3589x_probe(struct i2c_client *i2c,
 				     | I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	tc3589x = kzalloc(sizeof(struct tc3589x), GFP_KERNEL);
+	tc3589x = devm_kzalloc(&i2c->dev, sizeof(struct tc3589x),
+				GFP_KERNEL);
 	if (!tc3589x)
 		return -ENOMEM;
 
@@ -366,33 +367,27 @@ static int tc3589x_probe(struct i2c_client *i2c,
 
 	ret = tc3589x_chip_init(tc3589x);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	ret = tc3589x_irq_init(tc3589x, np);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	ret = request_threaded_irq(tc3589x->i2c->irq, NULL, tc3589x_irq,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   "tc3589x", tc3589x);
 	if (ret) {
 		dev_err(tc3589x->dev, "failed to request IRQ: %d\n", ret);
-		goto out_free;
+		return ret;
 	}
 
 	ret = tc3589x_device_init(tc3589x);
 	if (ret) {
 		dev_err(tc3589x->dev, "failed to add child devices\n");
-		goto out_freeirq;
+		return ret;
 	}
 
 	return 0;
-
-out_freeirq:
-	free_irq(tc3589x->i2c->irq, tc3589x);
-out_free:
-	kfree(tc3589x);
-	return ret;
 }
 
 static int tc3589x_remove(struct i2c_client *client)
@@ -401,10 +396,6 @@ static int tc3589x_remove(struct i2c_client *client)
 
 	mfd_remove_devices(tc3589x->dev);
 
-	free_irq(tc3589x->i2c->irq, tc3589x);
-
-	kfree(tc3589x);
-
 	return 0;
 }
 
-- 
1.7.2.5


