Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3AXUM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:12:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab3AXUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:58 -0500
Date: Thu, 24 Jan 2013 12:08:38 -0800
From: tip-bot for Cong Ding <dinggnu@gmail.com>
Message-ID: <tip-b9975dabe3f0a6e4d1af52c47f66b5558df207a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, dinggnu@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, dinggnu@gmail.com, tglx@linutronix.de
In-Reply-To: <1358199561-15518-1-git-send-email-dinggnu@gmail.com>
References: <1358199561-15518-1-git-send-email-dinggnu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/apb/timer: Remove unnecessary "if"
Git-Commit-ID: b9975dabe3f0a6e4d1af52c47f66b5558df207a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:08:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9975dabe3f0a6e4d1af52c47f66b5558df207a3
Gitweb:     http://git.kernel.org/tip/b9975dabe3f0a6e4d1af52c47f66b5558df207a3
Author:     Cong Ding <dinggnu@gmail.com>
AuthorDate: Mon, 14 Jan 2013 22:39:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 13:03:26 +0100

x86/apb/timer: Remove unnecessary "if"

adev has no chance to be NULL, so we don't need to check it. It
is also dereferenced just before the check .

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/r/1358199561-15518-1-git-send-email-dinggnu@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apb_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index afdc3f75..cf92735 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -240,7 +240,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 		dw_apb_clockevent_pause(adev->timer);
 		if (system_state == SYSTEM_RUNNING) {
 			pr_debug("skipping APBT CPU %lu offline\n", cpu);
-		} else if (adev) {
+		} else {
 			pr_debug("APBT clockevent for cpu %lu offline\n", cpu);
 			dw_apb_clockevent_stop(adev->timer);
 		}
