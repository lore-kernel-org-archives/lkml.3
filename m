Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaDONvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:51:40 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50937 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaDONvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:51:38 -0400
From: Jan Glauber <jan.glauber@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, Jan Glauber <jan.glauber@gmail.com>
Subject: [PATCH] net: use SYSCALL_DEFINEx for sys_recv
Date: Tue, 15 Apr 2014 15:50:01 +0200
Message-Id: <1397569801-10485-1-git-send-email-jan.glauber@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sys_recv a first class citizen by using the SYSCALL_DEFINEx
macro. Besides being cleaner this will also generate meta data
for the system call so tracing tools like ftrace or LTTng can
resolve this system call.

Signed-off-by: Jan Glauber <jan.glauber@gmail.com>
---
 net/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index a19ae19..d258945 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1879,8 +1879,8 @@ out:
  *	Receive a datagram from a socket.
  */
 
-asmlinkage long sys_recv(int fd, void __user *ubuf, size_t size,
-			 unsigned int flags)
+SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
+		unsigned int, flags)
 {
 	return sys_recvfrom(fd, ubuf, size, flags, NULL, NULL);
 }
-- 
1.7.9.5

