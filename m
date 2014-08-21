Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaHUQIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:08:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:58731 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaHUQIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:08:06 -0400
Subject: [PATCH 1/6] fuse: add FOPEN_SYNC_RELEASE flag to ff->open_flags
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Aug 2014 20:08:03 +0400
Message-ID: <20140821160752.11005.43352.stgit@localhost.localdomain>
In-Reply-To: <20140821160304.11005.15166.stgit@localhost.localdomain>
References: <20140821160304.11005.15166.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feature will be governed by fuse file open flag FOPEN_SYNC_RELEASE.
Userspace can enable it on per file basis in the same way as for
FOPEN_KEEP_CACHE or FOPEN_DIRECT_IO.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 include/uapi/linux/fuse.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 25084a0..607c45c 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -205,10 +205,13 @@ struct fuse_file_lock {
  * FOPEN_DIRECT_IO: bypass page cache for this open file
  * FOPEN_KEEP_CACHE: don't invalidate the data cache on open
  * FOPEN_NONSEEKABLE: the file is not seekable
+ * FOPEN_SYNC_RELEASE: synchronously release file on last fput,
+ *                     which, in turn, not always bound to fclose(2)!
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
 #define FOPEN_NONSEEKABLE	(1 << 2)
+#define FOPEN_SYNC_RELEASE	(1 << 3)
 
 /**
  * INIT request/reply flags

