Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaCYQiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaCYQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:37:59 -0400
Date: Tue, 25 Mar 2014 09:37:38 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b712c8dae05931a76b6c17a4254f403798e6caef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <20140323141940.034005322@linutronix.de>
References: <20140323141940.034005322@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: hpet:
  Use proper destructor for delayed work
Git-Commit-ID: b712c8dae05931a76b6c17a4254f403798e6caef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b712c8dae05931a76b6c17a4254f403798e6caef
Gitweb:     http://git.kernel.org/tip/b712c8dae05931a76b6c17a4254f403798e6caef
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Mar 2014 14:20:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Mar 2014 17:34:01 +0100

x86: hpet: Use proper destructor for delayed work

destroy_timer_on_stack() is hardly the right thing for a delayed
work. We leak a tracking object for the work itself when DEBUG_OBJECTS
is enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140323141940.034005322@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index da85a8e..b91abfd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -699,7 +699,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
 		wait_for_completion(&work.complete);
-		destroy_timer_on_stack(&work.work.timer);
+		destroy_delayed_work_on_stack(&work.work);
 		break;
 	case CPU_DEAD:
 		if (hdev) {
