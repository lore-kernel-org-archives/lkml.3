Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaEVRpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:45:34 -0400
Received: from mout.gmx.net ([212.227.17.21]:63991 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaEVRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:45:33 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: mingo@redhat.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] sched: Use time_after()
Date: Thu, 22 May 2014 19:45:23 +0200
Message-Id: <1400780723-24626-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:MPVEid7BUFO3QUB/WuY/JK9eJTwtm5cGEUFIpJCIYxG/n3+LVT/
 kMmrCIMbQfu1qKUMK56WOe+qojTEy62u1OHQVPZNCiCAH/0Yxx1e3/26BTPXLgubUSbKr1o
 XQ2ZhXsJ48iuMR59jT8N8VafhIlEkFhz4T4bpjZZv5XL6kJpWZM6rYwnujtpgLLlrLL9aDE
 sKJbcLtd2bO/NIxbvg2xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..716360a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4014,7 +4014,7 @@ static void record_wakee(struct task_struct *p)
 	 * about the boundary, really active task won't care
 	 * about the loss.
 	 */
-	if (jiffies > current->wakee_flip_decay_ts + HZ) {
+	if (time_after(jiffies, current->wakee_flip_decay_ts + HZ)) {
 		current->wakee_flips = 0;
 		current->wakee_flip_decay_ts = jiffies;
 	}
-- 
1.7.10.4

