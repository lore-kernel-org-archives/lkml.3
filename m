Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3APRJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:09:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35763 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab3APP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 030/222] ftrace: Clear bits properly in reset_iter_read()
Date: Wed, 16 Jan 2013 13:53:50 -0200
Message-Id: <1358351822-7675-31-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 70f77b3f7ec010ff9624c1f2e39a81babc9e2429 upstream.

There is a typo here where '&' is used instead of '|' and it turns the
statement into a noop.  The original code is equivalent to:

	iter->flags &= ~((1 << 2) & (1 << 4));

Link: http://lkml.kernel.org/r/20120609161027.GD6488@elgon.mountain

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a008663..97da2dc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2358,7 +2358,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
 {
 	iter->pos = 0;
 	iter->func_pos = 0;
-	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
+	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
-- 
1.7.9.5

