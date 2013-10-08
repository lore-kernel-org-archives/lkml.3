Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3JHMic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:38:32 -0400
Received: from mail.abilis.ch ([195.70.19.74]:20768 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JHMib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:38:31 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] Export symbols for splice in modules
Date: Tue,  8 Oct 2013 14:38:18 +0200
Message-Id: <1381235898-24186-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbols splice_to_pipe, splice_grow_spd and splice_shrink_spd are not
currently exported from the kernel. This prevents the implementation of
drivers using splice in modules not statically linked with the kernel. This
patch exports those symbols to make it possible to implement splice in
kernel modules.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 fs/splice.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 3b7ee65..28e19b7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -265,6 +265,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 	return ret;
 }
+EXPORT_SYMBOL(splice_to_pipe);
 
 void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {
@@ -293,6 +294,7 @@ int splice_grow_spd(const struct pipe_inode_info *pipe, struct splice_pipe_desc
 	kfree(spd->partial);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(splice_grow_spd);
 
 void splice_shrink_spd(struct splice_pipe_desc *spd)
 {
@@ -302,6 +304,7 @@ void splice_shrink_spd(struct splice_pipe_desc *spd)
 	kfree(spd->pages);
 	kfree(spd->partial);
 }
+EXPORT_SYMBOL(splice_shrink_spd);
 
 static int
 __generic_file_splice_read(struct file *in, loff_t *ppos,
-- 
1.7.1

