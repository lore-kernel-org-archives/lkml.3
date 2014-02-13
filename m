Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaBMHOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:14:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22364 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBMHOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:14:39 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-e1-52fc70de5ac9
From: Weijie Yang <weijie.yang@samsung.com>
To: gregkh@linuxfoundation.org
Cc: anton.vorontsov@linaro.org, rientjes@google.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        weijie.yang.kh@gmail.com
Subject: [PATCH] staging: android: lowmemorykiller: set TIF_MEMDIE before send
 kill sig
Date: Thu, 13 Feb 2014 15:13:44 +0800
Message-id: <000001cf288b$41699f40$c43cddc0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8oiyGNCzvygZRKQjKNigmNj8zlvw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd17BX+CDA7cZ7e42HqbxaJ58Xo2
	i8u75rBZtC3ZyGTx5MR/FgdWj52z7rJ7LNhU6nHn2h42j/1z17B7fN4kF8AaxWWTkpqTWZZa
	pG+XwJUx9/1U5oKVHBUTpm5iaWD8xdbFyMkhIWAisfTxNihbTOLCvfVANheHkMAiRokXE46z
	QDh/GCWOLWhmAaliE9CWuNu/kRXEFhGQk3hy+w8ziM0sUCexc+1SsEnCApES29fPBbI5OFgE
	VCVOfI4ECfMK2En8PP2KDcIWlPgx+R4LSAmzgLrElCm5EFPkJTavecsMEpYACj/6qwuxSE9i
	y8xmVogScYmNR26xTGAUmIVk0CyEQbOQDJqFpGMBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOAAfya9g3FVg8UhRgEORiUe3geLfwcJsSaWFVfmHmKU4GBWEuGVkfgTJMSbklhZlVqU
	H19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFxztamituKGdNebezwu5Fs
	8WiqXXh+mUjH3It7Pt1cc2zO0s2r/M7tbXBbybo8frOMWZbBS+fo7tLo3WaC1ZdSGGSCHtyI
	X757bnraab65u8S21y/4fdlD8F/5hzZpEYvleT4SE9ZUqR84XFI95fy0mZ8n/xVy/2GVyX7h
	wNozLw/nibbxKOrOVWIpzkg01GIuKk4EANg7h31sAgAA
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
 mode change 100644 => 100755 drivers/staging/android/lowmemorykiller.c

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
old mode 100644
new mode 100755
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


