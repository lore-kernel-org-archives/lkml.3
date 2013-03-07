Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab3CGJBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:01:25 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61255 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3CGJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:41 -0500
Message-ID: <51385730.7020606@huawei.com>
Date: Thu, 7 Mar 2013 17:00:32 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6/8] spare/sysrq: fix inconstistent help message of sysrq
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

This patch fix spare sysrq key: "global-regs(y)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
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


