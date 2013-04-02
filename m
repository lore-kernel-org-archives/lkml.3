Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3DBWub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3DBWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Julien Tinnes <jln@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 02/56] kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
Date: Tue,  2 Apr 2013 15:49:29 -0700
Message-Id: <20130402224712.136059762@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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

---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -437,7 +437,7 @@ flush_signal_handlers(struct task_struct
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
-#ifdef SA_RESTORER
+#ifdef __ARCH_HAS_SA_RESTORER
 		ka->sa.sa_restorer = NULL;
 #endif
 		sigemptyset(&ka->sa.sa_mask);


