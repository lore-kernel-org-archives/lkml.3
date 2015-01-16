Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbbAPTQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:16:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbbAPTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:16:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org,
        Daniel Mack <daniel@zonque.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/13] kdbus: add Makefile, Kconfig and MAINTAINERS entry
Date: Fri, 16 Jan 2015 11:16:16 -0800
Message-Id: <1421435777-25306-13-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

This patch hooks up the build system to actually compile the files
added by previous patches. It also adds an entry to MAINTAINERS to
direct people to Greg KH, David Herrmann, Djalal Harouni and me for
questions and patches.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS        | 12 ++++++++++++
 init/Kconfig       | 12 ++++++++++++
 ipc/Makefile       |  2 +-
 ipc/kdbus/Makefile | 22 ++++++++++++++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)
 create mode 100644 ipc/kdbus/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 3589d67437f8..638f78ea6fb6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5410,6 +5410,18 @@ S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
+KDBUS
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+M:	Daniel Mack <daniel@zonque.org>
+M:	David Herrmann <dh.herrmann@googlemail.com>
+M:	Djalal Harouni <tixxdz@opendz.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	ipc/kdbus/*
+F:	Documentation/kdbus.txt
+F:	include/uapi/linux/kdbus.h
+F:	tools/testing/selftests/kdbus/
+
 KDUMP
 M:	Vivek Goyal <vgoyal@redhat.com>
 M:	Haren Myneni <hbabu@us.ibm.com>
diff --git a/init/Kconfig b/init/Kconfig
index 9afb971497f4..4263ef30dbcc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -261,6 +261,18 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config KDBUS
+	tristate "kdbus interprocess communication"
+	depends on TMPFS
+	help
+	  D-Bus is a system for low-latency, low-overhead, easy to use
+	  interprocess communication (IPC).
+
+	  See Documentation/kdbus.txt
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called kdbus.
+
 config CROSS_MEMORY_ATTACH
 	bool "Enable process_vm_readv/writev syscalls"
 	depends on MMU
diff --git a/ipc/Makefile b/ipc/Makefile
index 86c7300ecdf5..68ec4167d11b 100644
--- a/ipc/Makefile
+++ b/ipc/Makefile
@@ -9,4 +9,4 @@ obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 obj-$(CONFIG_IPC_NS) += namespace.o
 obj-$(CONFIG_POSIX_MQUEUE_SYSCTL) += mq_sysctl.o
-
+obj-$(CONFIG_KDBUS) += kdbus/
diff --git a/ipc/kdbus/Makefile b/ipc/kdbus/Makefile
new file mode 100644
index 000000000000..7ee9271e1449
--- /dev/null
+++ b/ipc/kdbus/Makefile
@@ -0,0 +1,22 @@
+kdbus-y := \
+	bus.o \
+	connection.o \
+	endpoint.o \
+	fs.o \
+	handle.o \
+	item.o \
+	main.o \
+	match.o \
+	message.o \
+	metadata.o \
+	names.o \
+	node.o \
+	notify.o \
+	domain.o \
+	policy.o \
+	pool.o \
+	reply.o \
+	queue.o \
+	util.o
+
+obj-$(CONFIG_KDBUS) += kdbus.o
-- 
2.2.1

