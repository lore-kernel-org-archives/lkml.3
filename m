Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3GNQ75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 12:59:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab3GNQ7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 12:59:49 -0400
Date: Sun, 14 Jul 2013 18:54:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: do_mmap_pgoff: cleanup the usage of file_inode()
Message-ID: <20130714165454.GA20854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714165432.GA20828@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple cleanup. Move "struct inode *inode" variable into "if (file)"
block to simplify the code and avoid the unnecessary check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/mmap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 6b69352..759dce7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1202,7 +1202,6 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long *populate)
 {
 	struct mm_struct * mm = current->mm;
-	struct inode *inode;
 	vm_flags_t vm_flags;
 
 	*populate = 0;
@@ -1265,9 +1264,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			return -EAGAIN;
 	}
 
-	inode = file ? file_inode(file) : NULL;
-
 	if (file) {
+		struct inode *inode = file_inode(file);
+
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
 			if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
-- 
1.5.5.1

