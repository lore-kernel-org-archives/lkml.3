Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3I1R6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:58:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3I1R6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:58:11 -0400
Date: Sat, 28 Sep 2013 10:57:48 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8a3da6c7d0031fcb6a0d17f9c7a68b0e01f52855@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Fix PMU detection printout when no PMU is detected
Git-Commit-ID: 8a3da6c7d0031fcb6a0d17f9c7a68b0e01f52855
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 28 Sep 2013 10:57:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a3da6c7d0031fcb6a0d17f9c7a68b0e01f52855
Gitweb:     http://git.kernel.org/tip/8a3da6c7d0031fcb6a0d17f9c7a68b0e01f52855
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 28 Sep 2013 15:48:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 28 Sep 2013 15:48:48 +0200

perf/x86: Fix PMU detection printout when no PMU is detected

Ran into this cryptic PMU bootup log recently:

[    0.124047] Performance Events:
[    0.125000] smpboot: ...

Turns out we print this if no PMU is detected. Fall back to
the right condition so that the following is printed:

[    0.122381] Performance Events: no PMU driver, software events only.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-u2fwaUffakjp0qkpRfqljgsn@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a9c606b..897783b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1506,7 +1506,7 @@ static int __init init_hw_perf_events(void)
 		err = amd_pmu_init();
 		break;
 	default:
-		return 0;
+		err = -ENOTSUPP;
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
