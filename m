Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3JYQIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:08:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:54374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab3JYQIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:08:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,571,1378882800"; 
   d="scan'208";a="417211637"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev 2/5] f2fs: Add a new mount option: inline_data
Date: Sat, 26 Oct 2013 00:01:56 +0800
Message-Id: <1382716919-23345-3-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Add a mount option: inline_data. If the mount option is set,
data of New created small files can be stored in their inode.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/super.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e42351c..e8ad7f2 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -50,6 +50,7 @@ enum {
 	Opt_active_logs,
 	Opt_disable_ext_identify,
 	Opt_inline_xattr,
+	Opt_inline_data,
 	Opt_err,
 };
 
@@ -65,6 +66,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_active_logs, "active_logs=%u"},
 	{Opt_disable_ext_identify, "disable_ext_identify"},
 	{Opt_inline_xattr, "inline_xattr"},
+	{Opt_inline_data, "inline_data"},
 	{Opt_err, NULL},
 };
 
@@ -311,6 +313,9 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_disable_ext_identify:
 			set_opt(sbi, DISABLE_EXT_IDENTIFY);
 			break;
+		case Opt_inline_data:
+			set_opt(sbi, INLINE_DATA);
+			break;
 		default:
 			f2fs_msg(sb, KERN_ERR,
 				"Unrecognized mount option \"%s\" or missing value",
@@ -508,7 +513,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 #endif
 	if (test_opt(sbi, DISABLE_EXT_IDENTIFY))
 		seq_puts(seq, ",disable_ext_identify");
-
+	if (test_opt(sbi, INLINE_DATA))
+		seq_puts(seq, ",inline_data");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
 	return 0;
-- 
1.7.9.5

