Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3AVMBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:01:35 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:44347 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3AVMBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:01:33 -0500
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] seq-file: Use SEEK_ macros instead of hardcoded numbers
Date: Tue, 22 Jan 2013 16:01:21 +0400
Message-Id: <1358856081-25352-1-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/seq_file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/fs/seq_file.c
===================================================================
--- linux-2.6.git.orig/fs/seq_file.c
+++ linux-2.6.git/fs/seq_file.c
@@ -308,9 +308,9 @@ loff_t seq_lseek(struct file *file, loff
 	mutex_lock(&m->lock);
 	m->version = file->f_version;
 	switch (whence) {
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
-		case 0:
+		case SEEK_SET:
 			if (offset < 0)
 				break;
 			retval = offset;
