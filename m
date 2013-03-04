Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3CDH71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:59:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31778 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CDH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:59:26 -0500
X-AuditID: cbfee690-b7f6b6d000004563-b8-5134545c78d4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 05/24] rtc: rtc-coh901331: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:59:24 +0900
Message-id: <013e01ce18ae$2fd509b0$8f7f1d10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAD/Uw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI92YEJNAg8+fTSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGjLcrWApmcVTcb7rH1sDYzd7FyMkhIWAisfD8NWYIW0ziwr31
	bF2MXBxCAssYJfYv6maCKdrcNocNxBYSWMQocXFTGkTRbCaJLdM/s4Ak2ATUJL58OQw0lYND
	REBfoq1FA6SGWaCXUeJM7252iGZbiS8PH4AN5RSwk7h/bhUriC0s4CvRNv8C2AIWAVWJWb+m
	MILYvED1f7ddYYGwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYS0/7s
	YIcoEZHY9+IdI8g9EgLL2CU27JvBDLFLQOLb5EMsEL2yEpsOQANCUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJDImrCD8d4B60OMyUDrJzJL
	iSbnAyMzryTe0NjYxMzE1MTc0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYxXQv7BJTllrkFfNM4/AWmXWLQzx3Jj98WdgeaOTMw6YmJvtaQnNh38tIzu8Vucu+Cxy+
	sGqN7nk11/u3uRV8/f8/MnrauXXPmYsXxHZ48f9p0BZtf5VrodgReFt7uvrJzGNBfcb7v206
	vlanu0L9WHBui49j8uuPm9ZYu1Y925T2sLLF3ny9EktxRqKhFnNRcSIAe8ZbuMICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG5MiEmgwcRjehaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8bbFSwFszgq7jfdY2tg
	7GbvYuTkkBAwkdjcNocNwhaTuHBvPZgtJLCIUeLiprQuRi4gezaTxJbpn1lAEmwCahJfvhwG
	aubgEBHQl2hr0QCpYRboZZQ407ubHaLZVuLLwwdMIDangJ3E/XOrWEFsYQFfibb5F8AWsAio
	Ssz6NYURxOYFqv+77QoLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEw
	kpj2Zwc7RImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Lh9JrWDcWWDxSFGAQ5GJR5egU/GgUKsiWXFlbmHGCU4mJVEeMskTAKFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YUvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA2OHYLxM6rmLFp9XPzl6wEb40KMQrW/3mBdVya3Rk69U0OOb/tK5/8OB
	DX/v7P/ppez5/Q7/J23F/iWhk38e/PrdLVIms8nL5+0Fxe+nb06YX6+8Z/q20IDOwp/e38Ll
	K7O2fN1cq//CpIBH+GRibOPcTONZek3bFCr+nvcKYK//fGLth5krXL2UWIozEg21mIuKEwFT
	eh5iHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 2d28ec1a..f53fcd6 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -287,18 +287,7 @@ static struct platform_driver coh901331_driver = {
 	.shutdown = coh901331_shutdown,
 };
 
-static int __init coh901331_init(void)
-{
-	return platform_driver_probe(&coh901331_driver, coh901331_probe);
-}
-
-static void __exit coh901331_exit(void)
-{
-	platform_driver_unregister(&coh901331_driver);
-}
-
-module_init(coh901331_init);
-module_exit(coh901331_exit);
+module_platform_driver_probe(coh901331_driver, coh901331_probe);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
 MODULE_DESCRIPTION("ST-Ericsson AB COH 901 331 RTC Driver");
-- 
1.7.2.5


