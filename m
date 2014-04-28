Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaD1Kur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:50:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35357 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaD1Kq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:46:57 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-f4-535e319f3e11
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 1/7 v8] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Mon, 28 Apr 2014 16:14:53 +0530
Message-id: <1398681899-20782-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWne+YVywwZ+nOhYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DK2P+khbXgmkhF671HTA2MbYJdjJwcEgImEucPP2eH
	sMUkLtxbzwZiCwksZZTovewLU/N58ibGLkYuoPh0Rol1LcdYIJx+JomG601g3WwCZhIHF60G
	s0UEnCV+N69hBSliFljHKPHpzWEmkISwQKjEx+MnmEFsFgFVie19b8DW8Qq4Skw/PwGogQNo
	nYLEnEk2IGFOATeJq+vPMUJc5CqxtPcHM8hMCYF17BJ9j/+xQ8wRkPg2+RALRK+sxKYDzBBX
	S0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgUF/+t+zCTsY7x2wPsSY
	DDRuIrOUaHI+MGrySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoGRc4Xyha77/gvWfF/HZnuMffrjiTFKPYzvCxiip8w/w7LqS+orjZoAc/X4kqgF
	O+u6Nj7ViHh/IpidrenIrMmyxyWWv55tvUK71CLl7jVHpu6oG26hz/xTrl6//+jLrSC12WGx
	1VGKCVP/bu+Vl9X+cuL9mTdrPut8n3Iw0ozLcMa1Jya8ur8XKrEUZyQaajEXFScCAIXbJ0mQ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd35hnHBBos/qlq8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b+Jy2sBddE
	KlrvPWJqYGwT7GLk5JAQMJH4PHkTI4QtJnHh3nq2LkYuDiGB6YwS61qOsUA4/UwSDdeb2EGq
	2ATMJA4uWg1miwg4S/xuXsMKUsQssI5R4tObw0wgCWGBUImPx08wg9gsAqoS2/vesIHYvAKu
	EtPPTwBq4ABapyAxZ5INSJhTwE3i6vpzYFcIAZUs7f3BPIGRdwEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4Kh6Jr2DcVWDxSFGAQ5GJR7eiDmxwUKsiWXFlbmHGCU4mJVEePdLxAUL
	8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4w4vNK4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0o
	JJCeWJKanZpakFoEs4WJg1OqgXGjSpljWOPdhDaeeNGSZQy8wmlG9e68a2X0vz+5wH6Rs2vW
	rv+rPyV3C+2efbFz/tQnc7g2eSkzCFgpfWUzOy42T7Nl8oSZ918cCvrx8CbT+bMFafLSh3Y9
	ir2Seoz3Bi9jzKbC4FbOaX+tvjy6ZJrJ+Y6LVyOt6tO9/P1TfOdPvTF3Q7SD6TElluKMREMt
	5qLiRABdu8BV7gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the platform_get_irq() instead of the
platform_get_irq_byname(). Making feeder control interrupt
as resource "0" and hash interrupt as "1".

reasons for this change.
1. Cannot find any Arch which is currently using this driver
2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
3. Patches adding support for DT and H/W version are in pipeline

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Changes since v6:
None
Changes since v5:
None

 drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index be45762..2876fa3 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -587,29 +587,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pdata->lock);
 
-	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
-	if (pdata->irq_hash < 0) {
-		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
+	pdata->irq_fc = platform_get_irq(pdev, 0);
+	if (pdata->irq_fc < 0) {
+		err = pdata->irq_fc;
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
 
-	pdata->irq_fc = platform_get_irq_byname(pdev, "feed control");
-	if (pdata->irq_fc < 0) {
-		err = pdata->irq_fc;
-		dev_warn(dev, "feed control interrupt is not available.\n");
+	pdata->irq_hash = platform_get_irq(pdev, 1);
+	if (pdata->irq_hash < 0) {
+		err = pdata->irq_hash;
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "feed control interrupt is not available.\n");
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
 
-- 
1.7.9.5

