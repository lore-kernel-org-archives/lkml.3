Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbaKMVbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:19 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58533 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999AbaKMVbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:13 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 46/56] kernel/relay: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:23 +0100
Message-Id: <1415913813-362-47-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from relay when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 kernel/relay.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 5a56d3c..fed90ca 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1201,6 +1201,7 @@ static const struct pipe_buf_operations relay_pipe_buf_ops = {
 	.get = generic_pipe_buf_get,
 };
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static void relay_page_release(struct splice_pipe_desc *spd, unsigned int i)
 {
 }
@@ -1338,6 +1339,7 @@ static ssize_t relay_file_splice_read(struct file *in,
 
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 const struct file_operations relay_file_operations = {
 	.open		= relay_file_open,
@@ -1346,7 +1348,7 @@ const struct file_operations relay_file_operations = {
 	.read		= relay_file_read,
 	.llseek		= no_llseek,
 	.release	= relay_file_release,
-	.splice_read	= relay_file_splice_read,
+	SPLICE_READ_INIT(relay_file_splice_read)
 };
 EXPORT_SYMBOL_GPL(relay_file_operations);
 
-- 
1.9.1

