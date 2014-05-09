Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbaEIOyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:54:35 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33408 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaEIOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:54:31 -0400
Message-ID: <536CEC24.9080201@gmail.com>
Date: Fri, 09 May 2014 16:54:28 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] sched: Simplify return logic in sched_copy_attr()
References: <536CEAEE.4010609@gmail.com>
In-Reply-To: <536CEAEE.4010609@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

The logic in this function is a little contorted:
* Rather than having chained gotos for the -EFBIG case, just
  return -EFBIG directly.
* Now, the label 'out' is no longer needed, and 'ret' must be zero
  zero by the time we fall through to this point, so just return 0.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
---
 kernel/sched/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6c9ce28..8fa3e12 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3596,13 +3596,11 @@ static int sched_copy_attr(struct sched_attr __user *uattr,
 	 */
 	attr->sched_nice = clamp(attr->sched_nice, MIN_NICE, MAX_NICE);
 
-out:
-	return ret;
+	return 0;
 
 err_size:
 	put_user(sizeof(*attr), &uattr->size);
-	ret = -E2BIG;
-	goto out;
+	return -E2BIG;
 }
 
 /**
-- 
1.9.0


