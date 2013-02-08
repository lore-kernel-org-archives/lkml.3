Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946599Ab3BHPT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:19:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946062Ab3BHPT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:19:58 -0500
Date: Fri, 8 Feb 2013 07:18:56 -0800
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <tip-02fc8d37229d15c654876cf9ce56b5c1cf7945d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linuxppc-dev@lists.ozlabs.org, peterz@infradead.org,
        namhyung.kim@lge.com, zhong@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linuxppc-dev@lists.ozlabs.org,
        namhyung.kim@lge.com, zhong@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        benh@kernel.crashing.org, rostedt@goodmis.org, sfr@canb.auug.org.au,
        tglx@linutronix.de, paul.gortmaker@windriver.com
In-Reply-To: <20130208141938.f31b7b9e1acac5bbe769ee4c@canb.auug.org.au>
References: <20130208141938.f31b7b9e1acac5bbe769ee4c@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cputime:
  Restore CPU_ACCOUNTING config defaults for PPC64
Git-Commit-ID: 02fc8d37229d15c654876cf9ce56b5c1cf7945d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Feb 2013 07:19:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02fc8d37229d15c654876cf9ce56b5c1cf7945d7
Gitweb:     http://git.kernel.org/tip/02fc8d37229d15c654876cf9ce56b5c1cf7945d7
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Fri, 8 Feb 2013 14:19:38 +1100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Feb 2013 15:23:12 +0100

cputime: Restore CPU_ACCOUNTING config defaults for PPC64

Commit abf917cd91cb ("cputime: Generic on-demand virtual cputime
accounting") inadvertantly changed the default CPU_ACCOUNTING
config for PPC64.  Repair that.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20130208141938.f31b7b9e1acac5bbe769ee4c@canb.auug.org.au
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index a05f843..ccb9f8f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -332,7 +332,7 @@ config VIRT_CPU_ACCOUNTING
 choice
 	prompt "Cputime accounting"
 	default TICK_CPU_ACCOUNTING if !PPC64
-	default VIRT_CPU_ACCOUNTING if PPC64
+	default VIRT_CPU_ACCOUNTING_NATIVE if PPC64
 
 # Kind of a stub config for the pure tick based cputime accounting
 config TICK_CPU_ACCOUNTING
