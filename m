Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaBLHKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:10:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaBLHK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:10:29 -0500
Date: Tue, 11 Feb 2014 23:09:33 -0800
From: tip-bot for Preeti U Murthy <tipbot@zytor.com>
Message-ID: <tip-3f67d962c64d9b6de9dab81bdbe6d5c94c80d9b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <52FAFD2D.2090306@linux.vnet.ibm.com>
References: <52FAFD2D.2090306@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpuidle/pseries:
  Fix fallout caused due to cleanup in pseries cpuidle backend driver
Git-Commit-ID: 3f67d962c64d9b6de9dab81bdbe6d5c94c80d9b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 23:09:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f67d962c64d9b6de9dab81bdbe6d5c94c80d9b9
Gitweb:     http://git.kernel.org/tip/3f67d962c64d9b6de9dab81bdbe6d5c94c80d9b9
Author:     Preeti U Murthy <preeti@linux.vnet.ibm.com>
AuthorDate: Wed, 12 Feb 2014 10:18:45 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Feb 2014 08:05:03 +0100

cpuidle/pseries: Fix fallout caused due to cleanup in pseries cpuidle backend driver

Commit d8c6ad3184ca651 ("sched/idle, PPC: Remove redundant
cpuidle_idle_call()") reintroduced ppc64_runlatch_off/on() in the
pseries cpuidle backend driver. Hence the cleanup caused by the
commit "c0c4301c54adde05:pseries/cpuidle: Remove redundant call
to ppc64_runlatch_off() in cpu idle routines"  in conjuction
with the commit d8c6ad3184ca651 causes a build failure.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/52FAFD2D.2090306@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/cpuidle-pseries.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index d486489..6f7b019 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -17,6 +17,7 @@
 #include <asm/reg.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
+#include <asm/runlatch.h>
 #include <asm/plpar_wrappers.h>
 
 struct cpuidle_driver pseries_idle_driver = {
