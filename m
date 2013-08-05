Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3HEMVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:21:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3HEMVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:21:17 -0400
Date: Mon, 5 Aug 2013 14:21:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nohz: put proper symbol in the unstable schedclock warning
Message-ID: <alpine.LNX.2.00.1308051420290.17512@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since e12d0271 ("nohz: Warn if the machine can not perform nohz_full") 
Kernel triggers a WARN() in case sched clock is marked as unstable.

Make it output a proper Kconfig symbol (NO_HZ_FULL) when informing user 
about this.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e77edc9..e0030ed 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,7 +182,7 @@ static bool can_stop_full_tick(void)
 		 * Don't allow the user to think they can get
 		 * full NO_HZ with this machine.
 		 */
-		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
+		WARN_ONCE(1, "NO_HZ_FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif

-- 
Jiri Kosina
SUSE Labs
