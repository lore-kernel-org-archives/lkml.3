Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaBLFRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:17:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24923 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaBLFRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:17:10 -0500
X-AuditID: cbfee68f-b7f156d00000276c-38-52fb03d41795
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] hwrng: atmel - Use devm_ioremap_resource()
Date: Wed, 12 Feb 2014 14:17:08 +0900
Message-id: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8nsadSW6n/hyJ4ROCDFcv21NZRfw==
Content-language: ko
x-cr-hashedpuzzle: Bhkk IKxd LIPN TZ0d UWKj U0oi aUNi aYSL fg6w fr7n jlym mVSc
 mWhm papt tHvO
 55ll;5;aABlAHIAYgBlAHIAdABAAGcAbwBuAGQAbwByAC4AYQBwAGEAbgBhAC4AbwByAGcALgBhAHUAOwBqAGEAYwBtAGUAdABAAHMAdQBuAHMAaQB0AGUALgBkAGsAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG4AaQBjAG8AbABhAHMALgBmAGUAcgByAGUAQABhAHQAbQBlAGwALgBjAG8AbQA=;Sosha1_v1;7;{090400C8-8A5F-4DCE-B569-515BEEC00139};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 12 Feb 2014 05:16:58
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMgBdACAAaAB3AHIAbgBnADoAIABhAHQAbQBlAGwAIAAtACAAVQBzAGUAIABkAGUAdgBtAF8AaQBvAHIAZQBtAGEAcABfAHIAZQBzAG8AdQByAGMAZQAoACkA
x-cr-puzzleid: {090400C8-8A5F-4DCE-B569-515BEEC00139}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zQ90rzL+DDM7eELZ4eUjTovuVjMXp
	S9cYLS4vvMRqcXnXHDaLb5eb2R3YPBb82srise2AqkffllWMHtNen2fz+LxJLoA1issmJTUn
	syy1SN8ugStj77/VjAU3uSqOTj3B1sD4l6OLkZNDQsBE4uSUF4wQtpjEhXvr2boYuTiEBJYx
	Sixb1s8GU/Tx+lqoxCJGifbpf9ghnF+MEm9fHgKrYhNQk/jy5TA7iC0ioCfRt76REaSIWWAG
	o8TUjxOYQRLCAvYSy5sege1jEVCV2LmnC8zmFbCVuL7tBxuELSjxY/I9FhCbWUBLYv3O40wQ
	trzE5jVvgeZwAJ2kLvHory7MrkeL5kGVi0jse/EObK+EwAFWiXXff0K9YCqx6vMuqMQtdomn
	E56zQhwhIPFt8iEWiKGyEpsOMEPUS0ocXHGDZQKjxCwkJ81CctIsJCfNQrJ7ASPLKkbR1ILk
	guKk9CJjveLE3OLSvHS95PzcTYyQmO3fwXj3gPUhxmSg9ROZpUST84Exn1cSb2hsZmRhamJq
	bGRuaUaasJI47/2HSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGM2OGR5Z/zL1zrSP7JzP
	U+4UlaacWvX6pPsGs7L5C400fVqtW8/febdj/0PfONm/h6ufXYrW8fgVl/zjL2NraMXkPMu1
	bZr/qtW2LHfSevf7L7vfn5fXOjZbThV7fGox+zcmsee9j7QL106TZ8gwCHIWC3nm43tmUhHv
	udOa7owOAR0nL9etuKnEUpyRaKjFXFScCACOdSBe7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd0rzL+DDDbO5rd4eUjTovuVjMXp
	S9cYLS4vvMRqcXnXHDaLb5eb2R3YPBb82srise2AqkffllWMHtNen2fz+LxJLoA1qoHRJiM1
	MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdov5JCWWJOKVAo
	ILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY++/1YwFN7kqjk49wdbA+Jeji5GTQ0LA
	ROLj9bVsELaYxIV764FsLg4hgUWMEu3T/7BDOL8YJd6+PARWxSagJvHly2F2EFtEQE+ib30j
	I0gRs8AMRompHycwgySEBewlljc9YgSxWQRUJXbu6QKzeQVsJa5v+8EGYQtK/Jh8jwXEZhbQ
	kli/8zgThC0vsXnNW6A5HEAnqUs8+qsLs+vRonlQ5SIS+168A9srIXCAVWLd959QL5hKrPq8
	i3ECo9AsJCtmIVkxC8mKWUhmLWBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnBCeSe9g
	XNVgcYhRgINRiYeXwfNXkBBrYllxZe4hRgkOZiURXv0TQCHelMTKqtSi/Pii0pzU4kOMycAQ
	mMgsJZqcD0xWeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	6Lvj+lOF2EU3XAWDb/FvKBPatG51+C2tunuFb4Mni74LX6r6IvfuaiW+JacqijuE5uRV7rN8
	I9Vf83HGKhYe7tLDbXqJX++7r3pVPaVVPvfT9jOaB9L+J386arxkuUhOnsTjd2365/96pGye
	USV6aOPO2enMrp8v7Xy7PFCale++SjMP1zvWQCWW4oxEQy3mouJEACbim+JMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and remove redundant return value check of platform_get_resource()
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/atmel-rng.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index bf9fc6b..dfeddf2 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -54,21 +54,14 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
 	if (!trng)
 		return -ENOMEM;
 
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     resource_size(res), pdev->name))
-		return -EBUSY;
-
-	trng->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!trng->base)
-		return -EBUSY;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	trng->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(trng->base))
+		return PTR_ERR(trng->base);
 
 	trng->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(trng->clk))
-- 
1.7.10.4


