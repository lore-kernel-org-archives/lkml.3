Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbaDIRBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:01:36 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:14264 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbaDIRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:01:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnYGAJx8RVNXQ67n/2dsb2JhbABZgwbFH4EhF3SCZhwjGIECJBOIAAHNPY4jSYQ/AQOOXol/AZJCgzI7gS0
Date: Wed, 9 Apr 2014 19:01:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Anton <anton@tuxera.com>
Subject: [PATCH v2] NTFS: Remove NULL value assignments
Message-Id: <20140409190128.573f05f235cc227617bb76b2@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static values are automatically initialized to NULL.

Acked-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ntfs/compress.c | 2 +-
 fs/ntfs/super.c    | 4 ++--
 fs/ntfs/sysctl.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index ee4144c..f82498c 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -58,7 +58,7 @@ typedef enum {
 /**
  * ntfs_compression_buffer - one buffer for the decompression engine
  */
-static u8 *ntfs_compression_buffer = NULL;
+static u8 *ntfs_compression_buffer;
 
 /**
  * ntfs_cb_lock - spinlock which protects ntfs_compression_buffer
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 9de2491..6c3296e 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -50,8 +50,8 @@
 static unsigned long ntfs_nr_compression_users;
 
 /* A global default upcase table and a corresponding reference count. */
-static ntfschar *default_upcase = NULL;
-static unsigned long ntfs_nr_upcase_users = 0;
+static ntfschar *default_upcase;
+static unsigned long ntfs_nr_upcase_users;
 
 /* Error constants/strings used in inode.c::ntfs_show_options(). */
 typedef enum {
diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 79a8918..1927170 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -56,7 +56,7 @@ static ctl_table sysctls_root[] = {
 };
 
 /* Storage for the sysctls header. */
-static struct ctl_table_header *sysctls_root_table = NULL;
+static struct ctl_table_header *sysctls_root_table;
 
 /**
  * ntfs_sysctl - add or remove the debug sysctl
