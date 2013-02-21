Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3BUKOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:14:10 -0500
Received: from smtp-out-108.synserver.de ([212.40.185.108]:1115 "EHLO
	smtp-out-106.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751624Ab3BUKOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:14:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11889
From: Lars-Peter Clausen <lars@metafoo.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] microblaze idle: Fix compile error
Date: Thu, 21 Feb 2013 11:15:31 +0100
Message-Id: <1361441731-19900-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <fe98b401efe3034c1684b8625ac266601c3b4ad1.1360475150.git.len.brown@intel.com>
References: <fe98b401efe3034c1684b8625ac266601c3b4ad1.1360475150.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit def8203 ("microblaze idle: delete pm_idle") introduced the following
compile error:

	arch/microblaze/kernel/process.c: In function 'cpu_idle':
	arch/microblaze/kernel/process.c:100: error: 'idle' undeclared (first use in this function)
	arch/microblaze/kernel/process.c:100: error: (Each undeclared identifier is reported only once
	arch/microblaze/kernel/process.c:100: error: for each function it appears in.)
	arch/microblaze/kernel/process.c:106: error: implicit declaration of function 'idle'

This patch fixes it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/microblaze/kernel/process.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 6ff2dcf..08f8734 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -97,13 +97,10 @@ void cpu_idle(void)
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		if (!idle)
-			idle = default_idle;
-
 		tick_nohz_idle_enter();
 		rcu_idle_enter();
 		while (!need_resched())
-			idle();
+			default_idle();
 		rcu_idle_exit();
 		tick_nohz_idle_exit();
 
-- 
1.8.0

