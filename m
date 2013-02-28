Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3B1XSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:18:01 -0500
Received: from sauhun.de ([89.238.76.85]:41363 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3B1XR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:17:59 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Wolfram Sang <wsa@the-dreams.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] shmem: fix build regression
Date: Fri,  1 Mar 2013 00:17:39 +0100
Message-Id: <1362093459-24608-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6b4d0b27 (clean shmem_file_setup() a bit) broke allnoconfig since
this needs the NOMMU path where 'error' is still needed:

mm/shmem.c:2935:2: error: 'error' undeclared (first use in this function)

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ed2befb..56ff7d7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2897,6 +2897,7 @@ static struct dentry_operations anon_ops = {
  */
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
+	int error;
 	struct file *res;
 	struct inode *inode;
 	struct path path;
-- 
1.7.10.4

