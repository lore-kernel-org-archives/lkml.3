Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaKFPo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:44:57 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:32960 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaKFPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:44:33 -0500
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
Subject: [PATCH v2 2/2] RWF_ODSYNC flag for pwritev2
Date: Thu,  6 Nov 2014 10:44:27 -0500
Message-Id: <ee4674ce06aaabf8bee50b4f0168af8729bc2ef1.1415288353.git.milosz@adfin.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
References: <cover.1415220890.git.milosz@adfin.com>
 <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
In-Reply-To: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
References: <d2cbc4795f774b521e13ac448d07a1156c6aa04d.1415288353.git.milosz@adfin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document RWF_ODSYNC flag for pwritev2 as implemented by Christoph Hellwig.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 man2/readv.2 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/man2/readv.2 b/man2/readv.2
index 31b3870..ff1405c 100644
--- a/man2/readv.2
+++ b/man2/readv.2
@@ -203,6 +203,15 @@ contains a bitwise OR of one or more of the following flags:
 .BR RWF_NONBLOCK " (only " preadv2() " since Linux 3.19)"
 Performs a non-blocking operation for regular files (not sockets) opened in buffered mode (not
 .BR O_DIRECT ")."
+.TP
+.BR RWF_DSYNC " (only " pwritev2() " since Linux 3.19)"
+Write operation will complete according to the requirements of synchronized I/O
+.I data
+integrity completion. This has the same effect on the operation as if the file handle was created by
+.BR open(2)
+with the
+.BR O_DSYNC
+flag.
 
 .SH RETURN VALUE
 On success,
@@ -333,6 +342,7 @@ nwritten = writev(STDOUT_FILENO, iov, 2);
 .fi
 .in
 .SH SEE ALSO
+.BR open(2),
 .BR pread (2),
 .BR read (2),
 .BR write (2)
-- 
1.9.1

