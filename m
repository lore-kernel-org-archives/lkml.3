Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935939Ab3BTGNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:13:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:37611 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3BTGNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:13:38 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-9d-51246991e53f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 09/11] mfd: da903x: use devm_request_irq() and devm_kzalloc()
Date: Wed, 20 Feb 2013 15:13:37 +0900
Message-id: <002e01ce0f31$6bc4b230$434e1690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAIOhA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY92JmSqBBksemlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MGW8Osxds5atY0juRsYHxHHcXIyeHhICJxK3bX5khbDGJC/fW
	s4HYQgLLGCWatnvB1Mx8PwsozgUUX8QocbG1lwnCmc0k8fH5MSaQKjYBNYkvXw6zg9giAloS
	3cfOA3VwcDALuEgcnSYCMdRW4vvaf6wgNqeAncSuR+fBbGEBX4nGs5vBylkEVCWev40HCfMC
	lXd+3s8MYQtK/Jh8jwXEZgaavn7ncSYIW15i85q3zCCtEgLqEo/+6kIcYCRx8dITVogSEYl9
	L94xglwsIbCIXeJlbzvYlSwCAhLfJh9igeiVldh0ABoMkhIHV9xgmcAoMQvJ5llINs9CsnkW
	khULGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoREVe8OxtsHrA8xJgOtn8gsJZqcD4zK
	vJJ4Q2NjEzMTUxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgZD/x
	9F1K1efF2vu5fjKXfT2uxJHx87TdPg13LaZnFzTKDTX7F8Y2qV7fWvf6ROCBudvPLdq1vnF3
	cc/uO35s8r/ri3Obn31fJdGwTFvo5flr9emyXXFzJF+deKTMYbTv/tTI9LRdpd4X7RdcvV9Q
	6T7/7SO//a7yDzYGzvrEpH7mi2PWll6pPCWW4oxEQy3mouJEAHog5CXAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7ETJVAg5vrDSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxow3h9kLtvJVLOmdyNjA
	eI67i5GTQ0LARGLm+1lsELaYxIV764FsLg4hgUWMEhdbe5kgnNlMEh+fH2MCqWITUJP48uUw
	O4gtIqAl0X3sPFAHBwezgIvE0WkiIGEhAVuJ72v/sYLYnAJ2ErsenQezhQV8JRrPbgYrZxFQ
	lXj+Nh4kzAtU3vl5PzOELSjxY/I9FhCbGWj6+p3HmSBseYnNa94yg7RKCKhLPPqrC3GAkcTF
	S09YIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBEftM+kdjKsaLA4xCnAwKvHwNixUDhRiTSwrrsw9xCjBwawkwtvspBIoxJuSWFmVWpQf
	X1Sak1p8iDEZ6M+JzFKiyfnAhJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2amp
	BalFMFuYODilGhjZet4uKDXcdvb499++7Dt4+5suHZF28yh43nHeuX7dgmNTlQ6xmtcffNhZ
	IxD6X4pNYKrMonMcp/brz8/8NueZ/v0dqvMKv25cs78ge7bWbMVkuWW9+6cJus3fvn5be45X
	8lG/WIbcDdkr/+rkqQf7VTDalp+NLVrO3Ck804dxoeCOegvlVg0lluKMREMt5qLiRABHfxqY
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
 drivers/mfd/da903x.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 05176cd..f1a316e 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -499,7 +499,8 @@ static int da903x_probe(struct i2c_client *client,
 	unsigned int tmp;
 	int ret;
 
-	chip = kzalloc(sizeof(struct da903x_chip), GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(struct da903x_chip),
+				GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
@@ -515,33 +516,27 @@ static int da903x_probe(struct i2c_client *client,
 
 	ret = chip->ops->init_chip(chip);
 	if (ret)
-		goto out_free_chip;
+		return ret;
 
 	/* mask and clear all IRQs */
 	chip->events_mask = 0xffffffff;
 	chip->ops->mask_events(chip, chip->events_mask);
 	chip->ops->read_events(chip, &tmp);
 
-	ret = request_irq(client->irq, da903x_irq_handler,
+	ret = devm_request_irq(&client->dev, client->irq, da903x_irq_handler,
 			IRQF_TRIGGER_FALLING,
 			"da903x", chip);
 	if (ret) {
 		dev_err(&client->dev, "failed to request irq %d\n",
 				client->irq);
-		goto out_free_chip;
+		return ret;
 	}
 
 	ret = da903x_add_subdevs(chip, pdata);
 	if (ret)
-		goto out_free_irq;
+		return ret;
 
 	return 0;
-
-out_free_irq:
-	free_irq(client->irq, chip);
-out_free_chip:
-	kfree(chip);
-	return ret;
 }
 
 static int da903x_remove(struct i2c_client *client)
@@ -549,8 +544,6 @@ static int da903x_remove(struct i2c_client *client)
 	struct da903x_chip *chip = i2c_get_clientdata(client);
 
 	da903x_remove_subdevs(chip);
-	free_irq(client->irq, chip);
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.2.5


