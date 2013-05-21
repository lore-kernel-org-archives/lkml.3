Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3EUGRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:17:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57966 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3EUGRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:17:34 -0400
X-AuditID: cbfee68e-b7f276d000002279-6b-519b117d9998
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/8] rtc: rtc-mpc5121: use devm_*() functions
Date: Tue, 21 May 2013 15:17:33 +0900
Message-id: <000701ce55ea$e18326a0$a48973e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6uBoS50WB1eTTOuR8hP0FTG/9A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ91awdmBBuefa1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsbZ/IVvBOf6KC4tXsDQwvuXpYuTkkBAwkTj5rpsFwhaTuHBvPVsXIxeHkMAyRomb
	u5czwhTN23qKCSIxnVGi7d07qKpfjBInu/eCtbMJqEl8+XKYvYuRg0NEQF+irUUDpIZZoJtR
	4lHzXGaQGmEBW4mNb78ygdgsAqoSz8/OANvAK2Ap0dO7DMoWlPgx+R7YTGYBLYn1O48zQdjy
	EpvXvGWGuEhBYsfZ12D1IgJ6EruuLmaDqBGR2PfiHSPIYgmBQ+wSvUcms0AsE5D4NvkQC8hx
	EgKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQv
	XS85P3cTIyT6+nYw3jxgfYgxGWj9RGYp0eR8YPTmlcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxXoikVKVdVeeZ78VlU1w2zEni6ilZJnfIQOeR
	1Z/p+Tv6OnLFn8/orRZ8saJIRfLw6y+Rna1CPn4sCed27lhXsqPp9Xvlr7O5LR2uu5X8j7x3
	yEZvecc8Vm3/53pNmjpNecbL79vOlzCfe8Kk+mOC7bRpivlt2T+NGFTNpibUVa+y4p2slqzE
	UpyRaKjFXFScCAAhXanP1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd1awdmBBk8vqVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG2fyFbwTn+iguLV7A0ML7l6WLk5JAQMJGY
	t/UUE4QtJnHh3nq2LkYuDiGB6YwSbe/eQTm/GCVOdu9lAaliE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0A3o8Sj5rnMIDXCArYSG99+BZvKIqAq8fzsDEYQm1fAUqKndxmULSjxY/I9sJnMAloS
	63ceZ4Kw5SU2r3nLDHGRgsSOs6/B6kUE9CR2XV3MBlEjIrHvxTvGCYwCs5CMmoVk1Cwko2Yh
	aVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi2n0ntYFzZYHGIUYCDUYmHV8BwVqAQ
	a2JZcWXuIUYJDmYlEd7vzUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgemnbySeENjEzMj
	SyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPTt/Jqetv7jjN1l11JKF5yT
	bOBenTztnatsScW+3qhKNn7+K1tUXCeIn+GKkCsvOy4vynhA8P5RTz6Jr90aiwLyWqf2dJ91
	KBL4Hbf1pF3nu3PhemfWKSlM+Oi7Ttzh6dTLQdn631qPnFAvcmbYbBFsGOS0JMxR+Y/SjrI1
	s1kvPqoufBPArsRSnJFoqMVcVJwIABUMkioxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mpc5121.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 213006b..4c02497 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -312,15 +312,14 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 	struct mpc5121_rtc_data *rtc;
 	int err = 0;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&op->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->regs = of_iomap(op->dev.of_node, 0);
 	if (!rtc->regs) {
 		dev_err(&op->dev, "%s: couldn't map io space\n", __func__);
-		err = -ENOSYS;
-		goto out_free;
+		return -ENOSYS;
 	}
 
 	device_init_wakeup(&op->dev, 1);
@@ -354,10 +353,10 @@ static int mpc5121_rtc_probe(struct platform_device *op)
 			out_be32(&rtc->regs->keep_alive, ka);
 		}
 
-		rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
+		rtc->rtc = devm_rtc_device_register(&op->dev, "mpc5121-rtc",
 						&mpc5121_rtc_ops, THIS_MODULE);
 	} else {
-		rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
+		rtc->rtc = devm_rtc_device_register(&op->dev, "mpc5200-rtc",
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
@@ -377,8 +376,6 @@ out_dispose2:
 out_dispose:
 	irq_dispose_mapping(rtc->irq);
 	iounmap(rtc->regs);
-out_free:
-	kfree(rtc);
 
 	return err;
 }
@@ -392,14 +389,11 @@ static int mpc5121_rtc_remove(struct platform_device *op)
 	out_8(&regs->alm_enable, 0);
 	out_8(&regs->int_enable, in_8(&regs->int_enable) & ~0x1);
 
-	rtc_device_unregister(rtc->rtc);
 	iounmap(rtc->regs);
 	free_irq(rtc->irq, &op->dev);
 	free_irq(rtc->irq_periodic, &op->dev);
 	irq_dispose_mapping(rtc->irq);
 	irq_dispose_mapping(rtc->irq_periodic);
-	dev_set_drvdata(&op->dev, NULL);
-	kfree(rtc);
 
 	return 0;
 }
-- 
1.7.10.4


