Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161162Ab3BOGoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:44:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32969 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161118Ab3BOGoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:44:07 -0500
X-AuditID: cbfee690-b7f066d00000169f-2c-511dd9334ee7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 03/11] rtc: rtc-efi: use dev_err()/dev_warn()/pr_err()
 instead of printk()
Date: Fri, 15 Feb 2013 15:44:03 +0900
Message-id: <002001ce0b47$d7f2f310$87d8d930$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAADRxw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ13jm7KBBiseq1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mf6teshTM468492UzYwPjEp4uRk4OCQETibUP9zND2GISF+6t
	Z+ti5OIQEljGKLH45HWWLkYOsKJpF6DiixglZq7fxwrhzGaSeNkylx2km01ATeLLl8PsIA0i
	AvoSbS0aIDXMAr2MEmd6d4PFhQRsJabedgYxOQXsJN5PNwXpFBaIlzjydDMbiM0ioCrx5toM
	VhCbF6h68eKnzBC2oMSPyfdYQGxmAS2JzduaWCFseYnNa94yQ5ypLvHory5IWETASGLx2cNQ
	JSIS+168YwS5RkJgEbvEob55TBC7BCS+TT4E9aKsxKYD0GCQlDi44gbLBEaJWUg2z0KyeRaS
	zbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIySqJuxgvHfA+hBjMtD6icxSosn5
	wKjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	2tCt6hsyRaV0pth8uPi5PT+eS+rFmnuKfzLFmj7tk8sX0fK/tknjg3zs7fPuTNdflxSpzhda
	8HWZpMkjvjXV2zRa6p65v09etf97jKH1l08TMuZV7WM64hFw5k913F2ZLe9DC4+1f5ykpC91
	cneBzbcox+VBrC5f5s+MfSjDOHH+0nls1bM9lFiKMxINtZiLihMBYMwAnsACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7xTdlAg46ZihaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49+qlywF8/grzn3ZzNjA
	uISni5GDQ0LARGLaBbYuRk4gU0ziwr31QDYXh5DAIkaJmev3sUI4s5kkXrbMZQepYhNQk/jy
	5TA7SLOIgL5EW4sGSA2zQC+jxJne3WBxIQFbiam3nUFMTgE7iffTTUE6hQXiJY483Qy2i0VA
	VeLNtRmsIDYvUPXixU+ZIWxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWGOFld4tFfXZCwiICR
	xOKzh6FKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgTH7DPpHYyrGiwOMQpwMCrx8ApIyAYKsSaWFVfmHmKU4GBWEuFdEwIU4k1JrKxKLcqP
	LyrNSS0+xJgM9OhEZinR5HxgOskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTU
	gtQimC1MHJxSDYzlxy53f/w0XWjbonN8WZ8nz/Bc92dLnP2nnftNfCsaVkUtijRMe2x78S87
	7xwBNj7hKbbTNKe7fy1dFH7wfwmrn+XPmCYTtwVpZmH8Qv/ucyt/vbuhRmG+C++K47Jpc1z7
	24UScvb7+f4L49tsfK7j2h8GO+OIMwU9ssHV73hi1d5F6zb2KSqxFGckGmoxFxUnAgApuew+
	HQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warnings as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
  WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Repalce pr_warn(), pr_err() with dev_warn(), dev_err()

 drivers/rtc/rtc-efi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c9f890b..1a0c37c 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/time.h>
@@ -47,7 +49,7 @@ compute_wday(efi_time_t *eft)
 	int ndays = 0;
 
 	if (eft->year < 1998) {
-		printk(KERN_ERR "efirtc: EFI year < 1998, invalid date\n");
+		pr_err("EFI year < 1998, invalid date\n");
 		return -1;
 	}
 
@@ -70,7 +72,7 @@ convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 	eft->day	= wtime->tm_mday;
 	eft->hour	= wtime->tm_hour;
 	eft->minute	= wtime->tm_min;
-	eft->second 	= wtime->tm_sec;
+	eft->second	= wtime->tm_sec;
 	eft->nanosecond = 0;
 	eft->daylight	= wtime->tm_isdst ? EFI_ISDST : 0;
 	eft->timezone	= EFI_UNSPECIFIED_TIMEZONE;
@@ -142,7 +144,7 @@ static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	 */
 	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
 
-	printk(KERN_WARNING "write status is %d\n", (int)status);
+	dev_warn(dev, "write status is %d\n", (int)status);
 
 	return status == EFI_SUCCESS ? 0 : -EINVAL;
 }
@@ -157,7 +159,7 @@ static int efi_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (status != EFI_SUCCESS) {
 		/* should never happen */
-		printk(KERN_ERR "efitime: can't read time\n");
+		dev_err(dev, "can't read time\n");
 		return -EINVAL;
 	}
 
-- 
1.7.2.5


