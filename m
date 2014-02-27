Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaB0MAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:00:06 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48607 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaB0MAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:00:04 -0500
Date: Thu, 27 Feb 2014 17:27:49 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: [PATCH 23/46] kernel: Mark function as static in trace/ftrace.c
Message-ID: <c61532a82efacf805f173a30d53d81bbd09d8dfd.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in kernel/trace/ftrace.c because it is not used
outside this file.

Thin eliminates the following warning in kernel/trace/ftrace.c:
kernel/trace/ftrace.c:717:5: warning: no previous prototype for ‘ftrace_profile_pages_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d..d110d8a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -714,7 +714,7 @@ static void ftrace_profile_reset(struct ftrace_profile_stat *stat)
 	       FTRACE_PROFILE_HASH_SIZE * sizeof(struct hlist_head));
 }
 
-int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
+static int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 {
 	struct ftrace_profile_page *pg;
 	int functions;
-- 
1.7.9.5

