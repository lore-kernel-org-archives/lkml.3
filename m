Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3EJVSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:18:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3EJVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:18:27 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=77IXKi44_PcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7bIx3mQ5MGgA:10 a=StauahnKPwVgDX_dECsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130510211225.594959788@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 17:12:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3] nohz: Some fixes and updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

Can you take these patches. The first patch will need to get an
ack by one of the x86 maintainers. That one adds a new schedule_preempt_user()
that is called before going back to user space in order to safely
switch from user_context before calling schedule.

The second patch prevents LOCKUP_DETECTION from being selected if
NO_HZ_FULL is. That's because if LOCKUP_DETECTION is selected, it will
prevent NO_HZ_FULL from functioning. I first thought about having
NO_HZ_FULL depend on LOCKUP_DETECTION, but it would hide the feature.
As NO_HZ_FULL is a feature and LOCKUP_DETECTION is debugging, I
have precedence to the feature.

The last patch produces a warning if nohz_full is used or NO_HZ_FULL_ALL
is defined, and the system fails to go into nohz_full mode because
the machine's clock is unstable. We don't want users thinking they
have nohz_full but their machine can't handle it.

-- Steve

---
 arch/x86/include/asm/context_tracking.h |   10 ---------
 b/arch/x86/kernel/entry_64.S            |   26 +++++--------------------
 b/kernel/sched/core.c                   |   33 +++++++++++++++++---------------
 b/kernel/time/tick-sched.c              |    5 ++++
 b/lib/Kconfig.debug                     |    2 +
 5 files changed, 31 insertions(+), 45 deletions(-)

