Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3CGJAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24538 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3CGJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:24 -0500
Message-ID: <5138571A.10204@huawei.com>
Date: Thu, 7 Mar 2013 17:00:10 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/8] kgdb/sysrq: fix inconstistent help message of sysrq key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This patch fix kgdb sysrq key: "debug(g)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index c26278f..0506d44 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -775,7 +775,7 @@ static void sysrq_handle_dbg(int key)

 static struct sysrq_key_op sysrq_dbg_op = {
 	.handler	= sysrq_handle_dbg,
-	.help_msg	= "debug(G)",
+	.help_msg	= "debug(g)",
 	.action_msg	= "DEBUG",
 };
 #endif
-- 
1.7.9.7


