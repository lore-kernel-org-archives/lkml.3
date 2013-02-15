Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556Ab3BOH3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:29:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58444 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOH3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:29:17 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-b4-511de3cc6592
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 07/11] rtc: rtc-rs5c313: use pr_err() instead of printk()
Date: Fri, 15 Feb 2013 16:29:15 +0900
Message-id: <003101ce0b4e$28d3b200$7a7b1600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAIHEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI90zj2UDDe7sELG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZmx7eYy3YzVHRv7eDvYHxJVsXIyeHhICJxJW3Z1khbDGJC/fW
	A8W5OIQEljFKzFi4iQWm6MPvNcwQiemMEkenwjizmSQmHT8FNopNQE3iy5fD7F2MHBwiAvoS
	bS0aIDXMAr2MEmd6d7OD1AgJ2EpM/f0NbB2ngJ3E6kkdYHFhAR+Jqy1nwbaxCKhKfLlwnQnE
	5gWqX/XwB5QtKPFj8j2wGmYBLYnN25pYIWx5ic1r3jKD7JUQUJd49FcXJCwiYCTxeMVxJogS
	EYl9L94xgtwjIbCMXWLmkX/MELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEVu8OxtsHrA8xJgOtn8gsJZqc
	D4zNvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	lBRosz0sXFRW9Tlu6je9vyurF17rqctn2rZca5Nx+qdNFdbGc27w2syI3rPFRfuaYPTLP9M6
	ms3+VX+fFtOjXyhlqRIo/cxOrM7009ePPJOu/e/d6zbfeG3epXc23y+zSpf8/p0U3vN7DnvV
	sVNlF+adaHiskqux8Eq4Sub/5DNbThVE57s+V2Ipzkg01GIuKk4EAID88jPDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO6Zx7KBBh9v8Vtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE0P77EW7Oao6N/bwd7A
	+JKti5GTQ0LAROLD7zXMELaYxIV764HiXBxCAtMZJY5OBUmAOLOZJCYdPwXWwSagJvHly2H2
	LkYODhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJab+/sYKYnMK2EmsntQBFhcW8JG42nKWBcRm
	EVCV+HLhOhOIzQtUv+rhDyhbUOLH5HtgNcwCWhKbtzWxQtjyEpvXvGUG2SshoC7x6K8uSFhE
	wEji8YrjTBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYIj95n0DsZVDRaHGAU4GJV4eAUkZAOFWBPLiitzDzFKcDArifDK3QIK8aYkVlal
	FuXHF5XmpBYfYkwGenQis5Rocj4wqeSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6Yklq
	dmpqQWoRzBYmDk6pBkaVbO89wru8nA5srmz6+XjF1fbZ9SLv152fUG612utgz/zWz5Lf7uso
	sljsXMjyeSXbc6kbhTxXo56/+Kx++7h1T1L6w2aPxy82FUv9mFOeduaM7QfpZcZLpL7E6t7s
	OrrLiPO+fdq7SfpqC12naq+UdXd5a/Ps8G2lE49Kew8snCIcdSNsxloVJZbijERDLeai4kQA
	zkVYoyADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

Changes since v2:
- Remove redundant prefix

 drivers/rtc/rtc-rs5c313.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
index d1aee79..d98ea5b 100644
--- a/drivers/rtc/rtc-rs5c313.c
+++ b/drivers/rtc/rtc-rs5c313.c
@@ -39,6 +39,8 @@
  *	1.13	Nobuhiro Iwamatsu: Updata driver.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/rtc.h>
@@ -352,8 +354,7 @@ static void rs5c313_check_xstp_bit(void)
 		tm.tm_year 	= 2000 - 1900;
 
 		rs5c313_rtc_set_time(NULL, &tm);
-		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
-				"1 Jan 2000\n");
+		pr_err("invalid value, resetting to 1 Jan 2000\n");
 	}
 	RS5C313_CEDISABLE;
 	ndelay(700);		/* CE:L */
-- 
1.7.2.5


