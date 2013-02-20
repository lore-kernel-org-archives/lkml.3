Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3BTJbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:31:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3BTJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:31:27 -0500
X-AuditID: cbfee690-b7f066d00000169f-53-512497ee180d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 8/9] mfd: da903x: use devm_*() functions
Date: Wed, 20 Feb 2013 18:31:26 +0900
Message-id: <001601ce0f4d$0e23d1d0$2a6b7570$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAIFdw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY91301UCDb5e17C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZL569ZyrYyVex494MlgbGs9xdjJwcEgImEhPXNzFB2GISF+6t
	Z+ti5OIQEljGKHG8dRIjTNHvM8/YIRKLGCW+PVsA5cxmkth6eAYrSBWbgJrEly+H2UFsEQEt
	ie5j54FGcXAwC7hIHJ0mAhIWErCVeNS1lRnE5hSwk2i5Ng/MFhawlng1dR2YzSKgKvHw8CEW
	EJsXqP5r/zcmCFtQ4sfke2BxZqDx63ceZ4Kw5SU2r3nLDLJKQkBd4tFfXYgLjCSWzpgMVSIi
	se/FO0aQkyUEFrFLzFzdxQSxS0Di22SQXSC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSb
	ZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSGRN2MF474D1IcZkoPUTmaVEk/OB
	kZlXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYze
	H+LXLNSaavVqEfOSaBb2KTKVB7YFiKSeO7XKqr07mfm2naT6Oj79uV/dagMYFNe/jeFg0j2s
	3bzSmWOT85Ld5x/vLlPg/h/Mfv2d56c709m0ygsDfqS7LVvf66db9ziOk/v6DpH98ovbfjx4
	WzDX4VOk0+SITQ3HX19t5WhsldYSk7n+eb8SS3FGoqEWc1FxIgAsQocTwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO676SqBBg9uKltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjBfP3jMV7OSr2HFvBksD
	41nuLkZODgkBE4nfZ56xQ9hiEhfurWfrYuTiEBJYxCjx7dkCdghnNpPE1sMzWEGq2ATUJL58
	OQzWISKgJdF97DxQBwcHs4CLxNFpIiBhIQFbiUddW5lBbE4BO4mWa/PAbGEBa4lXU9eB2SwC
	qhIPDx9iAbF5geq/9n9jgrAFJX5MvgcWZwYav37ncSYIW15i85q3zCCrJATUJR791YW4wEhi
	6YzJUCUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxguP2mfQOxlUNFocYBTgYlXh4GxYqBwqxJpYVV+YeYpTgYFYS4f3ZoRIoxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAlJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2amp
	BalFMFuYODilGhjLkny2JbMe2Hl6bmSI9+YtSU3qaxY5BRvfytdLl6mP1pjmtGzdr5L+9GrW
	FQdOOun1fbvT+dao7NemlyfWfDK0n5/ZZvW2euZGjnIO58wLU/9f6M5/rKVVmd139e1WPrOe
	8JUHK5+uflfyWa/hhn8eX831i4k5r5nKnqyd8aQvObSfPUM07IgSS3FGoqEWc1FxIgBsh96U
	HwMAAA==
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


