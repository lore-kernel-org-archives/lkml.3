Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbaIOWTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51221 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281AbaIOWTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@gentwo.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Tejun Heo <htejun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 169/187] kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path
Date: Mon, 15 Sep 2014 15:09:39 -0700
Message-Id: <1410818997-9432-170-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 618fde872163e782183ce574c77f1123e2be8887 upstream.

The rarely-executed memry-allocation-failed callback path generates a
WARN_ON_ONCE() when smp_call_function_single() succeeds.  Presumably
it's supposed to warn on failures.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index bd9f940..cc2bbf7 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -657,7 +657,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 			if (cond_func(cpu, info)) {
 				ret = smp_call_function_single(cpu, func,
 								info, wait);
-				WARN_ON_ONCE(!ret);
+				WARN_ON_ONCE(ret);
 			}
 		preempt_enable();
 	}
-- 
1.9.1

