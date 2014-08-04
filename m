Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaHDVCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:02:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29667 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaHDVCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:02:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: gilad@benyossef.com
Cc: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kernel: smp: correct warning in on_each_cpu_cond
Date: Mon,  4 Aug 2014 17:02:23 -0400
Message-Id: <1407186143-28092-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_call_function_single() returns 0 on success, not the other
way around. Fix the warning to trigger on failure rather than
success.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 487653b..aff8aa1 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -670,7 +670,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 			if (cond_func(cpu, info)) {
 				ret = smp_call_function_single(cpu, func,
 								info, wait);
-				WARN_ON_ONCE(!ret);
+				WARN_ON_ONCE(ret);
 			}
 		preempt_enable();
 	}
-- 
1.7.10.4

