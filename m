Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3KMDwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:52:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3KMDwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:52:01 -0500
Date: Tue, 12 Nov 2013 19:51:33 -0800
From: tip-bot for Josh Boyer <tipbot@zytor.com>
Message-ID: <tip-9dd1220114e00d8ec5cdc20085bbe198b21e1985@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        rusty@rustcorp.com.au, jwboyer@fedoraproject.org, jwboyer@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jwboyer@fedoraproject.org,
        akpm@linux-foundation.org, jwboyer@redhat.com, tglx@linutronix.de
In-Reply-To: <20131111140815.GB20328@hansolo.jdub.homelinux.org>
References: <20131111140815.GB20328@hansolo.jdub.homelinux.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=
 y usable without debug dependency
Git-Commit-ID: 9dd1220114e00d8ec5cdc20085bbe198b21e1985
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 19:51:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9dd1220114e00d8ec5cdc20085bbe198b21e1985
Gitweb:     http://git.kernel.org/tip/9dd1220114e00d8ec5cdc20085bbe198b21e1985
Author:     Josh Boyer <jwboyer@redhat.com>
AuthorDate: Mon, 11 Nov 2013 09:08:15 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 00:45:50 +0100

smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency

When CONFIG_CPUMASK_OFFSTACK was added in 2008, it was dependent upon
CONFIG_DEBUG_PER_CPU_MAPS being enabled, or an architecture could
select it.

The debug dependency adds additional overhead that isn't required
for operation of the feature and which is undesirable for distro
kernels. CONFIG_CPUMASK_OFFSTACK=y is needed to increase the
CONFIG_NR_CPUS value beyond 512 on x86.

So drop the current dependency, its only real dependency is CONFIG_SMP=y.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20131111140815.GB20328@hansolo.jdub.homelinux.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index b3c8be0..50b47cd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,7 +342,8 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	bool "Force CPU masks off stack"
+	depends on SMP
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
