Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3CFFdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:33:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25916 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3CFFdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:33:38 -0500
X-AuditID: cbfee68d-b7f636d0000009be-18-5136d531e5e1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 19/30] rtc: rtc-pcf8523: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:33:36 +0900
Message-id: <005501ce1a2c$26892b50$739b81f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAN/0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA13Dq2aBBkv38VgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsaftMVPBC/aKS0eeMDUw7mDrYuTkkBAwkXiy6zEThC0mceHeeqA4F4eQwDJGiQlf
	NjDDFHVffssEkZjOKHF0zWmoql+MErvXb2YEqWITUJP48uUwexcjB4eIgL5EW4sGSA2zQC+j
	xJne3ewgNUICthJXu1eBTeUUsJNY/ngWC4gtLOAu0bfpGAtIL4uAqsS6SSUgYV6g8vmfF7JC
	2IISPybfAytnFtCSWL/zOBOELS+xec1bZpBWCQF1iUd/dUHCIgJGEtsmT2aDKBGR2PfiHSPI
	ORIC99glDs84BdbLIiAg8W3yIRaIXlmJTQeg/pWUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJFJ7dzDePmB9iDEZaP1EZinR5HxgpOeVxBsa
	G5uYmZiamFuampuSJqwkzit3SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OS3wT7mr11
	6z/XfpzVsOdH22vxA16u2b36QQk5PzeK7yzMXOyR5hq4/uNKpeU287NEj368WrHRda1v3Ix1
	9Xf/5DUlrXn9R0M4gGfhMtlr1zX6Tae/XL7zsIjuQo5b9ad/XZ8YvP1GZANf/m5T3nX5R01T
	rFqaX1hIVc/6c/A3Y+vhQ1sefnuvxFKckWioxVxUnAgA6SzhjeoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3Dq2aBBg9bOCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjT9pip4AV7xaUjT5gaGHewdTFyckgImEh0
	X37LBGGLSVy4tx4ozsUhJDCdUeLomtNQzi9Gid3rNzOCVLEJqEl8+XKYvYuRg0NEQF+irUUD
	pIZZoJdR4kzvbnaQGiEBW4mr3auYQWxOATuJ5Y9nsYDYwgLuEn2bjrGA9LIIqEqsm1QCEuYF
	Kp//eSErhC0o8WPyPbByZgEtifU7jzNB2PISm9e8ZQZplRBQl3j0VxckLCJgJLFt8mQ2iBIR
	iX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWng
	mfQOxlUNFocYBTgYlXh4J6iYBQqxJpYVV+YeYpTgYFYS4eU6AxTiTUmsrEotyo8vKs1JLT7E
	mAz050RmKdHkfGCKyiuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwc
	nFINjMxbMnxbxPk37Dt9+mbMAS1FnbPnyu0Mj2zzFWpn9WXIrVHlWL1HddGyn0mnL55jVNi9
	6HFpF3NV/mmRle+jxSbfmL02MU14S+dDo8wsYZef6dn37kw0SLRVNM35FPrme3lm8ImdFzk2
	NzO+2rq1blK6/BFGn/eOJmwZCzMPL1miXBusumyWjxJLcUaioRZzUXEiAEBde8FHAwAA
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
 drivers/rtc/rtc-pcf8523.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
index 889e316..4c62793 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -307,7 +307,7 @@ static int pcf8523_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
-	pcf->rtc = rtc_device_register(DRIVER_NAME, &client->dev,
+	pcf->rtc = devm_rtc_device_register(DRIVER_NAME, &client->dev,
 				       &pcf8523_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcf->rtc))
 		return PTR_ERR(pcf->rtc);
@@ -319,10 +319,6 @@ static int pcf8523_probe(struct i2c_client *client,
 
 static int pcf8523_remove(struct i2c_client *client)
 {
-	struct pcf8523 *pcf = i2c_get_clientdata(client);
-
-	rtc_device_unregister(pcf->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


