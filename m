Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3DVJT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:19:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64872 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3DVJT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:19:28 -0400
Message-ID: <51750099.7020107@huawei.com>
Date: Mon, 22 Apr 2013 17:19:21 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] sparc/sysrq: fix inconstistent help message of sysrq
 key
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

This patch fix sparc sysrq key: "global-regs(y)" and "global-pmu(x)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/process_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index cdb80b2..a0705ba 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -315,7 +315,7 @@ static void sysrq_handle_globreg(int key)

 static struct sysrq_key_op sparc_globalreg_op = {
 	.handler	= sysrq_handle_globreg,
-	.help_msg	= "global-regs(Y)",
+	.help_msg	= "global-regs(y)",
 	.action_msg	= "Show Global CPU Regs",
 };

@@ -385,7 +385,7 @@ static void sysrq_handle_globpmu(int key)

 static struct sysrq_key_op sparc_globalpmu_op = {
 	.handler	= sysrq_handle_globpmu,
-	.help_msg	= "global-pmu(X)",
+	.help_msg	= "global-pmu(x)",
 	.action_msg	= "Show Global PMU Regs",
 };

-- 
1.7.9.7


