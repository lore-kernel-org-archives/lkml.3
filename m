Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3CGJA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:28 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:24571 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab3CGJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:27 -0500
Message-ID: <51385720.5080905@huawei.com>
Date: Thu, 7 Mar 2013 17:00:16 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/8] power/sysrq: fix inconstistent help message of sysrq
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

This patch fix power off sysrq key: "poweroff(o)"

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/power/poweroff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/poweroff.c b/kernel/power/poweroff.c
index 68197a4..7ef6866 100644
--- a/kernel/power/poweroff.c
+++ b/kernel/power/poweroff.c
@@ -32,7 +32,7 @@ static void handle_poweroff(int key)

 static struct sysrq_key_op	sysrq_poweroff_op = {
 	.handler        = handle_poweroff,
-	.help_msg       = "powerOff",
+	.help_msg       = "poweroff(o)",
 	.action_msg     = "Power Off",
 	.enable_mask	= SYSRQ_ENABLE_BOOT,
 };
-- 
1.7.9.7


