Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597Ab3BTJb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:31:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22720 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab3BTJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:31:53 -0500
X-AuditID: cbfee691-b7f556d000001a24-aa-51249808e990
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 9/9] mfd: tc3589x: use devm_*() functions
Date: Wed, 20 Feb 2013 18:31:52 +0900
Message-id: <001701ce0f4d$1dc91960$595b4c20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAJMLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ12OGSqBBhMmmFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M/UcvMRZ84a34+ZKtgfEXVxcjJ4eEgInEs7fLmSFsMYkL99az
	dTFycQgJLGOUuHhxPTNM0Yo101khEtMZJdZt+ArlzGaSuLR+CxNIFZuAmsSXL4fZQWwRAS2J
	7mPngUZxcDALuEgcnSYCEhYSsJV41LUVbCingJ1Ey7V5YLawgI1E59t2sDEsAqoSN+48Aovz
	AtXv2HWYFcIWlPgx+R4LiM0MNH79zuNMELa8xOY1b5lBVkkIqEs8+qsLcYGRxIQzGxghSkQk
	9r14xwhysoTAInaJ+y8+skPsEpD4NvkQC0SvrMSmA1D/SkocXHGDZQKjxCwkm2ch2TwLyeZZ
	SFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESVxN3MN4/YH2IMRlo/URmKdHkfGBc
	5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY/Wm
	xUeuNV9LrXzDKcJlFeu18P6a7qUpYuINOp2rMpe35HLO3vIjgOn4ESvPw4mWrcL3+v8vfHfs
	jLaN53+T1J7W2a7vtH9s/vLZzvuu1sy6cL7ZH6Ly3J3cde/PX8Uf/uLl+sqqppuCXgtK+k4n
	R13e6nW3sHB/timb3Yf+WxEHa1kFczkclViKMxINtZiLihMBKoB5VcECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoC7HDJVAg/uLjS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxv6jlxgLvvBW/HzJ1sD4
	i6uLkZNDQsBEYsWa6awQtpjEhXvr2boYuTiEBKYzSqzb8JUVwpnNJHFp/RYmkCo2ATWJL18O
	s4PYIgJaEt3HzgN1cHAwC7hIHJ0mAhIWErCVeNS1lRnE5hSwk2i5Ng/MFhawkeh82w42hkVA
	VeLGnUdgcV6g+h27DrNC2IISPybfYwGxmYHGr995nAnClpfYvOYtM8gqCQF1iUd/dSEuMJKY
	cGYDI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOCofSa1g3Flg8UhRgEORiUeXo35yoFCrIllxZW5hxglOJiVRHh/dqgECvGmJFZWpRbl
	xxeV5qQWH2JMBnp0IrOUaHI+MKHklcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJanZq
	akFqEcwWJg5OqQbG9BAhlbcHT07zu/urSC3x+LPCxLqYzFWtDyf321572XcwvtPJaG+9eFGz
	6ob7HDf4FPaJBGtEh24UnXZJae17xchr3gbB687HamVNfjS5Z+XEdP5MxYh/3rX9P/oWW55f
	0OYwt+l+7OXMTXqP5i4wNhO4/Fr1k9jnG7VMOkJcvn7Ry7sbfQ8rsRRnJBpqMRcVJwIAmxQo
	+R4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

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


