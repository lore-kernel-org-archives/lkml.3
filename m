Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161220Ab3BOGqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:46:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33992 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161207Ab3BOGqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:46:43 -0500
X-AuditID: cbfee690-b7f066d00000169f-de-511dd9d2f784
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 07/11] rtc: rtc-rs5c313: use pr_err() instead of printk()
Date: Fri, 15 Feb 2013 15:46:42 +0900
Message-id: <002501ce0b48$36cf28e0$a46d7aa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAJeUA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ91LN2UDDQ706Vlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHU8fshbM4qhY8WQySwPjRbYuRk4OCQETicNztjNC2GISF+6t
	B4pzcQgJLGOUmNjWwwhT9PzWA3aIxCJGiZ+LljNCOLOZJJ52PAGrYhNQk/jy5TBQFQeHiIC+
	RFuLBkgNs0Avo8SZ3t1gcSEBW4mpt51BTE4BO4n3001BTGEBH4l1y11AhrAIqEpc/LgI7DZe
	oOKDz1+yQtiCEj8m32MBsZkFtCQ2b2tihbDlJTavecsMMkZCQF3i0V9diP1GEmv+aUFUiEjs
	e/EO7F4JgXnsEpuWfWKHWCUg8W3yIRaIVlmJTQeYIZ6VlDi44gbLBEaJWUgWz0KyeBaSxbOQ
	rFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIySmJuxgvHfA+hBjMtD6icxSosn5wJjM
	K4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGag2m
	ya8DNPT1uXgLcqZUXjecz9Z7J+HZUzm5aeH1az9IOb40T3HuvbYjnOnjrC+3ip6+UpkscDHd
	8sH08hTtivrpVjw6WRdENHMSf86SXuvYb5zU2fkzVaeO3eBGQxij5gKNM9ILA/cw2nZP77y8
	7lEHq1zltZdn+/62bxK7ZxxuHPRHKkCJpTgj0VCLuag4EQD5E3c9vwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgO6lm7KBBqs2aFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjB1PH7IWzOKoWPFkMksD
	40W2LkZODgkBE4nntx6wQ9hiEhfurQeKc3EICSxilPi5aDkjhDObSeJpxxNGkCo2ATWJL18O
	A3VwcIgI6Eu0tWiA1DAL9DJKnOndDRYXErCVmHrbGcTkFLCTeD/dFMQUFvCRWLfcBWQIi4Cq
	xMWPi8BO4AUqPvj8JSuELSjxY/I9FhCbWUBLYvO2JlYIW15i85q3zCBjJATUJR791YXYbySx
	5p8WRIWIxL4X7xgnMArNQjJoFpJBs5AMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4Ih9JrWDcWWDxSFGAQ5GJR5eAQnZQCHWxLLiytxDjBIczEoivGtCgEK8KYmVValF+fFF
	pTmpxYcYk4H+nMgsJZqcD0wmeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5YkpqdmlqQ
	WgSzhYmDU6qBMcR+2jk2G5713+L6fbMczrwLKX4tuqEuSXZCdc01/ukqc2ZM5Xh13iKpdk+r
	1LS1m7YH8ezb2nAgXI0v105i0WRbhZkcWZF7mgOF91tw2Dut1pRWnStjI14348+JHCvNUKcf
	q9e6pP0Tlky3nDLxcNKsqzm10l8mBsl/8HCsNxGdF1izeKWzEktxRqKhFnNRcSIAeQxmlRwD	AAA=
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

 drivers/rtc/rtc-rs5c313.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
index d1aee79..8ca55a6 100644
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
+		pr_err("RICHO RS5C313: invalid value, resetting to 1 Jan 2000\n");
 	}
 	RS5C313_CEDISABLE;
 	ndelay(700);		/* CE:L */
-- 
1.7.2.5


