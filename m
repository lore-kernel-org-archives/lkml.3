Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3CFFeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:34:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17314 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3CFFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:34:14 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-a5-5136d555f128
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 21/30] rtc: rtc-snvs: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:34:13 +0900
Message-id: <005701ce1a2c$3c56fca0$b504f5e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAPcmA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zI93Qq2aBBku2aFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMet7J2PBDfaKwz97WRsY17N1MXJySAiYSMx+fx7KFpO4cA8kzsUhJLCMUeL+5NXs
	MEV//p9nhkhMZ5SYt+wDlPOLUeLA9n/MIFVsAmoSX74cBurg4BAR0Jdoa9EAqWEW6GWUONO7
	G2ySkICtxNXuVWD1nAJ2Essfz2IBsYUFXCRWbuxjBLFZBFQlbn18BnYSL1B955O9rBC2oMSP
	yffA6pkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJq/taoUpEJPa9eMcIco+EwD12
	ia9Nl9ggdglIfJt8iAWiV1Zi0wFmiIclJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0t
	SC4oTkovMtIrTswtLs1L10vOz93ECInVvh2MNw9YH2JMBlo/kVlKNDkfGOt5JfGGxsYmZiam
	JuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIdWuOl40dw1WhLQ+D
	hTUahW4/Y0rYHTz3d+AOf9/Zcmfa7uYFzPlovvjt857Ln0QOaBW+3XUzQHtl9b3U4jlHJ6+o
	kav3WVJlcr9/8SQP41N5T8u3WWtO9tKdde+kt9EDV7WwKYZHQk80h0v4b8w79/TQharo2Cdi
	Li6qO9ikbQSunxLm3MCpxFKckWioxVxUnAgAGE3WoesCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3Qq2aBBr961C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJj1vZOx4AZ7xeGfvawNjOvZuhg5OSQETCT+
	/D/PDGGLSVy4BxLn4hASmM4oMW/ZB2YI5xejxIHt/8Cq2ATUJL58OczexcjBISKgL9HWogFS
	wyzQyyhxpnc3O0iNkICtxNXuVWD1nAJ2Essfz2IBsYUFXCRWbuxjBLFZBFQlbn18BnYFL1B9
	55O9rBC2oMSPyffA6pkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJq/taoUpEJPa9
	eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeCZ9I7
	GFc1WBxiFOBgVOLhnaBiFijEmlhWXJl7iFGCg1lJhJfrDFCINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84FJKq8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1KzU1MLUotgtjBxcEo1
	MG6+vH6GV8mbn9dWMZRn7Hi3ness862gH2HL1Lk38n7fkf7OWv/px23xnAV2L+9s+r7u3b6/
	LC9nGz25oeL/69H2kMOuL7Ju69sXa1+/VLk+xWbhjAnv/qxO0G9o4y9MYbgkeZYvVXHL3Rli
	hTPMWOOcroix3wtZ6BfPEJ+nYvCBQWXl4lqZ20JKLMUZiYZazEXFiQAmyZRGSAMAAA==
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
 drivers/rtc/rtc-snvs.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index f7d9070..3ce6f84 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -283,7 +283,7 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	data->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	data->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 					&snvs_rtc_ops, THIS_MODULE);
 	if (IS_ERR(data->rtc)) {
 		ret = PTR_ERR(data->rtc);
@@ -296,10 +296,6 @@ static int snvs_rtc_probe(struct platform_device *pdev)
 
 static int snvs_rtc_remove(struct platform_device *pdev)
 {
-	struct snvs_rtc_data *data = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(data->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


