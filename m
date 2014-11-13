Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179AbaKMVbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:33 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:43610 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934391AbaKMVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:31 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 49/56] net/socket: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:26 +0100
Message-Id: <1415913813-362-50-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from socket when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 net/socket.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 95ee7d8..5cb347a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -155,8 +155,8 @@ static const struct file_operations socket_file_ops = {
 	.release =	sock_close,
 	.fasync =	sock_fasync,
 	.sendpage =	sock_sendpage,
-	.splice_write = generic_splice_sendpage,
-	.splice_read =	sock_splice_read,
+	SPLICE_WRITE_INIT(generic_splice_sendpage)
+	SPLICE_READ_INIT(sock_splice_read)
 };
 
 /*
@@ -881,7 +881,8 @@ static ssize_t sock_sendpage(struct file *file, struct page *page,
 	return kernel_sendpage(sock, page, offset, size, flags);
 }
 
-static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
+static ssize_t __maybe_unused sock_splice_read(
+				struct file *file, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags)
 {
-- 
1.9.1

