Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493Ab3BOH0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:26:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57914 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:26:12 -0500
X-AuditID: cbfee690-b7f066d00000169f-65-511de3112c14
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 03/11] rtc: rtc-efi: use dev_err()/dev_warn()/pr_err()
 instead of printk()
Date: Fri, 15 Feb 2013 16:26:08 +0900
Message-id: <002d01ce0b4d$b95f7030$2c1e5090$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAB06Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI13Bx7KBBh0fRS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpNVbmAu28Vds3dPL2MC4laeLkZNDQsBEovvKb1YIW0ziwr31
	bF2MXBxCAssYJbZN3c0CU3Rj+QRWiMR0RonzjS3MEM5sJomDz0+CVbEJqEl8+XKYvYuRg0NE
	QF+irUUDpIZZoJdR4kzvbnaQGiEBW4mpv7+BreMUsJNYPakDLC4sEC/xfMlqsDksAqoSe6b9
	BbN5geqbZryEsgUlfky+B2YzC2hJbN7WxAphy0tsXvOWGWSvhIC6xKO/uiBhEQEjiUk3zjND
	lIhI7HvxjhHkHgmBZewS3ccvsULsEpD4NvkQC0SvrMSmA8wQD0tKHFxxg2UCo8QsJJtnIdk8
	C8nmWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kRElsTdjDeO2B9iDEZaP1EZinR
	5HxgbOaVxBsaG5uYmZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	A6N8kXBgXsLiFt3D5x3Tb+jk3PGRuPY6NilL5d3mbWtD6jc/r2e7dy5vb8LJrI1/j/6fEX7u
	sfr9fTWdhw+yVImpc+3PWjW5duk37q7pq69NaBT9bWh0Ij9NwyTLpXvJu5dfaq+5aTo7MRn/
	FvnzmnuLR+fU0xsaSoV6n/6aI8UZlc3R/baGt1uJpTgj0VCLuag4EQAI1HAzwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK7gY9lAg3nfBS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqTVW5gLtvFXbN3Ty9jA
	uJWni5GTQ0LAROLG8gmsELaYxIV769m6GLk4hASmM0qcb2xhhnBmM0kcfH6SBaSKTUBN4suX
	w+xdjBwcIgL6Em0tGiA1zAK9jBJnenezg9QICdhKTP39DWwqp4CdxOpJHWBxYYF4iedLVoPN
	YRFQldgz7S+YzQtU3zTjJZQtKPFj8j0wm1lAS2LztiZWCFteYvOat8wgeyUE1CUe/dUFCYsI
	GElMunGeGaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWle
	ul5yfu4mRnDkPpPawbiyweIQowAHoxIPr4CEbKAQa2JZcWXuIUYJDmYlEV65W0Ah3pTEyqrU
	ovz4otKc1OJDjMlAj05klhJNzgcmlbySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnN
	Tk0tSC2C2cLEwSnVwKjh+8YqoYOPdZP9co8pC955XY5N7ivNz8pY/kaaa018bJr73rfZ+hlv
	TqUvOvJ+069t0zU/7dOS9wl9U8G++np6SbfbhHUuKmd/H/0ZeVL+2vnK6xXMcVxP1WvXn1da
	//WNrOay85vL/tUtfLm09E5Gd+epD9VzzKMU+T5Km+nNnNPCy9ie16bEUpyRaKjFXFScCAAo
	52G5IAMAAA==
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

No changes since v2:

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


