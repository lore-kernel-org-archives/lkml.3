Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3EWKom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:44:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38786 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260Ab3EWKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:44:40 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a7-519df317ed85
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/5] watchdog: riowd: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:44:38 +0900
Message-id: <003701ce57a2$864a0740$92de15c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XooWSkua/jT7cShaBet5FH8kkxw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI13xz3MDDd5N57KYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBn73zSwFMzmqJjwR6KB8RVbFyMnh4SAicS7u40sELaYxIV764HiXBxCAssY
	JS7veMHaxcgBVnRyjQtIjZDAIkaJ1j0eEDW/GCWWT3gMNohNQE3iy5fD7CD1IgL6Em0tGiA1
	zAIbGCVO/v/LDlIjLOAmseLrd2YQm0VAVWLrpxYmEJtXwFLiacd5dghbUOLH5HtgBzELaEms
	33mcCcKWl9i85i0zxKEKEjvOvmYEsUUE9CQOTpgIVS8ise/FO0aImnPsEi+2cUPsEpD4NvkQ
	C8QvshKbDkCNkZQ4uOIGywRGsVlINs9CsnkWks2zkGxYwMiyilE0tSC5oDgpvchUrzgxt7g0
	L10vOT93EyMk+ibuYLx/wPoQYzLQ+onMUqLJ+cDozSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD446mAwqu+zWfcky2jlzJccBafMM+nd/35V4o
	Jrq2rj+uUlM7/6knO8NqWcnmpjn8xiYKVcrrXwZKbtTySN0bVPdUtr6oZ7v1CePlYvltCzld
	t1ZPYG45nK/NWn5TTNsheNmhWXs7X/yaVHX359WEZlFO3viaqOfa/6M64/NTz9vXyX161p+q
	xFKckWioxVxUnAgAGVMv4tQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAV3xz3MDDWbMZbOYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz9r9pYCmYzVEx4Y9EA+Mrti5GDg4J
	AROJk2tcuhg5gUwxiQv31rOB2EICixglWvd4dDFyAdm/GCWWT3gMlmATUJP48uUwO0iviIC+
	RFuLBkgNs8AGRomT//+yg9QIC7hJrPj6nRnEZhFQldj6qYUJxOYVsJR42nGeHcIWlPgx+R4L
	iM0soCWxfudxJghbXmLzmrfMEAcpSOw4+5oRxBYR0JM4OGEiVL2IxL4X7xgnMArMQjJqFpJR
	s5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Oh+JrWDcWWDxSFGAQ5GJR5e
	idtzAoVYE8uKK3MPMUpwMCuJ8G7umRsoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAxJNX
	Em9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxdk9ZqqSl315Qb
	Lb55Wmi5a7qg/IrQKq/uqwuuPFWs/qycd01PZmlMSVuQQqvTepfjk+1Sm01f8sbtbIiyu31Y
	fW/VWr30TaxHb89M4S0Xjq94oTHzQufTCYefGDhbvy4W8K95wmO+LfTRO7lFazT/SUxrPlQd
	OWXD1GqB2cH7ehaa379ima/EUpyRaKjFXFScCACqAC2NMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/riowd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 0040451..4f99f12 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -206,7 +206,7 @@ static int riowd_probe(struct platform_device *op)
 	pr_info("Hardware watchdog [%i minutes], regs at %p\n",
 		riowd_timeout, p->regs);
 
-	dev_set_drvdata(&op->dev, p);
+	platform_set_drvdata(op, p);
 	return 0;
 
 out_iounmap:
@@ -222,7 +222,7 @@ out:
 
 static int riowd_remove(struct platform_device *op)
 {
-	struct riowd *p = dev_get_drvdata(&op->dev);
+	struct riowd *p = platform_get_drvdata(op);
 
 	misc_deregister(&riowd_miscdev);
 	of_iounmap(&op->resource[0], p->regs, 2);
-- 
1.7.10.4


