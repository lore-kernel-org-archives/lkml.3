Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3ANVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 16:39:34 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:33959 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab3ANVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 16:39:33 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] x86: kernel/apb_timer.c: remove unnecessary "if"
Date: Mon, 14 Jan 2013 22:39:18 +0100
Message-Id: <1358199561-15518-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adev has no chance to be NULL, so we don't need to check it. it is also used
before the check in line 241.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index cc74fd0..c9876ef 100644
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
-- 
1.7.9.5

