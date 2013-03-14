Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3CNIOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:14:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42502 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:13:59 -0400
X-AuditID: cbfee68d-b7f786d000005188-35-514186c687bd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 08/30] rtc: rtc-efi: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:13:58 +0900
Message-id: <008b01ce208b$e0c89db0$a259d910$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAHLBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zA91jbY6BBkcuKlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceN1C1vBRfaKP1u2sTQwLmfrYuTgkBAwkbjUJ9/FyAlkiklcuLceKMzFISSwjFHi
	7bdTzDA1X585QsSnM0ps2feKCaRBSOAXo8TFhjgQm01ATeLLl8PsIPUiAvoSbS0aIPXMAr2M
	Emd6d4PFhQRsJa7/twMxOQXsJDasFwPpFBZwlph/YDILiM0ioCqxe1sPmM0LVP3w2z5mCFtQ
	4sfke2BxZgEtifU7jzNB2PISm9e8hbpSXeLRX12QsIiAkcSR9/fZIEpEJPa9eMcIco2EwD12
	iQMnrjFC7BKQ+Db5EAtEr6zEpgPMkFCQlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yFCvODG3uDQvXS85P3cTIyRCe3cw3j5gfYgxGWj9RGYp0eR8YITnlcQbGpsZWZia
	mBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRz7w/+/oT9SjuA98q
	P8UruGzedv2YGr9c4Z9bSwwer1oTIvHGm2fK5ac2wVE98x6+KLcWT1AMO+NtYrrrOcNlznVv
	F4t3rKu9ff1GT1p3S+hf3u4njFeKbqkb3he6689ZcfnrVtFfcoE2+7bEcbV8D11/YesHphcf
	+vlPyy3+O4e5qu14DnOEEktxRqKhFnNRcSIAUsT7IOYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd1jbY6BBlMOyVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHjdQtbwUX2ij9btrE0MC5n62Lk4JAQMJH4
	+syxi5ETyBSTuHBvPVCYi0NIYDqjxJZ9r5hAEkICvxglLjbEgdhsAmoSX74cZgfpFRHQl2hr
	0QCpZxboZZQ407sbLC4kYCtx/b8diMkpYCexYb0YSKewgLPE/AOTWUBsFgFVid3besBsXqDq
	h9/2MUPYghI/Jt8DizMLaEms33mcCcKWl9i85i0zxMXqEo/+6oKERQSMJI68v88GUSIise/F
	O8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAE8k9rB
	uLLB4hCjAAejEg/vgX6HQCHWxLLiytxDjBIczEoivJ5ejoFCvCmJlVWpRfnxRaU5qcWHGJOB
	Hp3ILCWanA9MTnkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wGgWey3M9cS/RS2JU9RWfNo5N9zmzUajOSUZH84UxgZHvIiuKznPuDhmkszEyYsLS6cGXK3j
	eZKy5ovTDw9r7c+fnuz2qIo97WksnZdS9kFLqFEkn73X2b/kNc8EF5EOkf8v3lztc5goaZU1
	P01N71nEOtnVa49FPxN4Of12qJLu2smup3qe8SuxFGckGmoxFxUnAgCpWCG6RAMAAA==
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
 drivers/rtc/rtc-efi.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index e706662..b3c8c0b 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -191,7 +191,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("rtc-efi", &dev->dev, &efi_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -203,10 +203,6 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 
 static int __exit efi_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


