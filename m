Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3CNIQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:16:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24834 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3CNIQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:16:09 -0400
X-AuditID: cbfee68d-b7f786d000005188-cf-514187487a5a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 14/30] rtc: rtc-m41t94: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:16:07 +0900
Message-id: <009101ce208c$2e132540$8a396fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAMRCw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zA12PdsdAg7e7BC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOH5VpOAre8W0D3PYGhgPsXUxcnJICJhIvF+3kgXCFpO4cG89UJyLQ0hgGaPEitXd
	7DBF0x68ZASxhQSmM0qs3CwIUfSLUeLdsQlgRWwCahJfvhwGsjk4RAT0JdpaNEBqmAV6GSXO
	9O4GiwsJ2Epc/28HYnIK2ElsWC8G0iks4CZx7vxTsBtYBFQlJm1bxApi8wJVL/66D8oWlPgx
	+R5YDbOAlsT6nceZIGx5ic1r3jKDjJQQUJd49FcX4gAjiQ23oapFJPa9eMcIcoyEwCV2ieW7
	5jJCrBKQ+Db5EAtEq6zEpgPMEM9KShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpakFxQ
	nJReZKhXnJhbXJqXrpecn7uJERKhvTsYbx+wPsSYDLR+IrOUaHI+MMLzSuINjc2MLExNTI2N
	zC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4qHJSTtTUyksn7trl3ri3
	2Gb5s4oTq66HpexQ+az+4vMvtVVtzvOcQ2pvepvn+KS11U4tCb8TLHNvb53Zs3JDa987fDEz
	jXQMGM8967/s9vyFnOhL4Xm3Fv9ZcCtD7dPXyu7PjyLWH9GL4TyxLMC13qlEp15j2m+vmbW/
	1j6uOc66SrrQd6OUEktxRqKhFnNRcSIAhd7Y6eYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQV2PdsdAg71zeS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDh+VaTgK3vFtA9z2BoYD7F1MXJySAiYSEx7
	8JIRwhaTuHBvPVhcSGA6o8TKzYJdjFxA9i9GiXfHJrCDJNgE1CS+fDkMZHNwiAjoS7S1aIDU
	MAv0Mkqc6d0NFhcSsJW4/t8OxOQUsJPYsF4MpFNYwE3i3PmnLCA2i4CqxKRti1hBbF6g6sVf
	90HZghI/Jt8Dq2EW0JJYv/M4E4QtL7F5zVtmkJESAuoSj/7qQhxgJLHhNlS1iMS+F+8YJzAK
	zUIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOD4fya9g3FVg8Uh
	RgEORiUe3ghRx0Ah1sSy4srcQ4wSHMxKIryeXkAh3pTEyqrUovz4otKc1OJDjMlAf05klhJN
	zgemprySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYIxRaTZQ
	FXi425ivyWH1lJr/3I0hRyPaGhMZORbzuZXyZm712nBW+3TFpbN3tHnbmI99YMv+emdKK7fU
	aWtJ1U/fHxx9t+tnz9ZnpoHtO+a7hVYyTcrS7Jpp57koqoBlagzPJqnsM3vKw8O6Cq2uXIq4
	+uZeTeGlt7lW0/+JXzk3YfaFJ9v7LJVYijMSDbWYi4oTAeIfrxFDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m41t94.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index 89266c6..cf655a9 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -124,8 +124,8 @@ static int m41t94_probe(struct spi_device *spi)
 		return res;
 	}
 
-	rtc = rtc_device_register(m41t94_driver.driver.name,
-		&spi->dev, &m41t94_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, m41t94_driver.driver.name,
+					&m41t94_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -136,11 +136,6 @@ static int m41t94_probe(struct spi_device *spi)
 
 static int m41t94_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = spi_get_drvdata(spi);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


