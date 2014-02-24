Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBXBny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:43:54 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61999 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaBXBnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:43:53 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
Subject: [RFC PATCH for-next 1/4] epoll: struct epoll userspace definiton
Date: Sun, 23 Feb 2014 17:42:39 -0800
Message-Id: <1393206162-18151-2-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to facilitate the addition, modification, and/or deletion
of multiple eventpoll entries in a single system call, struct epoll
is defined to communicate the same information as struct epoll_event
plus the associated file descriptor. The new epoll() system call uses
it for both input and output.

Signed-off-by: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
---
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2..e702072 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -61,6 +61,12 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
+struct epoll {
+	int ep_fildes; /* file descriptor */
+	int ep_events; /* triggering events */
+	long long ep_ident; /* entry ID (cf. epoll_event->data) */
+} EPOLL_PACKED;
+
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
