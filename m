Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaBXBn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:43:59 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49545 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaBXBn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:43:56 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH for-next 2/4] epoll: epoll() syscall declaration
Date: Sun, 23 Feb 2014 17:42:40 -0800
Message-Id: <1393206162-18151-3-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype for epoll() system call, defined in fs/eventpoll.c. This
interface behaves like kevent() in BSD systems in that it supports
the addition/deletion/modification of eventpoll entries in the same
system call that polls for ready events.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..1d2fc04 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_SYSCALLS_H
 #define _LINUX_SYSCALLS_H
 
+struct epoll;
 struct epoll_event;
 struct iattr;
 struct inode;
@@ -607,6 +608,9 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 asmlinkage long sys_old_select(struct sel_arg_struct __user *arg);
 asmlinkage long sys_epoll_create(int size);
 asmlinkage long sys_epoll_create1(int flags);
+asmlinkage long sys_epoll(int ep, struct epoll __user *in,
+			  unsigned int inc, struct epoll __user *out,
+			  unsigned int outc, int timeout);
 asmlinkage long sys_epoll_ctl(int epfd, int op, int fd,
 				struct epoll_event __user *event);
 asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,
