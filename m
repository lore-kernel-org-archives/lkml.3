Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab3JOTcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:32:52 -0400
Received: from sauhun.de ([89.238.76.85]:36428 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab3JOTcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:32:04 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC RESEND 3/3] sched: remove INIT_COMPLETION
Date: Tue, 15 Oct 2013 21:31:20 +0200
Message-Id: <1381865480-3013-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381865480-3013-1-git-send-email-wsa@the-dreams.de>
References: <1381865480-3013-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users are converted over to reinit_completion(). Remove the old
macro now.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

This patch is mainly here for build testing (to spot missed conversions). I am
fine with applying this some cycles later than the rest.

 include/linux/completion.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 2195e32..2d309b9 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -106,14 +106,4 @@ extern bool completion_done(struct completion *x);
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
 
-/**
- * INIT_COMPLETION - reinitialize a completion structure
- * @x:  completion structure to be reinitialized
- *
- * This macro should be used to reinitialize a completion structure so it can
- * be reused. This is especially important after complete_all() is used.
- */
-#define INIT_COMPLETION(x)	((x).done = 0)
-
-
 #endif
-- 
1.8.4.rc3

