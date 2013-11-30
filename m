Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3K3O1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:27:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3K3O1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:27:52 -0500
Date: Sat, 30 Nov 2013 06:27:23 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-962d9c5757b2ebd30678a88a4f475ae997f4d5dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, jwboyer@fedoraproject.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jwboyer@fedoraproject.org,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Revert "smp/cpumask:
  Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency"
Git-Commit-ID: 962d9c5757b2ebd30678a88a4f475ae997f4d5dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 06:27:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  962d9c5757b2ebd30678a88a4f475ae997f4d5dd
Gitweb:     http://git.kernel.org/tip/962d9c5757b2ebd30678a88a4f475ae997f4d5dd
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 30 Nov 2013 15:20:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 30 Nov 2013 15:20:15 +0100

Revert "smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency"

This reverts commit 9dd1220114e00d8ec5cdc20085bbe198b21e1985.

Revert it until Linus's concerns are addressed: this option should not
allow nonsensical CONFIG_CPUMASK_OFFSTACK and CONFIG_NR_CPUS values, and
it should probably select sane defaults as well.

Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-etcruvuw9neycYf0Rripxrjv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 3f7fb4d..06dc742 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,8 +342,7 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack"
-	depends on SMP
+	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
