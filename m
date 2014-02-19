Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaBSUYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:24:04 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:52164 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034AbaBSUYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:24:02 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0XAIMRBVNbsmOW/2dsb2JhbABZKIJegkKBEL0+AgKBGxd0glMTHCMYgQI3iAkBzi8XjmQdhCIEiUaOaQGSJIM6Lw
Date: Wed, 19 Feb 2014 20:25:23 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>,
        Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] befs: Replace kmalloc/memset 0 by kzalloc
Message-Id: <20140219202523.7092f139bba51b717f2769a5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc for clean fs_info allocation like other filesystems.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 845d2d6..e0002e0 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -791,7 +791,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	save_mount_options(sb, data);
 
-	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
+	sb->s_fs_info = kzalloc(sizeof(*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		printk(KERN_ERR
 		       "BeFS(%s): Unable to allocate memory for private "
@@ -799,7 +799,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		goto unacquire_none;
 	}
 	befs_sb = BEFS_SB(sb);
-	memset(befs_sb, 0, sizeof(befs_sb_info));
 
 	if (!parse_options((char *) data, &befs_sb->mount_opts)) {
 		befs_error(sb, "cannot parse mount options");
-- 
1.8.1.4

