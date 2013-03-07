Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3CGJAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:32 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61081 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab3CGJAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:30 -0500
Message-ID: <51385727.3080206@huawei.com>
Date: Thu, 7 Mar 2013 17:00:23 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 4/8] ARM/etm/sysrq: fix inconstistent help message of sysrq
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

This patch fix arm etm sysrq key: "etm buffer dump(v)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/etm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 9b6de8c..e2dad6f 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -254,7 +254,7 @@ static void sysrq_etm_dump(int key)

 static struct sysrq_key_op sysrq_etm_op = {
 	.handler = sysrq_etm_dump,
-	.help_msg = "ETM buffer dump",
+	.help_msg = "etm buffer dump(v)",
 	.action_msg = "etm",
 };

-- 
1.7.9.7


