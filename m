Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934718AbaE2Fil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:38:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaE2Eex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linaro-kernel@lists.linaro.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: [PATCH 3.14 019/140] tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()
Date: Wed, 28 May 2014 21:32:38 -0700
Message-Id: <20140529043051.817462147@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

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
Link: http://lkml.kernel.org/r/40939c05f2d65d781b92b20302b02243d0654224.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -970,7 +970,7 @@ static void tick_nohz_switch_to_nohz(voi
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_active)
+	if (!tick_nohz_enabled)
 		return;
 
 	local_irq_disable();


