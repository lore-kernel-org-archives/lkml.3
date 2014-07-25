Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbaGYNsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:48:39 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:35351 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513AbaGYNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:48:35 -0400
From: David Drysdale <drysdale@google.com>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: [PATCH 6/6] prctl.2: describe PR_SET_OPENAT_BENEATH/PR_GET_OPENAT_BENEATH
Date: Fri, 25 Jul 2014 14:47:13 +0100
Message-Id: <1406296033-32693-18-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 man2/prctl.2 | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/man2/prctl.2 b/man2/prctl.2
index 119989183ed3..f5f71af249f2 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -295,6 +295,41 @@ A value of 1 indicates
 .BR execve (2)
 will operate in the privilege-restricting mode described above.
 .TP
+.BR PR_SET_OPENAT_BENEATH " (since Linux 3.??)"
+Set the calling process's
+.I openat_beneath
+bit to the value in
+.IR arg2 .
+With
+.I openat_beneath
+set to 1, all
+.BR openat (2)
+and
+.BR open (2)
+operations act as though the
+.B O_BENEATH
+flag is set.
+Once set, this bit cannot be unset.
+The setting of this bit is inherited by children created by
+.BR fork (2)
+and
+.BR clone (2),
+and preserved across
+.BR execve (2).
+.TP
+.BR PR_GET_OPENAT_BENEATH " (since Linux 3.??)"
+Return (as the function result) the value of the
+.I openat_beneath
+bit for the current process.
+A value of 0 indicates the regular behavior.
+A value of 1 indicates that
+.BR openat (2)
+and
+.BR open (2)
+will operate in the implicit
+.B O_BENEATH
+mode described above.
+.TP
 .BR PR_SET_PDEATHSIG " (since Linux 2.1.57)"
 Set the parent process death signal
 of the calling process to \fIarg2\fP (either a signal value
-- 
2.0.0.526.g5318336

