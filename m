Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3EBFwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:52:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48295 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3EBFv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:51:57 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-e8-5181fefb7507
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 6/7] watchdog: riowd: use devm_kzalloc()
Date: Thu, 02 May 2013 14:51:55 +0900
Message-id: <000901ce46f9$26ed25c0$74c77140$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+SZHRJRjjXupSpmLRVjIPy3J4Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zQ93f/xoDDaadUbaYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBmbnk9hL3jKWfH+31rGBsZX7F2MnBwSAiYSd2btYoKwxSQu3FvP1sXIxSEk
	sIxR4kPvY0aYooN3m6ESixglDq09ww7h/GKUONFxlxWkik1ATeLLl8NACQ4OEQF9ibYWDZAa
	ZoENjBIn//8FWycsYC+xaMJisHoWAVWJd8//gK3mFbCUePJmDguELSjxY/I9MJtZQEti/c7j
	TBC2vMTmNW+ZIS5SkNhx9jXYdSICehJfnp1gg6gRkdj34h0jyGIJgXPsEm9fTWWCWCYg8W3y
	IRaQ4yQEZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGRXnFi
	bnFpXrpecn7uJkZIFPbtYLx5wPoQYzLQ+onMUqLJ+cAoziuJNzQ2M7IwNTE1NjK3NCNNWEmc
	V63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY9nyjgv7Smbq7ksPecN9KNPYa9/iadYz
	30/Y8u5W2xPhDW8mvlyxtLq0olD1U12wxdybWpePxCZM3uu7xuNIl88L3Y2Hy6SSnt08Jyoi
	xla/MfMoq85X08YNW/Y3chzwtdOzD1lQrFGx+MyC+nPv8qb+f7CgWfULZ2lq3INZh9jm3rzO
	rbNszhclluKMREMt5qLiRAD4JZID2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd3f/xoDDQ7ekbeYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzNj2fwl7wlLPi/b+1jA2Mr9i7GDk5
	JARMJA7ebWaDsMUkLtxbD2RzcQgJLGKUOLT2DDuE84tR4kTHXVaQKjYBNYkvXw4DJTg4RAT0
	JdpaNEBqmAU2MEqc/P8XbKqwgL3EogmLwepZBFQl3j3/wwRi8wpYSjx5M4cFwhaU+DH5HpjN
	LKAlsX7ncSYIW15i85q3zBAXKUjsOPuaEcQWEdCT+PLsBBtEjYjEvhfvGCcwCsxCMmoWklGz
	kIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgGH8mtYNxZYPFIUYBDkYlHt4P
	uo2BQqyJZcWVuYcYJTiYlUR4F7wGCvGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MP3klcQb
	GpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPjbkG5eQ84zizwevNM
	68eMkluP559YKOq78d43nUO505JZdzopdFZk11g6Kxz1PjUx9v+HQ6u4LjZ8rJoorFizZJKp
	X+eH/PJZy5QkPJhWPrnIpTcpxHL5LpFd81PfXjW+NTlg2bp1e7emvH0294nM7HucfCKrG0St
	Nt5u2/ZjzUfns+fUNpk0SyixFGckGmoxFxUnAgDiRdfkNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/riowd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 0040451..13363ad 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -183,7 +183,7 @@ static int riowd_probe(struct platform_device *op)
 		goto out;
 
 	err = -ENOMEM;
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	if (!p)
 		goto out;
 
@@ -192,7 +192,7 @@ static int riowd_probe(struct platform_device *op)
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
 		pr_err("Cannot map registers\n");
-		goto out_free;
+		goto out;
 	}
 	/* Make miscdev useable right away */
 	riowd_device = p;
@@ -213,9 +213,6 @@ out_iounmap:
 	riowd_device = NULL;
 	of_iounmap(&op->resource[0], p->regs, 2);
 
-out_free:
-	kfree(p);
-
 out:
 	return err;
 }
@@ -226,7 +223,6 @@ static int riowd_remove(struct platform_device *op)
 
 	misc_deregister(&riowd_miscdev);
 	of_iounmap(&op->resource[0], p->regs, 2);
-	kfree(p);
 
 	return 0;
 }
-- 
1.7.2.5


