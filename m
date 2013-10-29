Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3J2SKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:10:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3J2SJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 22/81] vfs: allow O_PATH file descriptors for fstatfs()
Date: Tue, 29 Oct 2013 11:03:43 -0700
Message-Id: <1383069882-11437-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9d05746e7b16d8565dddbe3200faa1e669d23bbf upstream.

Olga reported that file descriptors opened with O_PATH do not work with
fstatfs(), found during further development of ksh93's thread support.

There is no reason to not allow O_PATH file descriptors here (fstatfs is
very much a path operation), so use "fdget_raw()".  See commit
55815f70147d ("vfs: make O_PATH file descriptors usable for 'fstat()'")
for a very similar issue reported for fstat() by the same team.

Reported-and-tested-by: ольга крыжановская <olga.kryzhanovska@gmail.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/statfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index c219e733..083dc0a 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -94,7 +94,7 @@ retry:
 
 int fd_statfs(int fd, struct kstatfs *st)
 {
-	struct fd f = fdget(fd);
+	struct fd f = fdget_raw(fd);
 	int error = -EBADF;
 	if (f.file) {
 		error = vfs_statfs(&f.file->f_path, st);
-- 
1.8.1.2

