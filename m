Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKCLsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:48:43 -0500
Received: from mail-wg0-f74.google.com ([74.125.82.74]:39118 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaKCLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:48:41 -0500
From: David Drysdale <drysdale@google.com>
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        David Drysdale <drysdale@google.com>
Subject: [PATCH man-pages 3/3] open.2: describe O_BENEATH flag
Date: Mon,  3 Nov 2014 11:48:25 +0000
Message-Id: <1415015305-15494-4-git-send-email-drysdale@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415015305-15494-1-git-send-email-drysdale@google.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Drysdale <drysdale@google.com>
---
 man2/open.2 | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/man2/open.2 b/man2/open.2
index abc3c35b8b3a..495c7f1e81a4 100644
--- a/man2/open.2
+++ b/man2/open.2
@@ -716,6 +716,31 @@ XFS support was added
 .\" commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
 in Linux 3.15.
 .TP
+.B O_BENEATH " (since Linux 3.??)"
+Ensure that the
+.I pathname
+is beneath the current working directory (for
+.BR open (2))
+or the
+.I dirfd
+(for
+.BR openat (2)).
+If the
+.I pathname
+is absolute or contains a path component of "..", the
+.BR open ()
+fails with the error
+.BR EACCES.
+This occurs even if ".." path component would not actually
+escape the original directory; for example, a
+.I pathname
+of "subdir/../filename" would be rejected.
+Path components that are symbolic links to absolute paths, or that are
+relative paths containing a ".." component, will also cause the
+.BR open ()
+operation to fail with the error
+.BR EACCES.
+.TP
 .B O_TRUNC
 If the file already exists and is a regular file and the access mode allows
 writing (i.e., is
@@ -792,7 +817,11 @@ The requested access to the file is not allowed, or search permission
 is denied for one of the directories in the path prefix of
 .IR pathname ,
 or the file did not exist yet and write access to the parent directory
-is not allowed.
+is not allowed, or the
+.B O_BENEATH
+flag was specified and the
+.I pathname
+was not beneath the relevant directory.
 (See also
 .BR path_resolution (7).)
 .TP
-- 
2.1.0.rc2.206.gedb03e5

