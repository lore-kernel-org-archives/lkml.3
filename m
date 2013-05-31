Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3EaVY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:24:59 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51106 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab3EaVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:24:52 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] debugfs: write_file_bool() - ensure strtobool() operates on valid data
Date: Fri, 31 May 2013 23:24:29 +0200
Message-Id: <1370035469-18138-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case, userland writes an empty string to a bool debugfs file, buf[]
will still be uninitialized when being passed to strtobool() making the
outcome of that function purely random.

Fix this by always zero-terminating the buffer.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 fs/debugfs/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index c5ca6ae..b15a1c5 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -431,6 +431,7 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
+	buf[buf_size] = '\0';
 	if (strtobool(buf, &bv) == 0)
 		*val = bv;
 
-- 
1.7.10.4

