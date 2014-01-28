Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaA1TZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:25:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaA1TZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:25:51 -0500
Date: Tue, 28 Jan 2014 11:25:12 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-rcmiqb07nyuhtsnmanxlj3il@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, richard@nod.at,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, richard@nod.at,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86, um: Add generic barrier.h
Git-Commit-ID: 673c36745c9f3100672853840b27e27638435e74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:25:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  673c36745c9f3100672853840b27e27638435e74
Gitweb:     http://git.kernel.org/tip/673c36745c9f3100672853840b27e27638435e74
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 28 Jan 2014 15:12:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 15:27:36 +0100

x86, um: Add generic barrier.h

It appears arch/um doesn't have any asm/barrier.h; cure this by
including the generic one. Since UM is !SMP the defaults are good
enough.

( The motivation are the latest MCS locking patches which use generic
  barriers. )

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/n/tip-rcmiqb07nyuhtsnmanxlj3il@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/um/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index fdde187..fb3a6cc 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += barrier.h
