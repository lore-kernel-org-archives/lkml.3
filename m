Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbaGAV4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:56:35 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:59987 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaGAVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:55 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 42/50] mars: add new file include/linux/xio/xio_server.h
Date: Tue,  1 Jul 2014 23:47:22 +0200
Message-Id: <1404251250-22992-43-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio/xio_server.h | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 include/linux/xio/xio_server.h

diff --git a/include/linux/xio/xio_server.h b/include/linux/xio/xio_server.h
new file mode 100644
index 0000000..98ad994
--- /dev/null
+++ b/include/linux/xio/xio_server.h
@@ -0,0 +1,48 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_SERVER_H
+#define XIO_SERVER_H
+
+#include <linux/wait.h>
+
+#include <linux/xio_net.h>
+#include <linux/brick/lib_limiter.h>
+
+extern int server_show_statist;
+
+extern struct xio_limiter server_limiter;
+
+struct server_aio_aspect {
+	GENERIC_ASPECT(aio);
+	struct server_brick *brick;
+	struct list_head cb_head;
+	bool do_put;
+};
+
+struct server_output {
+	XIO_OUTPUT(server);
+};
+
+struct server_brick {
+	XIO_BRICK(server);
+	atomic_t in_flight;
+	struct semaphore socket_sem;
+	struct xio_socket handler_socket;
+	struct task_struct *handler_thread;
+	struct task_struct *cb_thread;
+
+	wait_queue_head_t startup_event;
+	wait_queue_head_t cb_event;
+	spinlock_t cb_lock;
+	struct list_head cb_read_list;
+	struct list_head cb_write_list;
+	bool cb_running;
+	bool handler_running;
+};
+
+struct server_input {
+	XIO_INPUT(server);
+};
+
+XIO_TYPES(server);
+
+#endif
-- 
2.0.0

