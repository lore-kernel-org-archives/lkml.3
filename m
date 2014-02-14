Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaBNGFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:05:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27746 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaBNGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:05:03 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-84-52fdb20cbe85
From: Weijie Yang <weijie.yang@samsung.com>
To: gregkh@linuxfoundation.org
Cc: anton.vorontsov@linaro.org, rientjes@google.com, weijie.yang.kh@gmail.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] staging: android: lowmemorykiller: set TIF_MEMDIE
 before send kill sig
Date: Fri, 14 Feb 2014 14:03:56 +0800
Message-id: <000001cf294a$b1bebd60$153c3820$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8pSot/olrst5TiS7mdfP2z2YbGbQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQV2eTX+DDFbvVbS42HqbxaJ58Xo2
	i8u75rBZtC3ZyGTx5MR/FgdWj52z7rJ7LNhU6nHn2h42j/1z17B7fN4kF8AaxWWTkpqTWZZa
	pG+XwJWxaHsbS8E+9op9G9+wNTDOZ+ti5OSQEDCR6P2/khXCFpO4cG89UJyLQ0hgOqPEjb+v
	oJw/jBK3P29kAaliE9CWuNu/EaxDREBO4sntP8wgNrNAnUTLxJVANRwcwgIJEofOR4CEWQRU
	JTYdmMMOYvMK2EmcWzCVCcIWlPgx+R4LRKu6xKR5i6DGyEtsXvOWGWSMBFD80V9diE16Etdm
	vGGEKBGX2HjkFssERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHOTPpHYwrmywOMQowMGoxMPr8eBPkBBrYllxZe4hRgkOZiURXqa0v0FCvCmJlVWpRfnx
	RaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGFNuGl5KYNkm5Ll9R4XYrFsn
	618YRVftXLPbb/ZVr/wpWxIii85ltdar780u8lWY8Ddyy7VL3+OXsYXfVS7+czJyUdkpl4Zj
	u66sZ09aIL3F88G9m3Z/s8NqNz9cnFP6wKSyXu3JxhmThW7xFRjvUj206enTeVtyJigumT3L
	6Pel3SfnygdIPt2kxFKckWioxVxUnAgAFRcE9W4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set TIF_MEMDIE tsk_thread flag before send kill signal to the
selected thread. This is to fit a usual code sequence and avoid
potential race issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/staging/android/lowmemorykiller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 6f094b3..4bcf00a
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -159,8 +159,8 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 			     selected->pid, selected->comm,
 			     selected_oom_score_adj, selected_tasksize);
 		lowmem_deathpending_timeout = jiffies + HZ;
-		send_sig(SIGKILL, selected, 0);
 		set_tsk_thread_flag(selected, TIF_MEMDIE);
+		send_sig(SIGKILL, selected, 0);
 		rem += selected_tasksize;
 	}
 
-- 
1.7.10.4


