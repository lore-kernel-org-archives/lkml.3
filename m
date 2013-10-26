Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3JZNvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3JZNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:31 -0400
Date: Sat, 26 Oct 2013 06:50:56 -0700
From: tip-bot for Raghavendra K T <tipbot@zytor.com>
Message-ID: <tip-4c4e4f61368164f326fe59e2156c70d7faa72c17@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, gleb@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, akpm@linux-foundation.org,
        pbonzini@redhat.com, tglx@linutronix.de, linux@eikelenboom.it
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, gleb@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, akpm@linux-foundation.org,
        pbonzini@redhat.com, linux@eikelenboom.it, tglx@linutronix.de
In-Reply-To: <1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/locking/kconfig:
  Update paravirt spinlock Kconfig description
Git-Commit-ID: 4c4e4f61368164f326fe59e2156c70d7faa72c17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c4e4f61368164f326fe59e2156c70d7faa72c17
Gitweb:     http://git.kernel.org/tip/4c4e4f61368164f326fe59e2156c70d7faa72c17
Author:     Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
AuthorDate: Mon, 21 Oct 2013 21:35:08 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 12:23:22 +0200

x86/locking/kconfig: Update paravirt spinlock Kconfig description

Since the paravirt spinlock optimizations went into the v3.12 kernel
we have a very good performance benefit for paravirtualized KVM / Xen
kernels. Also we no longer suffer from 5% side effect on native
kernel that is mentioned in the Kconfig entry.

So update the Kconfig entry accordingly.

pvspinlock benefit on KVM link:

  https://lkml.org/lkml/2013/8/6/178

Attilio's tests on native kernel impact:

  http://blog.xen.org/index.php/2012/05/11/benchmarking-the-new-pv-ticketlock-implementation/

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: <konrad.wilk@oracle.com>
Cc: <linux@eikelenboom.it>
Cc: <gleb@redhat.com>
Cc: <pbonzini@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1382371508-3843-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com
[ Updated the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..a92572d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -638,10 +638,10 @@ config PARAVIRT_SPINLOCKS
 	  spinlock implementation with something virtualization-friendly
 	  (for example, block the virtual CPU rather than spinning).
 
-	  Unfortunately the downside is an up to 5% performance hit on
-	  native kernels, with various workloads.
+	  It has a minimal impact on native kernels and gives a nice performance
+	  benefit on paravirtualized KVM / Xen kernels.
 
-	  If you are unsure how to answer this question, answer N.
+	  If you are unsure how to answer this question, answer Y.
 
 source "arch/x86/xen/Kconfig"
 
