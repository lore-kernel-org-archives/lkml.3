Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaDHUKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:10:35 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:19186 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598AbaDHUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:10:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArANALlWRFNXQwqv/2dsb2JhbABZgwaDS8F+AgKBIRd0gmYcIxiBAiQTiAABymeOI0mEPwEDjl6JfgGSQIMyO4Et
Date: Tue, 8 Apr 2014 22:12:01 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, anton <anton@tuxera.com>
Subject: [PATCH 1/1] NTFS: Remove NULL value assignments
Message-Id: <20140408221201.492b38bb74c3fb3ee33403ce@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static values are automatically initialized to NULL.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ntfs/compress.c | 2 +-
 fs/ntfs/super.c    | 2 +-
 fs/ntfs/sysctl.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index 9de2491..eed5119 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -50,7 +50,7 @@
 static unsigned long ntfs_nr_compression_users;
 
 /* A global default upcase table and a corresponding reference count. */
-static ntfschar *default_upcase = NULL;
+static ntfschar *default_upcase;
 static unsigned long ntfs_nr_upcase_users = 0;
 
 /* Error constants/strings used in inode.c::ntfs_show_options(). */
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
-- 
1.8.4.5

