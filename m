Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaDWQFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:05:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:4309 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663AbaDWQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:05:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQLAOfhV1NXQ6tr/2dsb2JhbABZgwarbplsgRkXdIJmHCMYgQIkE4hFAc8jjliEQAEDjmyKCAGKbIdpgzM7
Date: Wed, 23 Apr 2014 18:05:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tytso <tytso@mit.edu>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ext4/super.c: add __exit to
 ext4_destroy_lazyinit_thread
Message-Id: <20140423180539.0ddfc2477204f890c09f199d@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_destroy_lazyinit_thread is only called by __exit ext4_exit_fs

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f3c6670..a2b097a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -80,7 +80,7 @@ static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 static inline int ext2_feature_set_ok(struct super_block *sb);
 static inline int ext3_feature_set_ok(struct super_block *sb);
 static int ext4_feature_set_ok(struct super_block *sb, int readonly);
-static void ext4_destroy_lazyinit_thread(void);
+static void __exit ext4_destroy_lazyinit_thread(void);
 static void ext4_unregister_li_request(struct super_block *sb);
 static void ext4_clear_request_list(void);
 static int ext4_reserve_clusters(struct ext4_sb_info *, ext4_fsblk_t);
@@ -3155,7 +3155,7 @@ out:
  * We do not need to lock anything since this is called on
  * module unload.
  */
-static void ext4_destroy_lazyinit_thread(void)
+static void __exit ext4_destroy_lazyinit_thread(void)
 {
 	/*
 	 * If thread exited earlier
-- 
1.9.1
