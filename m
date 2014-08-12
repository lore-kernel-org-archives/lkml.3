Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaHLOs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:48:28 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39182 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaHLOs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:48:26 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: [PATCH 5/5] locks: update Locking documentation to clarify fl_release_private behavior
Date: Tue, 12 Aug 2014 10:48:13 -0400
Message-Id: <1407854893-2698-6-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
References: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 Documentation/filesystems/Locking | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index b18dd1779029..f1997e9da61f 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -349,7 +349,11 @@ prototypes:
 locking rules:
 			inode->i_lock	may block
 fl_copy_lock:		yes		no
-fl_release_private:	maybe		no
+fl_release_private:	maybe		maybe[1]
+
+[1]:	->fl_release_private for flock or POSIX locks is currently allowed
+to block. Leases however can still be freed while the i_lock is held and
+so fl_release_private called on a lease should not block.
 
 ----------------------- lock_manager_operations ---------------------------
 prototypes:
-- 
1.9.3

