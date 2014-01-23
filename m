Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaAWQrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:47:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaAWQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:47:43 -0500
Date: Thu, 23 Jan 2014 08:46:58 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-5e3c1afd4587e70c201bf7224b51f747c9a3dfa8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, peterz@infradead.org,
        bitbucket@online.de, luto@amacapital.net, john.stultz@linaro.org,
        eliezer.tamir@linux.intel.com, markus@trippelsdorf.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        peterz@infradead.org, bitbucket@online.de, john.stultz@linaro.org,
        luto@amacapital.net, eliezer.tamir@linux.intel.com,
        markus@trippelsdorf.de, tglx@linutronix.de
In-Reply-To: <20140123094804.GP30183@twins.programming.kicks-ass.net>
References: <20140123094804.GP30183@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/x86/tsc: Initialize multiplier to 0
Git-Commit-ID: 5e3c1afd4587e70c201bf7224b51f747c9a3dfa8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 08:47:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e3c1afd4587e70c201bf7224b51f747c9a3dfa8
Gitweb:     http://git.kernel.org/tip/5e3c1afd4587e70c201bf7224b51f747c9a3dfa8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 22 Jan 2014 22:08:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 23 Jan 2014 14:48:36 +0100

sched/x86/tsc: Initialize multiplier to 0

Since we keep the clock value linearly continuous on frequency change,
make sure the initial multiplier is 0, such that our initial value is 0.
Without this we compute the initial value at whatever the TSC has
managed to reach since power-on.

Reported-and-Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Fixes: 20d1c86a57762 ("sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs")
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: paulmck@linux.vnet.ibm.com
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: dyoung@redhat.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140123094804.GP30183@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a3acbac..19e5adb 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -180,7 +180,7 @@ static void cyc2ns_write_end(int cpu, struct cyc2ns_data *data)
 
 static void cyc2ns_data_init(struct cyc2ns_data *data)
 {
-	data->cyc2ns_mul = 1U << CYC2NS_SCALE_FACTOR;
+	data->cyc2ns_mul = 0;
 	data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
 	data->cyc2ns_offset = 0;
 	data->__count = 0;
