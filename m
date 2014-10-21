Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbaJUUW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:22:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48669 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160AbaJUUWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:22:25 -0400
Date: Tue, 21 Oct 2014 13:21:37 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] sysctl: terminate strings also on \r
Message-ID: <20141021202137.GA20114@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Wise <pabs3@bonedaddy.net>

This partially mitigates a common strategy used by attackers for hiding
the full contents of strings in procfs from naive sysadmins who use cat,
more or sysctl to inspect the contents of strings in procfs.

References: http://www.jakoblell.com/blog/2014/05/07/hacking-contest-hiding-stuff-from-the-terminal/
Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4aada6d9fe74..c34c9414caac 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, int maxlen, int write,
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
-			if (c == 0 || c == '\n')
+			if (c == 0 || c == '\n' || c == '\r')
 				break;
 			data[len++] = c;
 		}
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
