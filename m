Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab3KFLU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:55 -0500
Date: Wed, 6 Nov 2013 03:20:39 -0800
From: tip-bot for Josh Boyer <tipbot@zytor.com>
Message-ID: <tip-b53b5eda8194214928c8243d711a75dbf51809fc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, rja@sgi.com, jwboyer@fedoraproject.org,
        jwboyer@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rja@sgi.com, jwboyer@fedoraproject.org,
        jwboyer@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20131105143816.GK9944@hansolo.jdub.homelinux.org>
References: <20131105143816.GK9944@hansolo.jdub.homelinux.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpu: Increase max CPU count to 8192
Git-Commit-ID: b53b5eda8194214928c8243d711a75dbf51809fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b53b5eda8194214928c8243d711a75dbf51809fc
Gitweb:     http://git.kernel.org/tip/b53b5eda8194214928c8243d711a75dbf51809fc
Author:     Josh Boyer <jwboyer@redhat.com>
AuthorDate: Tue, 5 Nov 2013 09:38:16 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 08:16:34 +0100

x86/cpu: Increase max CPU count to 8192

The MAXSMP option is intended to enable silly large numbers of
CPUs for testing purposes.  The current value of 4096 isn't very
silly any longer as there are actual SGI machines that approach
6096 CPUs when taking HT into account.

Increase the value to a nice round 8192 to account for this and
allow for short term future increases.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: prarit@redhat.com
Cc: Russ Anderson <rja@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131105143816.GK9944@hansolo.jdub.homelinux.org
[ Tweaked it so that MAXSMP simply sets the maximum of the normal range. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f03e428..805469a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -826,9 +826,9 @@ config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
-	range 2 4096 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
+	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
-	default "4096" if MAXSMP
+	default "8192" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
 	default "8" if SMP
 	---help---
