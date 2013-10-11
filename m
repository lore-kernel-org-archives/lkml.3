Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3JKBgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:36:23 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:46832 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3JKBgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:36:21 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Felipe Pena <felipensp@gmail.com>
Subject: [PATCH 1/1] tools/testing/selftests: Fix uninitialized variable
Date: Thu, 10 Oct 2013 22:36:30 -0300
Message-Id: <1381455390-4303-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The err variable is intended to receive the timer_create() return before
checking it

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 tools/testing/selftests/timers/posix_timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 4fa655d..41bd855 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -151,7 +151,7 @@ static int check_timer_create(int which)
 	fflush(stdout);
 
 	done = 0;
-	timer_create(which, NULL, &id);
+	err = timer_create(which, NULL, &id);
 	if (err < 0) {
 		perror("Can't create timer\n");
 		return -1;
-- 
1.7.10.4

