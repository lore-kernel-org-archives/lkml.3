Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbATJ7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:59:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbATJ7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:59:50 -0500
From: Fam Zheng <famz@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        David Drysdale <drysdale@google.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Fam Zheng <famz@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH RFC 3/6] epoll: Add definition for epoll_mod_wait structures
Date: Tue, 20 Jan 2015 17:57:55 +0800
Message-Id: <1421747878-30744-4-git-send-email-famz@redhat.com>
In-Reply-To: <1421747878-30744-1-git-send-email-famz@redhat.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two structs involved in the coming syscall is defined. Flags in epoll_mod_cmd
are reserved, which makes better word alignment and may allow future extension.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/uapi/linux/eventpoll.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..e32a804 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -18,6 +18,8 @@
 #include <linux/fcntl.h>
 #include <linux/types.h>
 
+#include <linux/signal.h>
+
 /* Flags for epoll_create1.  */
 #define EPOLL_CLOEXEC O_CLOEXEC
 
@@ -61,6 +63,24 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
+struct epoll_mod_cmd {
+	int flags;
+	int op;
+	int fd;
+	__u32 events;
+	__u64 data;
+	int error;
+} EPOLL_PACKED;
+
+struct epoll_wait_spec {
+	int maxevents;
+	struct epoll_event *events;
+	int clockid;
+	struct timespec timeout;
+	sigset_t *sigmask;
+	size_t sigsetsize;
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
-- 
1.9.3

