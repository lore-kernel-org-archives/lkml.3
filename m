Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3BXMXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:23:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab3BXMXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:23:21 -0500
Date: Sun, 24 Feb 2013 04:21:48 -0800
From: tip-bot for Li Zhong <tipbot@zytor.com>
Message-ID: <tip-c78a4bcd1a879b39fb7646c887b0c195f1018909@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, khilman@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, khilman@linaro.org
In-Reply-To: <1361636925-22288-2-git-send-email-fweisbec@gmail.com>
References: <1361636925-22288-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] cputime: Constify timeval_to_cputime(timeval)
  argument
Git-Commit-ID: c78a4bcd1a879b39fb7646c887b0c195f1018909
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 24 Feb 2013 04:21:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c78a4bcd1a879b39fb7646c887b0c195f1018909
Gitweb:     http://git.kernel.org/tip/c78a4bcd1a879b39fb7646c887b0c195f1018909
Author:     Li Zhong <zhong@linux.vnet.ibm.com>
AuthorDate: Sat, 23 Feb 2013 17:28:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 24 Feb 2013 12:57:15 +0100

cputime: Constify timeval_to_cputime(timeval) argument

Saw the following compiler warning on the linux-next tree:

  kernel/itimer.c: In function 'set_cpu_itimer':
  kernel/itimer.c:152:2: warning: passing argument 1 of 'timeval_to_cputime' discards 'const' qualifier from pointer target type [enabled by default]
  ...

timeval_to_cputime() is always passed a constant timeval in
argument, we need to teach the nsecs based cputime
implementation about that.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kevin Hilman <khilman@linaro.org>
Link: http://lkml.kernel.org/r/1361636925-22288-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 include/asm-generic/cputime_nsecs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index b6485ca..a8ece9a 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -76,7 +76,7 @@ static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 /*
  * Convert cputime <-> timeval (msec)
  */
-static inline cputime_t timeval_to_cputime(struct timeval *val)
+static inline cputime_t timeval_to_cputime(const struct timeval *val)
 {
 	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
 	return (__force cputime_t) ret;
