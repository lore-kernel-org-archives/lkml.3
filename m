Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbbAUVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:54:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:4020 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbbAUVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:54:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,444,1418112000"; 
   d="scan'208";a="654495817"
Date: Thu, 22 Jan 2015 05:53:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [PATCH trace] tracing: tracefs_dir_inode_operations can be static
Message-ID: <20150121215324.GA20240@snb>
References: <201501220506.6s7TnZmb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501220506.6s7TnZmb%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/tracefs/inode.c:95:31: sparse: symbol 'tracefs_dir_inode_operations' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 29632ce..3462360 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -92,7 +92,7 @@ static int tracefs_syscall_rmdir(struct inode *inode, struct dentry *dentry)
 	return ret;
 }
 
-const struct inode_operations tracefs_dir_inode_operations = {
+static const struct inode_operations tracefs_dir_inode_operations = {
 	.lookup		= simple_lookup,
 	.mkdir		= tracefs_syscall_mkdir,
 	.rmdir		= tracefs_syscall_rmdir,
