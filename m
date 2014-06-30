Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaF3MDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:03:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52053 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        Arvind.Chauhan@arm.com, linaro-networking@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/181] tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()
Date: Mon, 30 Jun 2014 13:50:27 +0200
Message-Id: <e54e6e8ec33fa40e0f4eac6efa7ad2eddfaab05c.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 27630532ef5ead28b98cfe28d8f95222ef91c2b7 upstream.

Since commit d689fe222 (NOHZ: Check for nohz active instead of nohz
enabled) the tick_nohz_switch_to_nohz() function returns because it
checks for the tick_nohz_active flag. This can't be set, because the
function itself sets it.

Undo the change in tick_nohz_switch_to_nohz().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Cc: <stable@vger.kernel.org> # 3.13+
Link: http://lkml.kernel.org/r/40939c05f2d65d781b92b20302b02243d0654224.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ea20f7d1ac2c..29b063b32ff0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -970,7 +970,7 @@ static void tick_nohz_switch_to_nohz(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_active)
+	if (!tick_nohz_enabled)
 		return;
 
 	local_irq_disable();
-- 
2.0.0

