Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbaEIOyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:54:41 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:39492 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaEIOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:54:37 -0400
Message-ID: <536CEC29.9090503@gmail.com>
Date: Fri, 09 May 2014 16:54:33 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/3] sched: Simplify return logic in sched_read_attr()
References: <536CEAEE.4010609@gmail.com>
In-Reply-To: <536CEAEE.4010609@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

Gotos are chained pointlessly here, and the 'out' label
can be dispensed with.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
---
 kernel/sched/core.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8fa3e12..d21c070 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3759,7 +3759,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 
 		for (; addr < end; addr++) {
 			if (*addr)
-				goto err_size;
+				return -EFBIG;
 		}
 
 		attr->size = usize;
@@ -3769,12 +3769,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-out:
-	return ret;
-
-err_size:
-	ret = -E2BIG;
-	goto out;
+	return 0;
 }
 
 /**
-- 
1.9.0

