Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3FDWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:32 -0400
Received: from 1wt.eu ([62.212.114.60]:35472 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3FDWmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:25 -0400
Message-Id: <20130604172131.261346312@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Julien Tinnes <jln@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 023/184] kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 of SA_RESTORER

From: Andrew Morton <akpm@linux-foundation.org>

commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a upstream.

__ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
later kernels, per Kees.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 845de15..fb7e242 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -320,7 +320,7 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
-#ifdef SA_RESTORER
+#ifdef __ARCH_HAS_SA_RESTORER
 		ka->sa.sa_restorer = NULL;
 #endif
 		sigemptyset(&ka->sa.sa_mask);
-- 
1.7.12.2.21.g234cd45.dirty



