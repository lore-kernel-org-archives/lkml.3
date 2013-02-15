Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3BOF6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:58:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25522 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3BOF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:58:46 -0500
X-AuditID: cbfee68e-b7fc26d000001938-f9-511dce95dfd3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 03/11] rtc: rtc-efi: use pr_err()/pr_warn() instead of printk()
Date: Fri, 15 Feb 2013 14:58:45 +0900
Message-id: <001401ce0b41$83d7c9a0$8b875ce0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAChJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zfd2p52QDDa7dVrW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZGy/pFRzmqzg1v7SB8SZ3FyMHh4SAicSZ9xpdjJxAppjEhXvr
	2boYuTiEBJYxSvQ/ucwIkTCRWNH7mhUiMZ1R4uK8Tqiq2UwS2zecAKtiE1CT+PLlMDvIVBEB
	fYm2Fg2QGmaBXkaJM7272UFqhARsJSZ8WscMYnMK2El8//OQDcQWFvCXaO14DzSHnYNFQFWi
	WQkkygtUvXvPXBYIW1Dix+R7YDazgJbE5m1NrBC2vMTmNW+ZIX5Rl3j0VxckLCJgJPFl7kuo
	EhGJfS/eQb2yiF1i0aZ6EJtFQEDi2+RDLBCtshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8ni
	WUg2LGBkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREk99OxhvHrA+xJgMtH4is5Rocj4w
	HvNK4g2NjU3MTExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFg
	ua73ZwmOt9JteeuFDbk5W7es6zGqaZr1R646dXHhc78DL7kviBX8nHRD8fszz84Txgt+/+6Q
	fHvfu69Er6b33ZNJIVl/W2LkP12wLw0oKpw2+e2STLM1ORy/uD/4u75ZzPrcU0ps7vraGvN5
	M6Qc5sZXf5zbfXPLIcfp9ro/Gzwk3i64+kmJpTgj0VCLuag4EQCtVIggvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO7Uc7KBBlcfKlhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjI2X9AoO81Wcml/awHiT
	u4uRk0NCwERiRe9rVghbTOLCvfVsXYxcHEIC0xklLs7rhHJmM0ls33CCEaSKTUBN4suXw+xd
	jBwcIgL6Em0tGiA1zAK9jBJnenezg9QICdhKTPi0jhnE5hSwk/j+5yEbiC0s4C/R2vEeaA47
	B4uAqkSzEkiUF6h69565LBC2oMSPyffAbGYBLYnN25pYIWx5ic1r3jKDbJUQUJd49FcXJCwi
	YCTxZe5LqBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnp
	esn5uZsYwRH7THoH46oGi0OMAhyMSjy8AhKygUKsiWXFlbmHGCU4mJVEeNeEAIV4UxIrq1KL
	8uOLSnNSiw8xJgO9OZFZSjQ5H5hM8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2xJDU7
	NbUgtQhmCxMHp1QDY1l4wwbOyZ/3XIqXeTRNn9OFbfuvuw3vvafqrVEQbrwkwyzl8lT7wTxL
	C5eqNJ4fuXfe/fjp3a3mFHk+oe5rmP3G/LnaBqsX+7yV0/5nOZ8z7brAP83TomdTF+4Un3Xy
	57tvpjpTRPnvSr6SzVpcldPg2y9+rTt3tmjY7k622UIzbbZ0MjJ8U2Ipzkg01GIuKk4EABUD
	TV8cAwAA
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
 drivers/rtc/rtc-efi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c9f890b..d4755dc 100644
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
+	pr_warn("write status is %d\n", (int)status);
 
 	return status == EFI_SUCCESS ? 0 : -EINVAL;
 }
@@ -157,7 +159,7 @@ static int efi_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (status != EFI_SUCCESS) {
 		/* should never happen */
-		printk(KERN_ERR "efitime: can't read time\n");
+		pr_err("can't read time\n");
 		return -EINVAL;
 	}
 
-- 
1.7.2.5


