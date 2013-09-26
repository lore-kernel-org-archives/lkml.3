Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3IZCG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:06:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43339 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IZCG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:06:26 -0400
X-AuditID: cbfee68e-b7f756d000004512-17-524396a12fff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 06/18] regulator: gpio-regulator: use
 devm_regulator_register()
Date: Thu, 26 Sep 2013 11:06:25 +0900
Message-id: <000c01ceba5d$014e32f0$03ea98d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAHvMw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA92F05yDDHo7TS2mPnzCZnF54SVW
	i29XOpgsLu+aw+bA4rFz1l12j02rOtk8+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PirMns
	BX85Kr4s28PawHiGvYuRk0NCwERi64v5LBC2mMSFe+vZuhi5OIQEZjNK9D96zgxTdOjVMVYQ
	W0hgOqPE/E0aEEW/GCV2dr5kAkmwCahJfPlyGGgqB4eIgKrE/1fuICazQK5E97Z0iFZbiVO/
	L7KB2JwCdhKnr20EGyksECLx6+QGRhCbBajz/PJ+sBpeoPpzJx9C2YISPybfA7uTWUBLYv3O
	40wQtrzE5jVvmUFWSQioSzz6qwsSFhEwknjzbwI7RImIxL4X7xhBLpYQOMUucfzYMnaIXQIS
	3yYfYoHolZXYdADqW0mJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9IoT
	c4tL89L1kvNzNzFCIrJvB+PNA9aHGJOB1k9klhJNzgdGdF5JvKGxmZGFqYmpsZG5pRlpwkri
	vGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGEtObeFcPXlDZeINxzVH/a4lyU+2urr8
	iu6dT0d+KvQfEpxbIyp8K+O2+4+otWtjirbtMznTcvbY4atbLr8viBaNCZ0bpsusadqZKPUh
	rMTdMVyyNSWm5QzHzCdFD398+7/+Z9+y1DuTjqSsENhsJdosseu5a1y1pomVoFimPNeVyz+e
	fvd+rK3EUpyRaKjFXFScCAA2MJ9p3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd2F05yDDC5cM7SY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMi7Mmsxf85aj4smwPawPjGfYuRk4OCQETiUOvjrFC2GISF+6t
	ZwOxhQSmM0rM36TRxcgFZP9ilNjZ+ZIJJMEmoCbx5cthoGYODhEBVYn/r9xBTGaBXInubekQ
	rbYSp35fBBvDKWAncfraRrDxwgIhEr9ObmAEsVmAOs8v7wer4QWqP3fyIZQtKPFj8j0WEJtZ
	QEti/c7jTBC2vMTmNW+ZQVZJCKhLPPqrCxIWETCSePNvAjtEiYjEvhfvGCcwCs1CMmkWkkmz
	kEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgeH8mtYNxZYPFIUYBDkYlHt4L
	zM5BQqyJZcWVuYcYJTiYlUR4vxkBhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmIrySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFRxMAnQ1tt85k54mum
	+zkrqYu5ndB92P51RhZ7+kT5n8es+3YmJFUU890p0i8+/j1R6o/F6Qnn6rpltX0ztG/xPk7Y
	q7BFxzDbY811gQ2/2eRFgnzuGJkaF308pTBFtTTMfve05Xftd6q+/yR1fKEdVwh7lwbrFOtt
	O/cvUTp12+f4+Xd3nYKVWIozEg21mIuKEwEII5ehOwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/gpio-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 98a98ff..92aaec6 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -322,7 +322,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 	}
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -349,8 +350,6 @@ static int gpio_regulator_remove(struct platform_device *pdev)
 {
 	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
-
 	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
 
 	kfree(drvdata->states);
-- 
1.7.10.4


