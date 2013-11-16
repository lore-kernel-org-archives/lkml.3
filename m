Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3KPRjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:39:51 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51833 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3KPRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:35 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 1/5] kstrtox: remove redundant cleanup
Date: Sat, 16 Nov 2013 11:32:27 -0600
Message-Id: <1384623151-31302-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't reach the cleanup code unless the flag KSTRTOX_OVERFLOW is not
set, so there's not no point in clearing a bit that we know is not set.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 lib/kstrtox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index f78ae0c..ec8da78 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -92,7 +92,6 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 	rv = _parse_integer(s, base, &_res);
 	if (rv & KSTRTOX_OVERFLOW)
 		return -ERANGE;
-	rv &= ~KSTRTOX_OVERFLOW;
 	if (rv == 0)
 		return -EINVAL;
 	s += rv;
-- 
1.8.4.2+fc1

