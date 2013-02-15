Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161065Ab3BOGB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:01:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26267 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3BOGBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:01:25 -0500
X-AuditID: cbfee691-b7f556d000001a24-fb-511dcf349938
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 07/11] rtc: rtc-rs5c313: use pr_err() instead of printk()
Date: Fri, 15 Feb 2013 15:01:24 +0900
Message-id: <001801ce0b41$e2a53260$a7ef9720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAIGmw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ12T87KBBrsXalhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLQueshQ0cVT8b7zL1MB4gK2LkZNDQsBEYs+aRYwQtpjEhXvr
	weJCAssYJY6uT4Wp+T31GVCcCyi+iFFiw8bvzBDObCaJb+f2MoFUsQmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhlmgl1HiTO9udoipthITPq1jBrE5Bewkvv95yAZSLyzgKbH7phNImEVAVeL0lxdg
	JbxA5ed/bYSyBSV+TL7HAmIzC2hJbN7WxAphy0tsXvOWGWSMhIC6xKO/uiBhEQEjiW8tn5gh
	SkQk9r14B/XjMnaJ2ddMIVYJSHybfIgFolVWYtMBZogSSYmDK26wTGCUmIVk8Swki2chWTwL
	yYYFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUKiauIOxvsHrA8xJgOtn8gsJZqcD4zK
	vJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgnG68
	mrl01b07abJZP84Vbzgm/uZgvSv3tllHD9xjzL4pw3xp+aFtZ/5pJs57XFfMteqyZHvVlb5E
	+66Hpf4BtzZ+vr3t/XI/+2NaXp76S902zrlv+EkiUEf/5LMbtxa+fcm39vFqYT1mtZN3WJ3m
	Pv4VdiDT++6ZNSxhuud5A3lWxl86o+f/VE2JpTgj0VCLuag4EQBGnCYlwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK7JedlAg4NflSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpYFT1kKmjgq/jfeZWpg
	PMDWxcjJISFgIvF76jMoW0ziwr31QDYXh5DAIkaJDRu/M0M4s5kkvp3bywRSxSagJvHly2H2
	LkYODhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJSZ8WscMYnMK2El8//OQDaReWMBTYvdNJ5Aw
	i4CqxOkvL8BKeIHKz//aCGULSvyYfI8FxGYW0JLYvK2JFcKWl9i85i0zyBgJAXWJR391QcIi
	AkYS31o+MUOUiEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7N
	S9dLzs/dxAiO22fSOxhXNVgcYhTgYFTi4RWQkA0UYk0sK67MPcQowcGsJMK7JgQoxJuSWFmV
	WpQfX1Sak1p8iDEZ6NGJzFKiyfnAlJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp
	2ampBalFMFuYODilGhhZdl7bxpjxqupqx+KH165984g6WaDGasr7ZpW1XvXXiM+/+TZXzC1I
	9uMv4gq8dfHbpHdMhz+d+i3usFa9cA5Pa+Hbpw1z5zKwnlc4vZ3zWsCjAyvNGYN/f2PhOtJ2
	Ntq+rDYmbVL/CpYP5yXV+qbF8e5ZtVm1dPf7u5NbzWys+8Kuf/4yP3S/EktxRqKhFnNRcSIA
	gEIUWB8DAAA=
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


