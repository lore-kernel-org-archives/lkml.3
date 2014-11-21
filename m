Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbaKUFHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:07:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaKUFES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:04:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: kdbus: add selftests
Date: Thu, 20 Nov 2014 21:02:29 -0800
Message-Id: <1416546149-24799-14-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>

This patch adds a quite extensive test suite for kdbus that checks
the most important code pathes in the driver. The idea is to extend
the test suite over time.

Also, this code can serve as an example implementation to show how to
use the kernel API from userspace.

Signed-off-by: Daniel Mack <daniel@zonque.org>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/Makefile                 |    1 +
 tools/testing/selftests/kdbus/.gitignore         |   11 +
 tools/testing/selftests/kdbus/Makefile           |   45 +
 tools/testing/selftests/kdbus/kdbus-enum.c       |   94 ++
 tools/testing/selftests/kdbus/kdbus-enum.h       |   14 +
 tools/testing/selftests/kdbus/kdbus-test.c       |  546 ++++++++++
 tools/testing/selftests/kdbus/kdbus-test.h       |   81 ++
 tools/testing/selftests/kdbus/kdbus-util.c       | 1240 ++++++++++++++++++++++
 tools/testing/selftests/kdbus/kdbus-util.h       |  143 +++
 tools/testing/selftests/kdbus/test-activator.c   |  317 ++++++
 tools/testing/selftests/kdbus/test-benchmark.c   |  409 +++++++
 tools/testing/selftests/kdbus/test-bus.c         |  130 +++
 tools/testing/selftests/kdbus/test-chat.c        |  123 +++
 tools/testing/selftests/kdbus/test-connection.c  |  501 +++++++++
 tools/testing/selftests/kdbus/test-daemon.c      |   66 ++
 tools/testing/selftests/kdbus/test-endpoint.c    |  221 ++++
 tools/testing/selftests/kdbus/test-fd.c          |  664 ++++++++++++
 tools/testing/selftests/kdbus/test-free.c        |   34 +
 tools/testing/selftests/kdbus/test-match.c       |  437 ++++++++
 tools/testing/selftests/kdbus/test-message.c     |  371 +++++++
 tools/testing/selftests/kdbus/test-metadata-ns.c |  258 +++++
 tools/testing/selftests/kdbus/test-monitor.c     |  156 +++
 tools/testing/selftests/kdbus/test-names.c       |  184 ++++
 tools/testing/selftests/kdbus/test-policy-ns.c   |  622 +++++++++++
 tools/testing/selftests/kdbus/test-policy-priv.c | 1168 ++++++++++++++++++++
 tools/testing/selftests/kdbus/test-policy.c      |   81 ++
 tools/testing/selftests/kdbus/test-race.c        |  313 ++++++
 tools/testing/selftests/kdbus/test-sync.c        |  241 +++++
 tools/testing/selftests/kdbus/test-timeout.c     |   97 ++
 29 files changed, 8568 insertions(+)
 create mode 100644 tools/testing/selftests/kdbus/.gitignore
 create mode 100644 tools/testing/selftests/kdbus/Makefile
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-enum.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-test.h
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.c
 create mode 100644 tools/testing/selftests/kdbus/kdbus-util.h
 create mode 100644 tools/testing/selftests/kdbus/test-activator.c
 create mode 100644 tools/testing/selftests/kdbus/test-benchmark.c
 create mode 100644 tools/testing/selftests/kdbus/test-bus.c
 create mode 100644 tools/testing/selftests/kdbus/test-chat.c
 create mode 100644 tools/testing/selftests/kdbus/test-connection.c
 create mode 100644 tools/testing/selftests/kdbus/test-daemon.c
 create mode 100644 tools/testing/selftests/kdbus/test-endpoint.c
 create mode 100644 tools/testing/selftests/kdbus/test-fd.c
 create mode 100644 tools/testing/selftests/kdbus/test-free.c
 create mode 100644 tools/testing/selftests/kdbus/test-match.c
 create mode 100644 tools/testing/selftests/kdbus/test-message.c
 create mode 100644 tools/testing/selftests/kdbus/test-metadata-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-monitor.c
 create mode 100644 tools/testing/selftests/kdbus/test-names.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-ns.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy-priv.c
 create mode 100644 tools/testing/selftests/kdbus/test-policy.c
 create mode 100644 tools/testing/selftests/kdbus/test-race.c
 create mode 100644 tools/testing/selftests/kdbus/test-sync.c
 create mode 100644 tools/testing/selftests/kdbus/test-timeout.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 45f145c6f843..10cd20e07244 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -2,6 +2,7 @@ TARGETS = breakpoints
 TARGETS += cpu-hotplug
 TARGETS += efivarfs
 TARGETS += kcmp
+TARGETS += kdbus
 TARGETS += memfd
 TARGETS += memory-hotplug
 TARGETS += mqueue
diff --git a/tools/testing/selftests/kdbus/.gitignore b/tools/testing/selftests/kdbus/.gitignore
new file mode 100644
index 000000000000..4b97beee5f80
--- /dev/null
+++ b/tools/testing/selftests/kdbus/.gitignore
@@ -0,0 +1,11 @@
+*.cmd
+*.ko
+*.mod.c
+modules.order
+Module.symvers
+*.o
+*.swp
+.tmp_versions
+tags
+tools/kdbus-monitor
+test/kdbus-test
diff --git a/tools/testing/selftests/kdbus/Makefile b/tools/testing/selftests/kdbus/Makefile
new file mode 100644
index 000000000000..b3c25409b73e
--- /dev/null
+++ b/tools/testing/selftests/kdbus/Makefile
@@ -0,0 +1,45 @@
+CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../include/uapi/
+CFLAGS += -std=gnu99
+CFLAGS += -DKBUILD_MODNAME=\"kdbus\" -D_GNU_SOURCE
+LDLIBS = -pthread -lcap
+
+OBJS= \
+	kdbus-enum.o		\
+	kdbus-util.o		\
+	kdbus-test.o		\
+	kdbus-test.o		\
+	test-activator.o	\
+	test-benchmark.o	\
+	test-bus.o		\
+	test-chat.o		\
+	test-connection.o	\
+	test-daemon.o		\
+	test-endpoint.o		\
+	test-fd.o		\
+	test-free.o		\
+	test-match.o		\
+	test-message.o		\
+	test-metadata-ns.o	\
+	test-monitor.o		\
+	test-names.o		\
+	test-policy.o		\
+	test-policy-ns.o	\
+	test-policy-priv.o	\
+	test-race.o		\
+	test-sync.o		\
+	test-timeout.o
+
+all: kdbus-test
+
+%.o: %.c
+	gcc $(CFLAGS) -c $< -o $@
+
+kdbus-test: $(OBJS)
+	gcc $(CFLAGS) $^ $(LDLIBS) -o $@
+
+run_tests:
+	./kdbus-test
+
+clean:
+	rm -f *.o kdbus-test
diff --git a/tools/testing/selftests/kdbus/kdbus-enum.c b/tools/testing/selftests/kdbus/kdbus-enum.c
new file mode 100644
index 000000000000..4a1615d3cf00
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-enum.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+struct kdbus_enum_table {
+	long long id;
+	const char *name;
+};
+
+#define TABLE(what) static struct kdbus_enum_table kdbus_table_##what[]
+#define ENUM(_id) { .id = _id, .name = STRINGIFY(_id) }
+#define LOOKUP(what)							\
+	const char *enum_##what(long long id)				\
+	{								\
+		for (size_t i = 0; i < ELEMENTSOF(kdbus_table_##what); i++) \
+			if (id == kdbus_table_##what[i].id)		\
+				return kdbus_table_##what[i].name;	\
+		return "UNKNOWN";					\
+	}
+
+TABLE(CMD) = {
+	ENUM(KDBUS_CMD_BUS_MAKE),
+	ENUM(KDBUS_CMD_ENDPOINT_MAKE),
+	ENUM(KDBUS_CMD_HELLO),
+	ENUM(KDBUS_CMD_MSG_SEND),
+	ENUM(KDBUS_CMD_MSG_RECV),
+	ENUM(KDBUS_CMD_NAME_LIST),
+	ENUM(KDBUS_CMD_NAME_RELEASE),
+	ENUM(KDBUS_CMD_CONN_INFO),
+	ENUM(KDBUS_CMD_MATCH_ADD),
+	ENUM(KDBUS_CMD_MATCH_REMOVE),
+};
+LOOKUP(CMD);
+
+TABLE(MSG) = {
+	ENUM(_KDBUS_ITEM_NULL),
+	ENUM(KDBUS_ITEM_PAYLOAD_VEC),
+	ENUM(KDBUS_ITEM_PAYLOAD_OFF),
+	ENUM(KDBUS_ITEM_PAYLOAD_MEMFD),
+	ENUM(KDBUS_ITEM_FDS),
+	ENUM(KDBUS_ITEM_BLOOM_PARAMETER),
+	ENUM(KDBUS_ITEM_BLOOM_FILTER),
+	ENUM(KDBUS_ITEM_DST_NAME),
+	ENUM(KDBUS_ITEM_MAKE_NAME),
+	ENUM(KDBUS_ITEM_ATTACH_FLAGS_SEND),
+	ENUM(KDBUS_ITEM_ATTACH_FLAGS_RECV),
+	ENUM(KDBUS_ITEM_ID),
+	ENUM(KDBUS_ITEM_NAME),
+	ENUM(KDBUS_ITEM_TIMESTAMP),
+	ENUM(KDBUS_ITEM_CREDS),
+	ENUM(KDBUS_ITEM_AUXGROUPS),
+	ENUM(KDBUS_ITEM_OWNED_NAME),
+	ENUM(KDBUS_ITEM_TID_COMM),
+	ENUM(KDBUS_ITEM_PID_COMM),
+	ENUM(KDBUS_ITEM_EXE),
+	ENUM(KDBUS_ITEM_CMDLINE),
+	ENUM(KDBUS_ITEM_CGROUP),
+	ENUM(KDBUS_ITEM_CAPS),
+	ENUM(KDBUS_ITEM_SECLABEL),
+	ENUM(KDBUS_ITEM_AUDIT),
+	ENUM(KDBUS_ITEM_CONN_DESCRIPTION),
+	ENUM(KDBUS_ITEM_NAME_ADD),
+	ENUM(KDBUS_ITEM_NAME_REMOVE),
+	ENUM(KDBUS_ITEM_NAME_CHANGE),
+	ENUM(KDBUS_ITEM_ID_ADD),
+	ENUM(KDBUS_ITEM_ID_REMOVE),
+	ENUM(KDBUS_ITEM_REPLY_TIMEOUT),
+	ENUM(KDBUS_ITEM_REPLY_DEAD),
+};
+LOOKUP(MSG);
+
+TABLE(PAYLOAD) = {
+	ENUM(KDBUS_PAYLOAD_KERNEL),
+	ENUM(KDBUS_PAYLOAD_DBUS),
+};
+LOOKUP(PAYLOAD);
diff --git a/tools/testing/selftests/kdbus/kdbus-enum.h b/tools/testing/selftests/kdbus/kdbus-enum.h
new file mode 100644
index 000000000000..110bfd332859
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-enum.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+#pragma once
+
+const char *enum_CMD(long long id);
+const char *enum_MSG(long long id);
+const char *enum_MATCH(long long id);
+const char *enum_PAYLOAD(long long id);
diff --git a/tools/testing/selftests/kdbus/kdbus-test.c b/tools/testing/selftests/kdbus/kdbus-test.c
new file mode 100644
index 000000000000..02f295a03ebc
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-test.c
@@ -0,0 +1,546 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <time.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <assert.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <sys/wait.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+enum {
+	TEST_CREATE_BUS		= 1 << 0,
+	TEST_CREATE_CONN	= 1 << 1,
+};
+
+struct kdbus_test {
+	const char *name;
+	const char *desc;
+	int (*func)(struct kdbus_test_env *env);
+	unsigned int flags;
+};
+
+static const struct kdbus_test tests[] = {
+	{
+		.name	= "bus-make",
+		.desc	= "bus make functions",
+		.func	= kdbus_test_bus_make,
+		.flags	= 0,
+	},
+	{
+		.name	= "hello",
+		.desc	= "the HELLO command",
+		.func	= kdbus_test_hello,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "byebye",
+		.desc	= "the BYEBYE command",
+		.func	= kdbus_test_byebye,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "chat",
+		.desc	= "a chat pattern",
+		.func	= kdbus_test_chat,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "daemon",
+		.desc	= "a simple dameon",
+		.func	= kdbus_test_daemon,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "fd-passing",
+		.desc	= "file descriptor passing",
+		.func	= kdbus_test_fd_passing,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "endpoint",
+		.desc	= "custom endpoint",
+		.func	= kdbus_test_custom_endpoint,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "monitor",
+		.desc	= "monitor functionality",
+		.func	= kdbus_test_monitor,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "name-basics",
+		.desc	= "basic name registry functions",
+		.func	= kdbus_test_name_basic,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "name-conflict",
+		.desc	= "name registry conflict details",
+		.func	= kdbus_test_name_conflict,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "name-queue",
+		.desc	= "queuing of names",
+		.func	= kdbus_test_name_queue,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "message-basic",
+		.desc	= "basic message handling",
+		.func	= kdbus_test_message_basic,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "message-prio",
+		.desc	= "handling of messages with priority",
+		.func	= kdbus_test_message_prio,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "message-quota",
+		.desc	= "message quotas are enforced",
+		.func	= kdbus_test_message_quota,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "timeout",
+		.desc	= "timeout",
+		.func	= kdbus_test_timeout,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "sync-byebye",
+		.desc	= "synchronous replies vs. BYEBYE",
+		.func	= kdbus_test_sync_byebye,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "sync-reply",
+		.desc	= "synchronous replies",
+		.func	= kdbus_test_sync_reply,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "message-free",
+		.desc	= "freeing of memory",
+		.func	= kdbus_test_free,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "connection-info",
+		.desc	= "retrieving connection information",
+		.func	= kdbus_test_conn_info,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "connection-update",
+		.desc	= "updating connection information",
+		.func	= kdbus_test_conn_update,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "writable-pool",
+		.desc	= "verifying pools are never writable",
+		.func	= kdbus_test_writable_pool,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "policy",
+		.desc	= "policy",
+		.func	= kdbus_test_policy,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "policy-priv",
+		.desc	= "unprivileged bus access",
+		.func	= kdbus_test_policy_priv,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "policy-ns",
+		.desc	= "policy in user namespaces",
+		.func	= kdbus_test_policy_ns,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "metadata-ns",
+		.desc	= "metadata in user namespaces",
+		.func	= kdbus_test_metadata_ns,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-id-add",
+		.desc	= "adding of matches by id",
+		.func	= kdbus_test_match_id_add,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-id-remove",
+		.desc	= "removing of matches by id",
+		.func	= kdbus_test_match_id_remove,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-replace",
+		.desc	= "replace of matches with the same cookie",
+		.func	= kdbus_test_match_replace,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-name-add",
+		.desc	= "adding of matches by name",
+		.func	= kdbus_test_match_name_add,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-name-remove",
+		.desc	= "removing of matches by name",
+		.func	= kdbus_test_match_name_remove,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-name-change",
+		.desc	= "matching for name changes",
+		.func	= kdbus_test_match_name_change,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "match-bloom",
+		.desc	= "matching with bloom filters",
+		.func	= kdbus_test_match_bloom,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "activator",
+		.desc	= "activator connections",
+		.func	= kdbus_test_activator,
+		.flags	= TEST_CREATE_BUS | TEST_CREATE_CONN,
+	},
+	{
+		.name	= "benchmark",
+		.desc	= "benchmark",
+		.func	= kdbus_test_benchmark,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "race-byebye",
+		.desc	= "race multiple byebyes",
+		.func	= kdbus_test_race_byebye,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{
+		.name	= "race-byebye-match",
+		.desc	= "race byebye vs match removal",
+		.func	= kdbus_test_race_byebye_match,
+		.flags	= TEST_CREATE_BUS,
+	},
+	{ NULL } /* sentinel */
+};
+
+static int test_prepare_env(const struct kdbus_test *t,
+			    struct kdbus_test_env *env,
+			    const char *root,
+			    const char *busname)
+{
+	if (t->flags & TEST_CREATE_BUS) {
+		char *s, *n;
+		int ret;
+
+		asprintf(&s, "%s/control", root);
+
+		env->control_fd = open(s, O_RDWR);
+		free(s);
+		ASSERT_RETURN(env->control_fd >= 0);
+
+		if (!busname) {
+			n = unique_name("test-bus");
+			ASSERT_RETURN(n);
+		}
+
+		ret = kdbus_create_bus(env->control_fd, busname ?: n,
+				       _KDBUS_ATTACH_ALL, &s);
+		ASSERT_RETURN(ret == 0);
+
+		asprintf(&env->buspath, "%s/%s/bus", root, s);
+		free(s);
+	}
+
+	if (t->flags & TEST_CREATE_CONN) {
+		env->conn = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(env->conn);
+	}
+
+	env->root = root;
+
+	return 0;
+}
+
+void test_unprepare_env(const struct kdbus_test *t, struct kdbus_test_env *env)
+{
+	if (env->conn) {
+		kdbus_conn_free(env->conn);
+		env->conn = NULL;
+	}
+
+	if (env->control_fd >= 0) {
+		close(env->control_fd);
+		env->control_fd = -1;
+	}
+
+	if (env->buspath) {
+		free(env->buspath);
+		env->buspath = NULL;
+	}
+}
+
+static int test_run(const struct kdbus_test *t, const char *root,
+		    const char *busname, int wait)
+{
+	int ret;
+	struct kdbus_test_env env = {};
+
+	ret = test_prepare_env(t, &env, root, busname);
+	if (ret != TEST_OK)
+		return ret;
+
+	if (wait > 0) {
+		printf("Sleeping %d seconds before running test ...\n", wait);
+		sleep(wait);
+	}
+
+	ret = t->func(&env);
+	test_unprepare_env(t, &env);
+	return ret;
+}
+
+static int test_run_forked(const struct kdbus_test *t, const char *root,
+			   const char *busname, int wait)
+{
+	int ret;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0) {
+		return TEST_ERR;
+	} else if (pid == 0) {
+		ret = test_run(t, root, busname, wait);
+		_exit(ret);
+	}
+
+	pid = waitpid(pid, &ret, 0);
+	if (pid <= 0)
+		return TEST_ERR;
+	else if (!WIFEXITED(ret))
+		return TEST_ERR;
+	else
+		return WEXITSTATUS(ret);
+}
+
+static void print_test_result(int ret)
+{
+	switch (ret) {
+	case TEST_OK:
+		printf("OK");
+		break;
+	case TEST_SKIP:
+		printf("SKIPPED");
+		break;
+	case TEST_ERR:
+		printf("ERROR");
+		break;
+	}
+}
+
+static int run_all_tests(const char *root, const char *busname)
+{
+	int ret;
+	unsigned int fail_cnt = 0;
+	unsigned int skip_cnt = 0;
+	unsigned int ok_cnt = 0;
+	unsigned int i;
+	const struct kdbus_test *t;
+
+	kdbus_util_verbose = false;
+
+	for (t = tests; t->name; t++) {
+		printf("Testing %s (%s) ", t->desc, t->name);
+		for (i = 0; i < 60 - strlen(t->desc) - strlen(t->name); i++)
+			printf(".");
+		printf(" ");
+
+		ret = test_run_forked(t, root, busname, 0);
+		switch (ret) {
+		case TEST_OK:
+			ok_cnt++;
+			break;
+		case TEST_SKIP:
+			skip_cnt++;
+			break;
+		case TEST_ERR:
+			fail_cnt++;
+			break;
+		}
+
+		print_test_result(ret);
+		printf("\n");
+	}
+
+	printf("\nSUMMARY: %d tests passed, %d skipped, %d failed\n",
+	       ok_cnt, skip_cnt, fail_cnt);
+
+	return fail_cnt > 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+}
+
+static void usage(const char *argv0)
+{
+	const struct kdbus_test *t;
+	unsigned int i;
+
+	printf("Usage: %s [options]\n"
+	       "Options:\n"
+	       "\t-x, --loop		Run in a loop\n"
+	       "\t-f, --fork		Fork before running a test\n"
+	       "\t-h, --help		Print this help\n"
+	       "\t-r, --root <root>	Toplevel of the kdbus hierarchy\n"
+	       "\t-t, --test <test-id>	Run one specific test only, in verbose mode\n"
+	       "\t-b, --bus <busname>	Instead of generating a random bus name, take <busname>.\n"
+	       "\t-w, --wait <secs>	Wait <secs> before actually starting test\n"
+	       "\n", argv0);
+
+	printf("By default, all test are run once, and a summary is printed.\n"
+	       "Available tests for --test:\n\n");
+
+	for (t = tests; t->name; t++) {
+		printf("\t%s", t->name);
+
+		for (i = 0; i < 24 - strlen(t->name); i++)
+			printf(" ");
+
+		printf("Test %s\n", t->desc);
+	}
+
+	printf("\n");
+	printf("Note that some tests may, if run specifically by --test, "
+	       "behave differently, and not terminate by themselves.\n");
+
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char *argv[])
+{
+	int t, ret = 0;
+	int arg_loop = 0;
+	char *arg_root = NULL;
+	char *arg_test = NULL;
+	char *arg_busname = NULL;
+	int arg_wait = 0;
+	int arg_fork = 0;
+	char *control;
+
+	static const struct option options[] = {
+		{ "loop",	no_argument,		NULL, 'x' },
+		{ "help",	no_argument,		NULL, 'h' },
+		{ "root",	required_argument,	NULL, 'r' },
+		{ "test",	required_argument,	NULL, 't' },
+		{ "bus",	required_argument,	NULL, 'b' },
+		{ "wait",	required_argument,	NULL, 'w' },
+		{ "fork",	no_argument,		NULL, 'f' },
+		{}
+	};
+
+	srand(time(NULL));
+
+	while ((t = getopt_long(argc, argv, "hxfr:t:b:w:", options, NULL)) >= 0) {
+		switch (t) {
+		case 'x':
+			arg_loop = 1;
+			break;
+
+		case 'r':
+			arg_root = optarg;
+			break;
+
+		case 't':
+			arg_test = optarg;
+			break;
+
+		case 'b':
+			arg_busname = optarg;
+			break;
+
+		case 'w':
+			arg_wait = strtol(optarg, NULL, 10);
+			break;
+
+		case 'f':
+			arg_fork = 1;
+			break;
+
+		default:
+		case 'h':
+			usage(argv[0]);
+		}
+	}
+
+	if (!arg_root)
+		arg_root = "/sys/fs/kdbus";
+
+	asprintf(&control, "%s/control", arg_root);
+
+	if (access(control, W_OK) < 0) {
+		printf("Unable to locate control node at '%s'.\n", control);
+		return EXIT_FAILURE;
+	}
+
+	free(control);
+
+	if (arg_test) {
+		const struct kdbus_test *t;
+
+		for (t = tests; t->name; t++) {
+			if (!strcmp(t->name, arg_test)) {
+				do {
+					if (arg_fork)
+						ret = test_run_forked(t,
+								arg_root,
+								arg_busname,
+								arg_wait);
+					else
+						ret = test_run(t, arg_root,
+							       arg_busname,
+							       arg_wait);
+					printf("Testing %s: ", t->desc);
+					print_test_result(ret);
+					printf("\n");
+
+					if (ret != TEST_OK)
+						break;
+				} while (arg_loop);
+
+				return ret == TEST_OK ? 0 : EXIT_FAILURE;
+			}
+		}
+
+		printf("Unknown test-id '%s'\n", arg_test);
+		return EXIT_FAILURE;
+	}
+
+	do {
+		ret = run_all_tests(arg_root, arg_busname);
+		if (ret != TEST_OK)
+			break;
+	} while (arg_loop);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kdbus/kdbus-test.h b/tools/testing/selftests/kdbus/kdbus-test.h
new file mode 100644
index 000000000000..9728a49d089c
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-test.h
@@ -0,0 +1,81 @@
+#ifndef _TEST_KDBUS_H_
+#define _TEST_KDBUS_H_
+
+struct kdbus_test_env {
+	char *buspath;
+	const char *root;
+	int control_fd;
+	struct kdbus_conn *conn;
+};
+
+enum {
+	TEST_OK,
+	TEST_SKIP,
+	TEST_ERR,
+};
+
+#define ASSERT_RETURN_VAL(cond, val)		\
+	if (!(cond)) {			\
+		fprintf(stderr,	"Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		return val;	\
+	}
+
+#define ASSERT_EXIT_VAL(cond, val)		\
+	if (!(cond)) {			\
+		fprintf(stderr, "Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		_exit(val);	\
+	}
+
+#define ASSERT_BREAK(cond)		\
+	if (!(cond)) {			\
+		fprintf(stderr, "Assertion '%s' failed in %s(), %s:%d\n", \
+			#cond, __func__, __FILE__, __LINE__);	\
+		break; \
+	}
+
+#define ASSERT_RETURN(cond)		\
+	ASSERT_RETURN_VAL(cond, TEST_ERR)
+
+#define ASSERT_EXIT(cond)		\
+	ASSERT_EXIT_VAL(cond, EXIT_FAILURE)
+
+int kdbus_test_activator(struct kdbus_test_env *env);
+int kdbus_test_benchmark(struct kdbus_test_env *env);
+int kdbus_test_bus_make(struct kdbus_test_env *env);
+int kdbus_test_byebye(struct kdbus_test_env *env);
+int kdbus_test_chat(struct kdbus_test_env *env);
+int kdbus_test_conn_info(struct kdbus_test_env *env);
+int kdbus_test_conn_update(struct kdbus_test_env *env);
+int kdbus_test_daemon(struct kdbus_test_env *env);
+int kdbus_test_custom_endpoint(struct kdbus_test_env *env);
+int kdbus_test_fd_passing(struct kdbus_test_env *env);
+int kdbus_test_free(struct kdbus_test_env *env);
+int kdbus_test_hello(struct kdbus_test_env *env);
+int kdbus_test_match_bloom(struct kdbus_test_env *env);
+int kdbus_test_match_id_add(struct kdbus_test_env *env);
+int kdbus_test_match_id_remove(struct kdbus_test_env *env);
+int kdbus_test_match_replace(struct kdbus_test_env *env);
+int kdbus_test_match_name_add(struct kdbus_test_env *env);
+int kdbus_test_match_name_change(struct kdbus_test_env *env);
+int kdbus_test_match_name_remove(struct kdbus_test_env *env);
+int kdbus_test_message_basic(struct kdbus_test_env *env);
+int kdbus_test_message_prio(struct kdbus_test_env *env);
+int kdbus_test_message_quota(struct kdbus_test_env *env);
+int kdbus_test_metadata_ns(struct kdbus_test_env *env);
+int kdbus_test_monitor(struct kdbus_test_env *env);
+int kdbus_test_name_basic(struct kdbus_test_env *env);
+int kdbus_test_name_conflict(struct kdbus_test_env *env);
+int kdbus_test_name_queue(struct kdbus_test_env *env);
+int kdbus_test_policy(struct kdbus_test_env *env);
+int kdbus_test_policy_ns(struct kdbus_test_env *env);
+int kdbus_test_policy_priv(struct kdbus_test_env *env);
+int kdbus_test_race_byebye(struct kdbus_test_env *env);
+int kdbus_test_race_byebye_match(struct kdbus_test_env *env);
+int kdbus_test_sync_byebye(struct kdbus_test_env *env);
+int kdbus_test_sync_reply(struct kdbus_test_env *env);
+int kdbus_test_timeout(struct kdbus_test_env *env);
+int kdbus_test_writable_pool(struct kdbus_test_env *env);
+
+#endif /* _TEST_KDBUS_H_ */
diff --git a/tools/testing/selftests/kdbus/kdbus-util.c b/tools/testing/selftests/kdbus/kdbus-util.c
new file mode 100644
index 000000000000..9aa609866304
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-util.c
@@ -0,0 +1,1240 @@
+/*
+ * Copyright (C) 2013-2014 Daniel Mack
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2014 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdarg.h>
+#include <string.h>
+#include <time.h>
+#include <inttypes.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <grp.h>
+#include <sys/capability.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <linux/unistd.h>
+#include <linux/memfd.h>
+
+#ifndef __NR_memfd_create
+  #ifdef __x86_64__
+    #define __NR_memfd_create 319
+  #elif defined __arm__
+    #define __NR_memfd_create 385
+  #else
+    #define __NR_memfd_create 356
+  #endif
+#endif
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#ifndef F_ADD_SEALS
+#define F_LINUX_SPECIFIC_BASE	1024
+#define F_ADD_SEALS     (F_LINUX_SPECIFIC_BASE + 9)
+#define F_GET_SEALS     (F_LINUX_SPECIFIC_BASE + 10)
+
+#define F_SEAL_SEAL     0x0001  /* prevent further seals from being set */
+#define F_SEAL_SHRINK   0x0002  /* prevent file from shrinking */
+#define F_SEAL_GROW     0x0004  /* prevent file from growing */
+#define F_SEAL_WRITE    0x0008  /* prevent writes */
+#endif
+
+int kdbus_util_verbose = true;
+
+int kdbus_create_bus(int control_fd, const char *name,
+		     uint64_t req_meta, char **path)
+{
+	struct {
+		struct kdbus_cmd_make head;
+
+		/* bloom size item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_bloom_parameter bloom;
+		} bp;
+
+		/* required metadata item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			uint64_t flags;
+		} attach;
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[64];
+		} name;
+	} bus_make;
+	int ret;
+
+	memset(&bus_make, 0, sizeof(bus_make));
+	bus_make.bp.size = sizeof(bus_make.bp);
+	bus_make.bp.type = KDBUS_ITEM_BLOOM_PARAMETER;
+	bus_make.bp.bloom.size = 64;
+	bus_make.bp.bloom.n_hash = 1;
+
+	snprintf(bus_make.name.str, sizeof(bus_make.name.str),
+		 "%u-%s", getuid(), name);
+
+	bus_make.attach.type = KDBUS_ITEM_ATTACH_FLAGS_RECV;
+	bus_make.attach.size = sizeof(bus_make.attach);
+	bus_make.attach.flags = req_meta;
+
+	bus_make.name.type = KDBUS_ITEM_MAKE_NAME;
+	bus_make.name.size = KDBUS_ITEM_HEADER_SIZE +
+			     strlen(bus_make.name.str) + 1;
+
+	bus_make.head.flags = KDBUS_MAKE_ACCESS_WORLD;
+	bus_make.head.size = sizeof(bus_make.head) +
+			     bus_make.bp.size +
+			     bus_make.attach.size +
+			     bus_make.name.size;
+
+	kdbus_printf("Creating bus with name >%s< on control fd %d ...\n",
+		     name, control_fd);
+
+	ret = ioctl(control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+
+	if (ret == 0 && path)
+		*path = strdup(bus_make.name.str);
+
+	return ret;
+}
+
+struct kdbus_conn *
+kdbus_hello(const char *path, uint64_t flags,
+	    const struct kdbus_item *item, size_t item_size)
+{
+	int fd, ret;
+	struct {
+		struct kdbus_cmd_hello hello;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[16];
+		} conn_name;
+
+		uint8_t extra_items[item_size];
+	} h;
+	struct kdbus_conn *conn;
+
+	memset(&h, 0, sizeof(h));
+
+	if (item_size > 0)
+		memcpy(h.extra_items, item, item_size);
+
+	kdbus_printf("-- opening bus connection %s\n", path);
+	fd = open(path, O_RDWR|O_CLOEXEC);
+	if (fd < 0) {
+		kdbus_printf("--- error %d (%m)\n", fd);
+		return NULL;
+	}
+
+	h.hello.flags = flags | KDBUS_HELLO_ACCEPT_FD;
+	h.hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	h.hello.attach_flags_recv = _KDBUS_ATTACH_ALL;
+	h.conn_name.type = KDBUS_ITEM_CONN_DESCRIPTION;
+	strcpy(h.conn_name.str, "this-is-my-name");
+	h.conn_name.size = KDBUS_ITEM_HEADER_SIZE + strlen(h.conn_name.str) + 1;
+
+	h.hello.size = sizeof(h);
+	h.hello.pool_size = POOL_SIZE;
+
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &h.hello);
+	if (ret < 0) {
+		kdbus_printf("--- error when saying hello: %d (%m)\n", ret);
+		return NULL;
+	}
+	kdbus_printf("-- Our peer ID for %s: %llu -- bus uuid: '%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x'\n",
+		     path, (unsigned long long)h.hello.id,
+		     h.hello.id128[0],  h.hello.id128[1],  h.hello.id128[2],
+		     h.hello.id128[3],  h.hello.id128[4],  h.hello.id128[5],
+		     h.hello.id128[6],  h.hello.id128[7],  h.hello.id128[8],
+		     h.hello.id128[9],  h.hello.id128[10], h.hello.id128[11],
+		     h.hello.id128[12], h.hello.id128[13], h.hello.id128[14],
+		     h.hello.id128[15]);
+
+	conn = malloc(sizeof(*conn));
+	if (!conn) {
+		kdbus_printf("unable to malloc()!?\n");
+		return NULL;
+	}
+
+	conn->buf = mmap(NULL, POOL_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (conn->buf == MAP_FAILED) {
+		free(conn);
+		close(fd);
+		kdbus_printf("--- error mmap (%m)\n");
+		return NULL;
+	}
+
+	conn->fd = fd;
+	conn->id = h.hello.id;
+	return conn;
+}
+
+struct kdbus_conn *
+kdbus_hello_registrar(const char *path, const char *name,
+		      const struct kdbus_policy_access *access,
+		      size_t num_access, uint64_t flags)
+{
+	struct kdbus_item *item, *items;
+	size_t i, size;
+
+	size = KDBUS_ITEM_SIZE(strlen(name) + 1) +
+		num_access * KDBUS_ITEM_SIZE(sizeof(*access));
+
+	items = alloca(size);
+
+	item = items;
+	item->size = KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+	item->type = KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+	item = KDBUS_ITEM_NEXT(item);
+
+	for (i = 0; i < num_access; i++) {
+		item->size = KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_policy_access);
+		item->type = KDBUS_ITEM_POLICY_ACCESS;
+
+		item->policy_access.type = access[i].type;
+		item->policy_access.access = access[i].access;
+		item->policy_access.id = access[i].id;
+
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	return kdbus_hello(path, flags, items, size);
+}
+
+struct kdbus_conn *kdbus_hello_activator(const char *path, const char *name,
+				   const struct kdbus_policy_access *access,
+				   size_t num_access)
+{
+	return kdbus_hello_registrar(path, name, access, num_access,
+				     KDBUS_HELLO_ACTIVATOR);
+}
+
+int kdbus_info(struct kdbus_conn *conn, uint64_t id,
+	       const char *name, uint64_t flags,
+	       uint64_t *offset)
+{
+	struct kdbus_cmd_info *cmd;
+	size_t size = sizeof(*cmd);
+	int ret;
+
+	if (name)
+		size += KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+
+	cmd = alloca(size);
+	memset(cmd, 0, size);
+	cmd->size = size;
+	cmd->flags = flags;
+
+	if (name) {
+		cmd->items[0].size = KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+		cmd->items[0].type = KDBUS_ITEM_NAME;
+		strcpy(cmd->items[0].str, name);
+	} else {
+		cmd->id = id;
+	}
+
+	ret = ioctl(conn->fd, KDBUS_CMD_CONN_INFO, cmd);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("--- error when requesting info: %d (%m)\n", ret);
+		return ret;
+	}
+
+	if (offset)
+		*offset = cmd->offset;
+	else
+		kdbus_free(conn, cmd->offset);
+
+	return 0;
+}
+
+void kdbus_conn_free(struct kdbus_conn *conn)
+{
+	if (!conn)
+		return;
+
+	if (conn->buf)
+		munmap(conn->buf, POOL_SIZE);
+
+	if (conn->fd >= 0)
+		close(conn->fd);
+
+	free(conn);
+}
+
+int sys_memfd_create(const char *name, __u64 size)
+{
+	int ret, fd;
+
+	ret = syscall(__NR_memfd_create, name, MFD_ALLOW_SEALING);
+	if (ret < 0)
+		return ret;
+
+	fd = ret;
+
+	ret = ftruncate(fd, size);
+	if (ret < 0) {
+		close(fd);
+		return ret;
+	}
+
+	return fd;
+}
+
+int sys_memfd_seal_set(int fd)
+{
+	return fcntl(fd, F_ADD_SEALS, F_SEAL_SHRINK |
+			 F_SEAL_GROW | F_SEAL_WRITE | F_SEAL_SEAL);
+}
+
+off_t sys_memfd_get_size(int fd, off_t *size)
+{
+	struct stat stat;
+	int ret;
+
+	ret = fstat(fd, &stat);
+	if (ret < 0) {
+		kdbus_printf("stat() failed: %m\n");
+		return ret;
+	}
+
+	*size = stat.st_size;
+	return 0;
+}
+
+int kdbus_msg_send(const struct kdbus_conn *conn,
+		   const char *name,
+		   uint64_t cookie,
+		   uint64_t flags,
+		   uint64_t timeout,
+		   int64_t priority,
+		   uint64_t dst_id)
+{
+	struct kdbus_msg *msg;
+	const char ref1[1024 * 128 + 3] = "0123456789_0";
+	const char ref2[] = "0123456789_1";
+	struct kdbus_item *item;
+	struct timespec now;
+	uint64_t size;
+	int memfd = -1;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	if (dst_id == KDBUS_DST_ID_BROADCAST)
+		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+	else {
+		memfd = sys_memfd_create("my-name-is-nice", 1024 * 1024);
+		if (memfd < 0) {
+			kdbus_printf("failed to create memfd: %m\n");
+			return memfd;
+		}
+
+		if (write(memfd, "kdbus memfd 1234567", 19) != 19) {
+			ret = -errno;
+			kdbus_printf("writing to memfd failed: %m\n");
+			return ret;
+		}
+
+		ret = sys_memfd_seal_set(memfd);
+		if (ret < 0) {
+			ret = -errno;
+			kdbus_printf("memfd sealing failed: %m\n");
+			return ret;
+		}
+
+		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+	}
+
+	if (name)
+		size += KDBUS_ITEM_SIZE(strlen(name) + 1);
+
+	msg = malloc(size);
+	if (!msg) {
+		ret = -errno;
+		kdbus_printf("unable to malloc()!?\n");
+		return ret;
+	}
+
+	memset(msg, 0, size);
+	msg->flags = flags;
+	msg->priority = priority;
+	msg->size = size;
+	msg->src_id = conn->id;
+	msg->dst_id = name ? 0 : dst_id;
+	msg->cookie = cookie;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+
+	if (timeout) {
+		ret = clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
+		if (ret < 0)
+			return ret;
+
+		msg->timeout_ns = now.tv_sec * 1000000000ULL +
+				  now.tv_nsec + timeout;
+	}
+
+	item = msg->items;
+
+	if (name) {
+		item->type = KDBUS_ITEM_DST_NAME;
+		item->size = KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+		strcpy(item->str, name);
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t)&ref1;
+	item->vec.size = sizeof(ref1);
+	item = KDBUS_ITEM_NEXT(item);
+
+	/* data padding for ref1 */
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t)NULL;
+	item->vec.size =  KDBUS_ALIGN8(sizeof(ref1)) - sizeof(ref1);
+	item = KDBUS_ITEM_NEXT(item);
+
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t)&ref2;
+	item->vec.size = sizeof(ref2);
+	item = KDBUS_ITEM_NEXT(item);
+
+	if (dst_id == KDBUS_DST_ID_BROADCAST) {
+		item->type = KDBUS_ITEM_BLOOM_FILTER;
+		item->size = KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+		item->bloom_filter.generation = 0;
+	} else {
+		item->type = KDBUS_ITEM_PAYLOAD_MEMFD;
+		item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_memfd);
+		item->memfd.size = 16;
+		item->memfd.fd = memfd;
+	}
+	item = KDBUS_ITEM_NEXT(item);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (memfd >= 0)
+		close(memfd);
+
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	if (flags & KDBUS_MSG_FLAGS_SYNC_REPLY) {
+		struct kdbus_msg *reply;
+
+		kdbus_printf("SYNC REPLY @offset %llu:\n", msg->offset_reply);
+		reply = (struct kdbus_msg *)(conn->buf + msg->offset_reply);
+		kdbus_msg_dump(conn, reply);
+
+		kdbus_msg_free(reply);
+
+		ret = kdbus_free(conn, msg->offset_reply);
+		if (ret < 0)
+			return ret;
+	}
+
+	free(msg);
+
+	return 0;
+}
+
+static char *msg_id(uint64_t id, char *buf)
+{
+	if (id == 0)
+		return "KERNEL";
+	if (id == ~0ULL)
+		return "BROADCAST";
+	sprintf(buf, "%llu", (unsigned long long)id);
+	return buf;
+}
+
+int kdbus_msg_dump(const struct kdbus_conn *conn, const struct kdbus_msg *msg)
+{
+	const struct kdbus_item *item = msg->items;
+	char buf_src[32];
+	char buf_dst[32];
+	uint64_t timeout = 0;
+	uint64_t cookie_reply = 0;
+	int ret = 0;
+
+	if (msg->flags & KDBUS_MSG_FLAGS_EXPECT_REPLY)
+		timeout = msg->timeout_ns;
+	else
+		cookie_reply = msg->cookie_reply;
+
+	kdbus_printf("MESSAGE: %s (%llu bytes) flags=0x%08llx, %s → %s, "
+		     "cookie=%llu, timeout=%llu cookie_reply=%llu priority=%lli\n",
+		enum_PAYLOAD(msg->payload_type), (unsigned long long)msg->size,
+		(unsigned long long)msg->flags,
+		msg_id(msg->src_id, buf_src), msg_id(msg->dst_id, buf_dst),
+		(unsigned long long)msg->cookie, (unsigned long long)timeout,
+		(unsigned long long)cookie_reply, (long long)msg->priority);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		if (item->size < KDBUS_ITEM_HEADER_SIZE) {
+			kdbus_printf("  +%s (%llu bytes) invalid data record\n",
+				     enum_MSG(item->type), item->size);
+			ret = -EINVAL;
+			break;
+		}
+
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_OFF: {
+			char *s;
+
+			if (item->vec.offset == ~0ULL)
+				s = "[\\0-bytes]";
+			else
+				s = (char *)msg + item->vec.offset;
+
+			kdbus_printf("  +%s (%llu bytes) off=%llu size=%llu '%s'\n",
+			       enum_MSG(item->type), item->size,
+			       (unsigned long long)item->vec.offset,
+			       (unsigned long long)item->vec.size, s);
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			char *buf;
+			off_t size;
+
+			buf = mmap(NULL, item->memfd.size, PROT_READ,
+				   MAP_PRIVATE, item->memfd.fd, 0);
+			if (buf == MAP_FAILED) {
+				kdbus_printf("mmap() fd=%i size=%llu failed: %m\n",
+					     item->memfd.fd, item->memfd.size);
+				break;
+			}
+
+			if (sys_memfd_get_size(item->memfd.fd, &size) < 0) {
+				kdbus_printf("KDBUS_CMD_MEMFD_SIZE_GET failed: %m\n");
+				break;
+			}
+
+			kdbus_printf("  +%s (%llu bytes) fd=%i size=%llu filesize=%llu '%s'\n",
+			       enum_MSG(item->type), item->size, item->memfd.fd,
+			       (unsigned long long)item->memfd.size,
+			       (unsigned long long)size, buf);
+			munmap(buf, item->memfd.size);
+			break;
+		}
+
+		case KDBUS_ITEM_CREDS:
+			kdbus_printf("  +%s (%llu bytes) uid=%lld, gid=%lld, pid=%lld, tid=%lld, starttime=%lld\n",
+				enum_MSG(item->type), item->size,
+				item->creds.uid, item->creds.gid,
+				item->creds.pid, item->creds.tid,
+				item->creds.starttime);
+			break;
+
+		case KDBUS_ITEM_AUXGROUPS: {
+			int i, n;
+
+			kdbus_printf("  +%s (%llu bytes)\n",
+				     enum_MSG(item->type), item->size);
+			n = (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(uint64_t);
+
+			for (i = 0; i < n; i++)
+				kdbus_printf("    gid[%d] = %lld\n",
+					     i, item->data64[i]);
+			break;
+		}
+
+		case KDBUS_ITEM_NAME:
+		case KDBUS_ITEM_PID_COMM:
+		case KDBUS_ITEM_TID_COMM:
+		case KDBUS_ITEM_EXE:
+		case KDBUS_ITEM_CGROUP:
+		case KDBUS_ITEM_SECLABEL:
+		case KDBUS_ITEM_DST_NAME:
+		case KDBUS_ITEM_CONN_DESCRIPTION:
+			kdbus_printf("  +%s (%llu bytes) '%s' (%zu)\n",
+				     enum_MSG(item->type), item->size,
+				     item->str, strlen(item->str));
+			break;
+
+		case KDBUS_ITEM_OWNED_NAME: {
+			kdbus_printf("  +%s (%llu bytes) '%s' (%zu) flags=0x%08llx\n",
+				     enum_MSG(item->type), item->size,
+				     item->name.name, strlen(item->name.name),
+				     item->name.flags);
+			break;
+		}
+
+		case KDBUS_ITEM_CMDLINE: {
+			size_t size = item->size - KDBUS_ITEM_HEADER_SIZE;
+			const char *str = item->str;
+			int count = 0;
+
+			kdbus_printf("  +%s (%llu bytes) ",
+				     enum_MSG(item->type), item->size);
+			while (size) {
+				kdbus_printf("'%s' ", str);
+				size -= strlen(str) + 1;
+				str += strlen(str) + 1;
+				count++;
+			}
+
+			kdbus_printf("(%d string%s)\n",
+				     count, (count == 1) ? "" : "s");
+			break;
+		}
+
+		case KDBUS_ITEM_AUDIT:
+			kdbus_printf("  +%s (%llu bytes) loginuid=%llu sessionid=%llu\n",
+			       enum_MSG(item->type), item->size,
+			       (unsigned long long)item->audit.loginuid,
+			       (unsigned long long)item->audit.sessionid);
+			break;
+
+		case KDBUS_ITEM_CAPS: {
+			const uint32_t *cap;
+			int n, i;
+
+			kdbus_printf("  +%s (%llu bytes) len=%llu bytes, last_cap %d\n",
+				     enum_MSG(item->type), item->size,
+				     (unsigned long long)item->size -
+					KDBUS_ITEM_HEADER_SIZE,
+				     (int) item->caps.last_cap);
+
+			cap = item->caps.caps;
+			n = (item->size - offsetof(struct kdbus_item, caps.caps))
+				/ 4 / sizeof(uint32_t);
+
+			kdbus_printf("    CapInh=");
+			for (i = 0; i < n; i++)
+				kdbus_printf("%08x", cap[(0 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapPrm=");
+			for (i = 0; i < n; i++)
+				kdbus_printf("%08x", cap[(1 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapEff=");
+			for (i = 0; i < n; i++)
+				kdbus_printf("%08x", cap[(2 * n) + (n - i - 1)]);
+
+			kdbus_printf(" CapBnd=");
+			for (i = 0; i < n; i++)
+				kdbus_printf("%08x", cap[(3 * n) + (n - i - 1)]);
+			kdbus_printf("\n");
+			break;
+		}
+
+		case KDBUS_ITEM_TIMESTAMP:
+			kdbus_printf("  +%s (%llu bytes) seq=%llu realtime=%lluns monotonic=%lluns\n",
+			       enum_MSG(item->type), item->size,
+			       (unsigned long long)item->timestamp.seqnum,
+			       (unsigned long long)item->timestamp.realtime_ns,
+			       (unsigned long long)item->timestamp.monotonic_ns);
+			break;
+
+		case KDBUS_ITEM_REPLY_TIMEOUT:
+			kdbus_printf("  +%s (%llu bytes) cookie=%llu\n",
+			       enum_MSG(item->type), item->size,
+			       msg->cookie_reply);
+			break;
+
+		case KDBUS_ITEM_NAME_ADD:
+		case KDBUS_ITEM_NAME_REMOVE:
+		case KDBUS_ITEM_NAME_CHANGE:
+			kdbus_printf("  +%s (%llu bytes) '%s', old id=%lld, now id=%lld, old_flags=0x%llx new_flags=0x%llx\n",
+				enum_MSG(item->type),
+				(unsigned long long) item->size,
+				item->name_change.name,
+				item->name_change.old_id.id,
+				item->name_change.new_id.id,
+				item->name_change.old_id.flags,
+				item->name_change.new_id.flags);
+			break;
+
+		case KDBUS_ITEM_ID_ADD:
+		case KDBUS_ITEM_ID_REMOVE:
+			kdbus_printf("  +%s (%llu bytes) id=%llu flags=%llu\n",
+			       enum_MSG(item->type),
+			       (unsigned long long) item->size,
+			       (unsigned long long) item->id_change.id,
+			       (unsigned long long) item->id_change.flags);
+			break;
+
+		default:
+			kdbus_printf("  +%s (%llu bytes)\n",
+				     enum_MSG(item->type), item->size);
+			break;
+		}
+	}
+
+	if ((char *)item - ((char *)msg + msg->size) >= 8) {
+		kdbus_printf("invalid padding at end of message\n");
+		ret = -EINVAL;
+	}
+
+	kdbus_printf("\n");
+
+	return ret;
+}
+
+void kdbus_msg_free(struct kdbus_msg *msg)
+{
+	const struct kdbus_item *item;
+	int nfds, i;
+
+	if (!msg)
+		return;
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		/* close all memfds */
+		case KDBUS_ITEM_PAYLOAD_MEMFD:
+			close(item->memfd.fd);
+			break;
+		case KDBUS_ITEM_FDS:
+			nfds = (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(int);
+
+			for (i = 0; i < nfds; i++)
+				close(item->fds[i]);
+
+			break;
+		}
+	}
+}
+
+int kdbus_msg_recv(struct kdbus_conn *conn,
+		   struct kdbus_msg **msg_out,
+		   uint64_t *offset)
+{
+	struct kdbus_cmd_recv recv = {};
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_RECV, &recv);
+	if (ret < 0) {
+		ret = -errno;
+		return ret;
+	}
+
+	msg = (struct kdbus_msg *)(conn->buf + recv.offset);
+	ret = kdbus_msg_dump(conn, msg);
+	if (ret < 0) {
+		kdbus_msg_free(msg);
+		return ret;
+	}
+
+	if (msg_out) {
+		*msg_out = msg;
+
+		if (offset)
+			*offset = recv.offset;
+	} else {
+		kdbus_msg_free(msg);
+
+		ret = kdbus_free(conn, recv.offset);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns: 0 on success, negative errno on failure.
+ *
+ * We must return -ETIMEDOUT, -ECONNREST, -EAGAIN and other errors.
+ * We must return the result of kdbus_msg_recv()
+ */
+int kdbus_msg_recv_poll(struct kdbus_conn *conn,
+			int timeout_ms,
+			struct kdbus_msg **msg_out,
+			uint64_t *offset)
+{
+	int ret;
+
+	do {
+		struct timeval before, after, diff;
+		struct pollfd fd;
+
+		fd.fd = conn->fd;
+		fd.events = POLLIN | POLLPRI | POLLHUP;
+		fd.revents = 0;
+
+		gettimeofday(&before, NULL);
+		ret = poll(&fd, 1, timeout_ms);
+		gettimeofday(&after, NULL);
+
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		if (ret > 0) {
+			if (fd.revents & POLLIN)
+				ret = kdbus_msg_recv(conn, msg_out, offset);
+
+			if (fd.revents & (POLLHUP | POLLERR))
+				ret = -ECONNRESET;
+		}
+
+		if (ret == 0 || ret != -EAGAIN)
+			break;
+
+		timersub(&after, &before, &diff);
+		timeout_ms -= diff.tv_sec * 1000UL +
+			      diff.tv_usec / 1000UL;
+	} while (timeout_ms > 0);
+
+	return ret;
+}
+
+int kdbus_free(const struct kdbus_conn *conn, uint64_t offset)
+{
+	struct kdbus_cmd_free cmd_free;
+	int ret;
+
+	cmd_free.offset = offset;
+	cmd_free.flags = 0;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_FREE, &cmd_free);
+	if (ret < 0) {
+		kdbus_printf("KDBUS_CMD_FREE failed: %d (%m)\n", ret);
+		return -errno;
+	}
+
+	return 0;
+}
+
+int kdbus_name_acquire(struct kdbus_conn *conn,
+		       const char *name, uint64_t *flags)
+{
+	struct kdbus_cmd_name *cmd_name;
+	size_t name_len = strlen(name) + 1;
+	uint64_t size = sizeof(*cmd_name) + KDBUS_ITEM_SIZE(name_len);
+	struct kdbus_item *item;
+	int ret;
+
+	cmd_name = alloca(size);
+
+	memset(cmd_name, 0, size);
+
+	item = cmd_name->items;
+	item->size = KDBUS_ITEM_HEADER_SIZE + name_len;
+	item->type = KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+
+	cmd_name->size = size;
+	if (flags)
+		cmd_name->flags = *flags;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_NAME_ACQUIRE, cmd_name);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error aquiring name: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	kdbus_printf("%s(): flags after call: 0x%llx\n", __func__,
+		     cmd_name->flags);
+
+	if (flags)
+		*flags = cmd_name->flags;
+
+	return 0;
+}
+
+int kdbus_name_release(struct kdbus_conn *conn, const char *name)
+{
+	struct kdbus_cmd_name *cmd_name;
+	size_t name_len = strlen(name) + 1;
+	uint64_t size = sizeof(*cmd_name) + KDBUS_ITEM_SIZE(name_len);
+	struct kdbus_item *item;
+	int ret;
+
+	cmd_name = alloca(size);
+
+	memset(cmd_name, 0, size);
+
+	item = cmd_name->items;
+	item->size = KDBUS_ITEM_HEADER_SIZE + name_len;
+	item->type = KDBUS_ITEM_NAME;
+	strcpy(item->str, name);
+
+	cmd_name->size = size;
+
+	kdbus_printf("conn %lld giving up name '%s'\n",
+		     (unsigned long long) conn->id, name);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_NAME_RELEASE, cmd_name);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error releasing name: %s\n", strerror(-ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_name_list(struct kdbus_conn *conn, uint64_t flags)
+{
+	struct kdbus_cmd_name_list cmd_list;
+	struct kdbus_name_list *list;
+	struct kdbus_name_info *name;
+	int ret;
+
+	cmd_list.flags = flags;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_NAME_LIST, &cmd_list);
+	if (ret < 0) {
+		kdbus_printf("error listing names: %d (%m)\n", ret);
+		return EXIT_FAILURE;
+	}
+
+	kdbus_printf("REGISTRY:\n");
+	list = (struct kdbus_name_list *)(conn->buf + cmd_list.offset);
+	KDBUS_ITEM_FOREACH(name, list, names) {
+		uint64_t flags = 0;
+		struct kdbus_item *item;
+		const char *n = "MISSING-NAME";
+
+		if (name->size == sizeof(struct kdbus_cmd_name))
+			continue;
+
+		KDBUS_ITEM_FOREACH(item, name, items)
+			if (item->type == KDBUS_ITEM_OWNED_NAME) {
+				n = item->name.name;
+				flags = item->name.flags;
+			}
+
+		kdbus_printf("%8llu flags=0x%08llx conn=0x%08llx '%s'\n",
+			     name->owner_id, (unsigned long long )flags,
+			     name->conn_flags, n);
+	}
+	kdbus_printf("\n");
+
+	ret = kdbus_free(conn, cmd_list.offset);
+
+	return ret;
+}
+
+int kdbus_conn_update_attach_flags(struct kdbus_conn *conn, uint64_t flags)
+{
+	int ret;
+	size_t size;
+	struct kdbus_cmd_update *update;
+	struct kdbus_item *item;
+
+	size = sizeof(struct kdbus_cmd_update);
+	size += KDBUS_ITEM_SIZE(sizeof(uint64_t));
+
+	update = malloc(size);
+	if (!update) {
+		ret = -errno;
+		kdbus_printf("error malloc: %d (%m)\n", ret);
+		return ret;
+	}
+
+	memset(update, 0, size);
+	update->size = size;
+
+	item = update->items;
+
+	item->type = KDBUS_ITEM_ATTACH_FLAGS_RECV;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(uint64_t);
+	item->data64[0] = flags;
+	item = KDBUS_ITEM_NEXT(item);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_CONN_UPDATE, update);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error conn update: %d (%m)\n", ret);
+	}
+
+	free(update);
+
+	return ret;
+}
+
+int kdbus_conn_update_policy(struct kdbus_conn *conn, const char *name,
+			     const struct kdbus_policy_access *access,
+			     size_t num_access)
+{
+	struct kdbus_cmd_update *update;
+	struct kdbus_item *item;
+	size_t i, size;
+	int ret;
+
+	size = sizeof(struct kdbus_cmd_update);
+	size += KDBUS_ITEM_SIZE(strlen(name) + 1);
+	size += num_access * KDBUS_ITEM_SIZE(sizeof(struct kdbus_policy_access));
+
+	update = malloc(size);
+	if (!update) {
+		ret = -errno;
+		kdbus_printf("error malloc: %d (%m)\n", ret);
+		return ret;
+	}
+
+	memset(update, 0, size);
+	update->size = size;
+
+	item = update->items;
+
+	item->type = KDBUS_ITEM_NAME;
+	item->size = KDBUS_ITEM_HEADER_SIZE + strlen(name) + 1;
+	strcpy(item->str, name);
+	item = KDBUS_ITEM_NEXT(item);
+
+	for (i = 0; i < num_access; i++) {
+		item->size = KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_policy_access);
+		item->type = KDBUS_ITEM_POLICY_ACCESS;
+
+		item->policy_access.type = access[i].type;
+		item->policy_access.access = access[i].access;
+		item->policy_access.id = access[i].id;
+
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	ret = ioctl(conn->fd, KDBUS_CMD_CONN_UPDATE, update);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error conn update: %d (%m)\n", ret);
+	}
+
+	free(update);
+
+	return ret;
+}
+
+int kdbus_add_match_empty(struct kdbus_conn *conn)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct kdbus_item item;
+	} buf;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+
+	buf.item.size = sizeof(uint64_t) * 3;
+	buf.item.type = KDBUS_ITEM_ID;
+	buf.item.id = KDBUS_MATCH_ID_ANY;
+
+	buf.cmd.size = sizeof(buf.cmd) + buf.item.size;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	if (ret < 0)
+		kdbus_printf("--- error adding conn match: %d (%m)\n", ret);
+
+	return ret;
+}
+
+int drop_privileges(uid_t uid, gid_t gid)
+{
+	int ret;
+
+	ret = setgroups(0, NULL);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error setgroups: %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret = setresgid(gid, gid, gid);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error setresgid: %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret = setresuid(uid, uid, uid);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error setresuid: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+uint64_t now(clockid_t clock)
+{
+	struct timespec spec;
+
+	clock_gettime(clock, &spec);
+	return spec.tv_sec * 1000ULL * 1000ULL * 1000ULL + spec.tv_nsec;
+}
+
+char *unique_name(const char *prefix)
+{
+	unsigned int i;
+	uint64_t u_now;
+	char n[17];
+	char *str;
+	int r;
+
+	/*
+	 * This returns a random string which is guaranteed to be
+	 * globally unique across all calls to unique_name(). We
+	 * compose the string as:
+	 *   <prefix>-<random>-<time>
+	 * With:
+	 *   <prefix>: string provided by the caller
+	 *   <random>: a random alpha string of 16 characters
+	 *   <time>: the current time in micro-seconds since last boot
+	 *
+	 * The <random> part makes the string always look vastly different,
+	 * the <time> part makes sure no two calls return the same string.
+	 */
+
+	u_now = now(CLOCK_MONOTONIC);
+
+	for (i = 0; i < sizeof(n) - 1; ++i)
+		n[i] = 'a' + (rand() % ('z' - 'a'));
+	n[sizeof(n) - 1] = 0;
+
+	r = asprintf(&str, "%s-%s-%" PRIu64, prefix, n, u_now);
+	if (r < 0)
+		return NULL;
+
+	return str;
+}
+
+static int do_userns_map_id(pid_t pid,
+			    const char *map_file,
+			    const char *map_id)
+{
+	int ret;
+	int fd;
+
+	fd = open(map_file, O_RDWR);
+	if (fd < 0) {
+		ret = -errno;
+		kdbus_printf("error open %s: %d (%m)\n",
+			map_file, ret);
+		return ret;
+	}
+
+	ret = write(fd, map_id, strlen(map_id));
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error write to %s: %d (%m)\n",
+			     map_file, ret);
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	close(fd);
+	return ret;
+}
+
+int userns_map_uid_gid(pid_t pid,
+		       const char *map_uid,
+		       const char *map_gid)
+{
+	int ret;
+	char file_id[128] = {'\0'};
+
+	snprintf(file_id, sizeof(file_id), "/proc/%ld/uid_map",
+		 (long) pid);
+
+	ret = do_userns_map_id(pid, file_id, map_uid);
+	if (ret < 0)
+		return ret;
+
+	snprintf(file_id, sizeof(file_id), "/proc/%ld/gid_map",
+		 (long) pid);
+
+	return do_userns_map_id(pid, file_id, map_gid);
+}
+
+static int do_cap_get_flag(cap_t caps, cap_value_t cap)
+{
+	int ret;
+	cap_flag_value_t flag_set;
+
+	ret = cap_get_flag(caps, cap, CAP_EFFECTIVE, &flag_set);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error cap_get_flag(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	return (flag_set == CAP_SET);
+}
+
+/*
+ * Returns:
+ *  1 in case all the requested effective capabilities are set.
+ *  0 in case we do not have the requested capabilities. This value
+ *    will be used to abort tests with TEST_SKIP
+ *  Negative errno on failure.
+ *
+ *  Terminate args with a negative value.
+ */
+int test_is_capable(int cap, ...)
+{
+	int ret;
+	va_list ap;
+	cap_t caps;
+
+	caps = cap_get_proc();
+	if (!cap) {
+		ret = -errno;
+		kdbus_printf("error cap_get_proc(): %d (%m)\n", ret);
+		return ret;
+	}
+
+	ret = do_cap_get_flag(caps, (cap_value_t)cap);
+	if (ret <= 0)
+		goto out;
+
+	va_start(ap, cap);
+	while ((cap = va_arg(ap, int)) > 0) {
+		ret = do_cap_get_flag(caps, (cap_value_t)cap);
+		if (ret <= 0)
+			break;
+	}
+	va_end(ap);
+
+out:
+	cap_free(caps);
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/kdbus-util.h b/tools/testing/selftests/kdbus/kdbus-util.h
new file mode 100644
index 000000000000..75f68dd32147
--- /dev/null
+++ b/tools/testing/selftests/kdbus/kdbus-util.h
@@ -0,0 +1,143 @@
+/*
+ * Copyright (C) 2013-2014 Kay Sievers
+ * Copyright (C) 2013-2014 Daniel Mack
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+#pragma once
+
+#define BIT(X) (1 << (X))
+
+#include <time.h>
+#include <linux/kdbus.h>
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+#define ELEMENTSOF(x) (sizeof(x)/sizeof((x)[0]))
+
+#define KDBUS_PTR(addr) ((void *)(uintptr_t)(addr))
+
+#define KDBUS_ALIGN8(l) (((l) + 7) & ~7)
+#define KDBUS_ITEM_HEADER_SIZE offsetof(struct kdbus_item, data)
+#define KDBUS_ITEM_SIZE(s) KDBUS_ALIGN8((s) + KDBUS_ITEM_HEADER_SIZE)
+
+#define KDBUS_ITEM_NEXT(item) \
+	(typeof(item))(((uint8_t *)item) + KDBUS_ALIGN8((item)->size))
+#define KDBUS_ITEM_FOREACH(item, head, first)				\
+	for (item = (head)->first;					\
+	     (uint8_t *)(item) < (uint8_t *)(head) + (head)->size;	\
+	     item = KDBUS_ITEM_NEXT(item))
+
+#define POOL_SIZE (16 * 1024LU * 1024LU)
+
+#define UNPRIV_UID 65534
+#define UNPRIV_GID 65534
+
+/* Dump as user of process, useful for user namespace testing */
+#define SUID_DUMP_USER	1
+
+extern int kdbus_util_verbose;
+
+#define kdbus_printf(X...) \
+	if (kdbus_util_verbose) \
+		printf(X)
+
+#define RUN_UNPRIVILEGED(child_uid, child_gid, _child_, _parent_) ({	\
+		pid_t pid, rpid;					\
+		int ret;						\
+									\
+		pid = fork();						\
+		if (pid == 0) {						\
+			ret = drop_privileges(child_uid, child_gid);	\
+			if (ret < 0)					\
+				_exit(ret);				\
+									\
+			_child_;					\
+			_exit(0);					\
+		} else if (pid > 0) {					\
+			_parent_;					\
+			rpid = waitpid(pid, &ret, 0);			\
+			ASSERT_RETURN(rpid == pid);			\
+			ASSERT_RETURN(WIFEXITED(ret));			\
+			ASSERT_RETURN(WEXITSTATUS(ret) == 0);		\
+			ret = TEST_OK;					\
+		} else {						\
+			ret = pid;					\
+		}							\
+									\
+		ret;							\
+	})
+
+#define RUN_UNPRIVILEGED_CONN(_var_, _bus_, _code_)			\
+	RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({			\
+		struct kdbus_conn *_var_;				\
+		_var_ = kdbus_hello(_bus_, 0, NULL, 0);			\
+		ASSERT_EXIT(_var_);					\
+		_code_;							\
+		kdbus_conn_free(_var_);					\
+	}), ({ 0; }))
+
+/* Enums for parent if it should drop privs or not */
+enum kdbus_drop_parent {
+	DO_NOT_DROP,
+	DROP_SAME_UNPRIV,
+	DROP_OTHER_UNPRIV,
+};
+
+struct kdbus_conn {
+	int fd;
+	uint64_t id;
+	void *buf;
+};
+
+int sys_memfd_create(const char *name, __u64 size);
+int sys_memfd_seal_set(int fd);
+off_t sys_memfd_get_size(int fd, off_t *size);
+
+int kdbus_name_list(struct kdbus_conn *conn, uint64_t flags);
+int kdbus_name_release(struct kdbus_conn *conn, const char *name);
+int kdbus_name_acquire(struct kdbus_conn *conn, const char *name,
+		       uint64_t *flags);
+void kdbus_msg_free(struct kdbus_msg *msg);
+int kdbus_msg_recv(struct kdbus_conn *conn,
+		   struct kdbus_msg **msg, uint64_t *offset);
+int kdbus_msg_recv_poll(struct kdbus_conn *conn, int timeout_ms,
+			struct kdbus_msg **msg_out, uint64_t *offset);
+int kdbus_free(const struct kdbus_conn *conn, uint64_t offset);
+int kdbus_msg_dump(const struct kdbus_conn *conn,
+		   const struct kdbus_msg *msg);
+int kdbus_create_bus(int control_fd, const char *name, uint64_t req_meta,
+		     char **path);
+int kdbus_msg_send(const struct kdbus_conn *conn, const char *name,
+		   uint64_t cookie, uint64_t flags, uint64_t timeout,
+		   int64_t priority, uint64_t dst_id);
+struct kdbus_conn *kdbus_hello(const char *path, uint64_t hello_flags,
+			       const struct kdbus_item *item,
+			       size_t item_size);
+struct kdbus_conn *kdbus_hello_registrar(const char *path, const char *name,
+					 const struct kdbus_policy_access *access,
+					 size_t num_access, uint64_t flags);
+struct kdbus_conn *kdbus_hello_activator(const char *path, const char *name,
+					 const struct kdbus_policy_access *access,
+					 size_t num_access);
+int kdbus_info(struct kdbus_conn *conn, uint64_t id,
+	       const char *name, uint64_t flags, uint64_t *offset);
+void kdbus_conn_free(struct kdbus_conn *conn);
+int kdbus_conn_update_attach_flags(struct kdbus_conn *conn, uint64_t flags);
+int kdbus_conn_update_policy(struct kdbus_conn *conn, const char *name,
+			     const struct kdbus_policy_access *access,
+			     size_t num_access);
+
+int kdbus_add_match_empty(struct kdbus_conn *conn);
+
+int drop_privileges(uid_t uid, gid_t gid);
+uint64_t now(clockid_t clock);
+char *unique_name(const char *prefix);
+
+int userns_map_uid_gid(pid_t pid,
+		       const char *map_uid,
+		       const char *map_gid);
+int test_is_capable(int cap, ...);
diff --git a/tools/testing/selftests/kdbus/test-activator.c b/tools/testing/selftests/kdbus/test-activator.c
new file mode 100644
index 000000000000..8c7346591d4b
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-activator.c
@@ -0,0 +1,317 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/capability.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static int kdbus_starter_poll(struct kdbus_conn *conn)
+{
+	int ret;
+	struct pollfd fd;
+
+	fd.fd = conn->fd;
+	fd.events = POLLIN | POLLPRI | POLLHUP;
+	fd.revents = 0;
+
+	ret = poll(&fd, 1, 100);
+	if (ret == 0)
+		return -ETIMEDOUT;
+	else if (ret > 0) {
+		if (fd.revents & POLLIN)
+			return 0;
+
+		if (fd.revents & (POLLHUP | POLLERR))
+			ret = -ECONNRESET;
+	}
+
+	return ret;
+}
+
+/* Ensure that kdbus activator logic is safe */
+static int kdbus_priv_activator(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_msg *msg = NULL;
+	uint64_t cookie = 0xdeadbeef;
+	uint64_t flags = KDBUS_NAME_REPLACE_EXISTING;
+	struct kdbus_conn *activator;
+	struct kdbus_conn *service;
+	struct kdbus_conn *client;
+	struct kdbus_conn *holder;
+	struct kdbus_policy_access *access;
+
+	access = (struct kdbus_policy_access[]){
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = getuid(),
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = getuid(),
+			.access = KDBUS_POLICY_TALK,
+		},
+	};
+
+	activator = kdbus_hello_activator(env->buspath, "foo.priv.activator",
+					  access, 2);
+	ASSERT_RETURN(activator);
+
+	service = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(service);
+
+	client = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(client);
+
+	/*
+	 * Make sure that other users can't TALK to the activator
+	 */
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk using the ID */
+		ret = kdbus_msg_send(unpriv, NULL, 0xdeadbeef, 0, 0,
+				     0, activator->id);
+		ASSERT_EXIT(ret == -ENXIO);
+
+		/* Try to talk to the name */
+		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
+				     0xdeadbeef, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure that we did not receive anything, so the
+	 * service will not be started automatically
+	 */
+
+	ret = kdbus_starter_poll(activator);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	/*
+	 * Now try to emulate the starter/service logic and
+	 * acquire the name.
+	 */
+
+	cookie++;
+	ret = kdbus_msg_send(service, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_starter_poll(activator);
+	ASSERT_RETURN(ret == 0);
+
+	/* Policies are still checked, access denied */
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "foo.priv.activator",
+					 &flags);
+		ASSERT_RETURN(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_name_acquire(service, "foo.priv.activator",
+				 &flags);
+	ASSERT_RETURN(ret == 0);
+
+	/* We read our previous starter message */
+
+	ret = kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* Try to talk, we still fail */
+
+	cookie++;
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/* Still nothing to read */
+
+	ret = kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	/* We receive every thing now */
+
+	cookie++;
+	ret = kdbus_msg_send(client, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_recv_poll(service, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(service, msg->offset_reply);
+
+	/* Policies default to deny TALK now */
+	kdbus_conn_free(activator);
+
+	cookie++;
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	/* Same user is able to TALK */
+	cookie++;
+	ret = kdbus_msg_send(client, "foo.priv.activator", cookie,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret == 0);
+	ret = kdbus_msg_recv_poll(service, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(service, msg->offset_reply);
+
+	access = (struct kdbus_policy_access []){
+		{
+			.type = KDBUS_POLICY_ACCESS_WORLD,
+			.id = getuid(),
+			.access = KDBUS_POLICY_TALK,
+		},
+	};
+
+	holder = kdbus_hello_registrar(env->buspath, "foo.priv.activator",
+				       access, 1, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder);
+
+	/* Now we are able to TALK to the name */
+
+	cookie++;
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		/* Try to talk to the name */
+		ret = kdbus_msg_send(unpriv, "foo.priv.activator",
+				     cookie, 0, 0, 0,
+				     KDBUS_DST_ID_NAME);
+		ASSERT_EXIT(ret == 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(service, 100, NULL, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "foo.priv.activator",
+					 &flags);
+		ASSERT_RETURN(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	kdbus_conn_free(service);
+	kdbus_conn_free(client);
+	kdbus_conn_free(holder);
+
+	return 0;
+}
+
+int kdbus_test_activator(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_conn *activator;
+	struct pollfd fds[2];
+	bool activator_done = false;
+	struct kdbus_policy_access access[2];
+
+	access[0].type = KDBUS_POLICY_ACCESS_USER;
+	access[0].id = 1001;
+	access[0].access = KDBUS_POLICY_OWN;
+
+	access[1].type = KDBUS_POLICY_ACCESS_WORLD;
+	access[1].access = KDBUS_POLICY_TALK;
+
+	activator = kdbus_hello_activator(env->buspath, "foo.test.activator",
+					  access, 2);
+	ASSERT_RETURN(activator);
+
+	ret = kdbus_add_match_empty(env->conn);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_list(env->conn, KDBUS_NAME_LIST_NAMES |
+					 KDBUS_NAME_LIST_UNIQUE |
+					 KDBUS_NAME_LIST_ACTIVATORS |
+					 KDBUS_NAME_LIST_QUEUED);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_send(env->conn, "foo.test.activator", 0xdeafbeef,
+			     0, 0, 0, KDBUS_DST_ID_NAME);
+	ASSERT_RETURN(ret == 0);
+
+	fds[0].fd = activator->fd;
+	fds[1].fd = env->conn->fd;
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	for (;;) {
+		int i, nfds = sizeof(fds) / sizeof(fds[0]);
+
+		for (i = 0; i < nfds; i++) {
+			fds[i].events = POLLIN | POLLPRI;
+			fds[i].revents = 0;
+		}
+
+		ret = poll(fds, nfds, 3000);
+		ASSERT_RETURN(ret >= 0);
+
+		ret = kdbus_name_list(env->conn, KDBUS_NAME_LIST_NAMES);
+		ASSERT_RETURN(ret == 0);
+
+		if ((fds[0].revents & POLLIN) && !activator_done) {
+			uint64_t flags = KDBUS_NAME_REPLACE_EXISTING;
+
+			kdbus_printf("Starter was called back!\n");
+
+			ret = kdbus_name_acquire(env->conn,
+						 "foo.test.activator", &flags);
+			ASSERT_RETURN(ret == 0);
+
+			activator_done = true;
+		}
+
+		if (fds[1].revents & POLLIN) {
+			kdbus_msg_recv(env->conn, NULL, NULL);
+			break;
+		}
+	}
+
+	/* Check now capabilities, so we run the previous tests */
+	ret = test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >= 0);
+
+	if (!ret)
+		return TEST_SKIP;
+
+	ret = kdbus_priv_activator(env);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(activator);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-benchmark.c b/tools/testing/selftests/kdbus/test-benchmark.c
new file mode 100644
index 000000000000..849e43dac57b
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-benchmark.c
@@ -0,0 +1,409 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <locale.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/time.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define SERVICE_NAME "foo.bar.echo"
+
+/*
+ * To have a banchmark comparison with unix socket, set:
+ * user_memfd	= false;
+ * compare_uds	= true;
+ * attach_none	= true;		do not attached metadata
+ */
+
+static const bool use_memfd = true;		/* transmit memfd? */
+static const bool compare_uds = false;		/* unix-socket comparison? */
+static const bool attach_none = false;		/* clear attach-flags? */
+static char stress_payload[8192];
+
+struct stats {
+	uint64_t count;
+	uint64_t latency_acc;
+	uint64_t latency_low;
+	uint64_t latency_high;
+};
+
+static struct stats stats;
+
+static void reset_stats(void)
+{
+	stats.count = 0;
+	stats.latency_acc = 0;
+	stats.latency_low = UINT64_MAX;
+	stats.latency_high = 0;
+}
+
+static void dump_stats(bool is_uds)
+{
+	if (stats.count > 0) {
+		kdbus_printf("stats %s: %'llu packets processed, latency (nsecs) min/max/avg %'7llu // %'7llu // %'7llu\n",
+			     is_uds ? " (UNIX)" : "(KDBUS)",
+			     (unsigned long long) stats.count,
+			     (unsigned long long) stats.latency_low,
+			     (unsigned long long) stats.latency_high,
+			     (unsigned long long) (stats.latency_acc / stats.count));
+	} else {
+		kdbus_printf("*** no packets received. bus stuck?\n");
+	}
+}
+
+static void add_stats(uint64_t prev)
+{
+	uint64_t diff;
+
+	diff = now(CLOCK_THREAD_CPUTIME_ID) - prev;
+
+	stats.count++;
+	stats.latency_acc += diff;
+	if (stats.latency_low > diff)
+		stats.latency_low = diff;
+
+	if (stats.latency_high < diff)
+		stats.latency_high = diff;
+}
+
+static int setup_simple_kdbus_msg(struct kdbus_conn *conn,
+				  uint64_t dst_id,
+				  struct kdbus_msg **msg_out)
+{
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg = malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size = size;
+	msg->src_id = conn->id;
+	msg->dst_id = dst_id;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+
+	item = msg->items;
+
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t) stress_payload;
+	item->vec.size = sizeof(stress_payload);
+	item = KDBUS_ITEM_NEXT(item);
+
+	*msg_out = msg;
+
+	return 0;
+}
+
+static int setup_memfd_kdbus_msg(struct kdbus_conn *conn,
+				 uint64_t dst_id,
+				 off_t *memfd_item_offset,
+				 struct kdbus_msg **msg_out)
+{
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+
+	msg = malloc(size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, size);
+	msg->size = size;
+	msg->src_id = conn->id;
+	msg->dst_id = dst_id;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+
+	item = msg->items;
+
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t) stress_payload;
+	item->vec.size = sizeof(stress_payload);
+	item = KDBUS_ITEM_NEXT(item);
+
+	item->type = KDBUS_ITEM_PAYLOAD_MEMFD;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_memfd);
+	item->memfd.size = sizeof(uint64_t);
+
+	*memfd_item_offset = (unsigned char *)item - (unsigned char *)msg;
+	*msg_out = msg;
+
+	return 0;
+}
+
+static int
+send_echo_request(struct kdbus_conn *conn, uint64_t dst_id,
+		  void *kdbus_msg, off_t memfd_item_offset)
+{
+	int memfd = -1;
+	int ret;
+
+	if (use_memfd) {
+		uint64_t now_ns = now(CLOCK_THREAD_CPUTIME_ID);
+		struct kdbus_item *item = memfd_item_offset + kdbus_msg;
+		memfd = sys_memfd_create("memfd-name", 0);
+		ASSERT_RETURN_VAL(memfd >= 0, memfd);
+
+		ret = write(memfd, &now_ns, sizeof(now_ns));
+		ASSERT_RETURN_VAL(ret == sizeof(now_ns), -EAGAIN);
+
+		ret = sys_memfd_seal_set(memfd);
+		ASSERT_RETURN_VAL(ret == 0, -errno);
+
+		item->memfd.fd = memfd;
+	}
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, kdbus_msg);
+	ASSERT_RETURN_VAL(ret == 0, -errno);
+
+	close(memfd);
+
+	return 0;
+}
+
+static int
+handle_echo_reply(struct kdbus_conn *conn, uint64_t send_ns)
+{
+	int ret;
+	struct kdbus_cmd_recv recv = {};
+	struct kdbus_msg *msg;
+	const struct kdbus_item *item;
+	bool has_memfd = false;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_RECV, &recv);
+	if (ret < 0 && errno == EAGAIN)
+		return -EAGAIN;
+
+	ASSERT_RETURN_VAL(ret == 0, -errno);
+
+	if (!use_memfd)
+		goto out;
+
+	msg = (struct kdbus_msg *)(conn->buf + recv.offset);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		case KDBUS_ITEM_PAYLOAD_MEMFD: {
+			char *buf;
+
+			buf = mmap(NULL, item->memfd.size, PROT_READ,
+				   MAP_PRIVATE, item->memfd.fd, 0);
+			ASSERT_RETURN_VAL(buf != MAP_FAILED, -EINVAL);
+			ASSERT_RETURN_VAL(item->memfd.size == sizeof(uint64_t),
+					  -EINVAL);
+
+			add_stats(*(uint64_t*)buf);
+			munmap(buf, item->memfd.size);
+			close(item->memfd.fd);
+			has_memfd = true;
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_OFF:
+			/* ignore */
+			break;
+		}
+	}
+
+out:
+	if (!has_memfd)
+		add_stats(send_ns);
+
+	ret = kdbus_free(conn, recv.offset);
+	ASSERT_RETURN_VAL(ret == 0, -errno);
+
+	return 0;
+}
+
+int kdbus_test_benchmark(struct kdbus_test_env *env)
+{
+	static char buf[sizeof(stress_payload)];
+	struct kdbus_msg *kdbus_msg = NULL;
+	off_t memfd_cached_offset = 0;
+	int ret;
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fds[2];
+	uint64_t start, send_ns, now_ns, diff;
+	unsigned int i;
+	int uds[2];
+
+	setlocale(LC_ALL, "");
+
+	for (i = 0; i < sizeof(stress_payload); i++)
+		stress_payload[i] = i;
+
+	/* setup kdbus pair */
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	ret = kdbus_add_match_empty(conn_a);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_add_match_empty(conn_b);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(conn_a, SERVICE_NAME, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	if (attach_none) {
+		ret = kdbus_conn_update_attach_flags(conn_a, 0);
+		ASSERT_RETURN(ret == 0);
+	}
+
+	/* setup UDS pair */
+
+	ret = socketpair(AF_UNIX, SOCK_SEQPACKET | SOCK_NONBLOCK, 0, uds);
+	ASSERT_RETURN(ret == 0);
+
+	/* setup a kdbus msg now */
+	if (use_memfd) {
+		ret = setup_memfd_kdbus_msg(conn_b, conn_a->id,
+					    &memfd_cached_offset,
+					    &kdbus_msg);
+		ASSERT_RETURN(ret == 0);
+	} else {
+		ret = setup_simple_kdbus_msg(conn_b, conn_a->id, &kdbus_msg);
+		ASSERT_RETURN(ret == 0);
+	}
+
+	/* start benchmark */
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	do {
+		/* run kdbus benchmark */
+		fds[0].fd = conn_a->fd;
+		fds[1].fd = conn_b->fd;
+
+		/* cancel any pending message */
+		handle_echo_reply(conn_a, 0);
+
+		start = now(CLOCK_THREAD_CPUTIME_ID);
+		reset_stats();
+
+		send_ns = now(CLOCK_THREAD_CPUTIME_ID);
+		ret = send_echo_request(conn_b, conn_a->id,
+					kdbus_msg, memfd_cached_offset);
+		ASSERT_RETURN(ret == 0);
+
+		while (1) {
+			unsigned int nfds = sizeof(fds) / sizeof(fds[0]);
+			unsigned int i;
+
+			for (i = 0; i < nfds; i++) {
+				fds[i].events = POLLIN | POLLPRI | POLLHUP;
+				fds[i].revents = 0;
+			}
+
+			ret = poll(fds, nfds, 10);
+			if (ret < 0)
+				break;
+
+			if (fds[0].revents & POLLIN) {
+				ret = handle_echo_reply(conn_a, send_ns);
+				ASSERT_RETURN(ret == 0);
+
+				send_ns = now(CLOCK_THREAD_CPUTIME_ID);
+				ret = send_echo_request(conn_b, conn_a->id,
+							kdbus_msg,
+							memfd_cached_offset);
+				ASSERT_RETURN(ret == 0);
+			}
+
+			now_ns = now(CLOCK_THREAD_CPUTIME_ID);
+			diff = now_ns - start;
+			if (diff > 1000000000ULL) {
+				start = now_ns;
+
+				dump_stats(false);
+				break;
+			}
+		}
+
+		if (!compare_uds)
+			continue;
+
+		/* run unix-socket benchmark as comparison */
+
+		fds[0].fd = uds[0];
+		fds[1].fd = uds[1];
+
+		/* cancel any pendign message */
+		read(uds[1], buf, sizeof(buf));
+
+		start = now(CLOCK_THREAD_CPUTIME_ID);
+		reset_stats();
+
+		send_ns = now(CLOCK_THREAD_CPUTIME_ID);
+		ret = write(uds[0], stress_payload, sizeof(stress_payload));
+		ASSERT_RETURN(ret == sizeof(stress_payload));
+
+		while (1) {
+			unsigned int nfds = sizeof(fds) / sizeof(fds[0]);
+			unsigned int i;
+
+			for (i = 0; i < nfds; i++) {
+				fds[i].events = POLLIN | POLLPRI | POLLHUP;
+				fds[i].revents = 0;
+			}
+
+			ret = poll(fds, nfds, 10);
+			if (ret < 0)
+				break;
+
+			if (fds[1].revents & POLLIN) {
+				ret = read(uds[1], buf, sizeof(buf));
+				ASSERT_RETURN(ret == sizeof(buf));
+
+				add_stats(send_ns);
+
+				send_ns = now(CLOCK_THREAD_CPUTIME_ID);
+				ret = write(uds[0], buf, sizeof(buf));
+				ASSERT_RETURN(ret == sizeof(buf));
+			}
+
+			now_ns = now(CLOCK_THREAD_CPUTIME_ID);
+			diff = now_ns - start;
+			if (diff > 1000000000ULL) {
+				start = now_ns;
+
+				dump_stats(true);
+				break;
+			}
+		}
+
+	} while (kdbus_util_verbose);
+
+	kdbus_printf("-- closing bus connections\n");
+
+	free(kdbus_msg);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return (stats.count > 1) ? TEST_OK : TEST_ERR;
+}
diff --git a/tools/testing/selftests/kdbus/test-bus.c b/tools/testing/selftests/kdbus/test-bus.c
new file mode 100644
index 000000000000..86e9fefe6d4a
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-bus.c
@@ -0,0 +1,130 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static int test_bus_creator_info(const char *bus_path)
+{
+	int ret;
+	struct kdbus_conn *conn;
+	struct kdbus_cmd_info cmd = {};
+
+	cmd.size = sizeof(cmd);
+
+	conn = kdbus_hello(bus_path, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_BUS_CREATOR_INFO, &cmd);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	ret = kdbus_free(conn, cmd.offset);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	return 0;
+}
+
+int kdbus_test_bus_make(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_make head;
+
+		/* bloom size item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_bloom_parameter bloom;
+		} bs;
+
+		/* name item */
+		uint64_t n_size;
+		uint64_t n_type;
+		char name[64];
+	} bus_make;
+	char s[PATH_MAX], *name;
+	int ret, control_fd2;
+	uid_t uid;
+
+	name = unique_name("");
+	ASSERT_RETURN(name);
+
+	snprintf(s, sizeof(s), "%s/control", env->root);
+	env->control_fd = open(s, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(env->control_fd >= 0);
+
+	control_fd2 = open(s, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(control_fd2 >= 0);
+
+	memset(&bus_make, 0, sizeof(bus_make));
+
+	bus_make.bs.size = sizeof(bus_make.bs);
+	bus_make.bs.type = KDBUS_ITEM_BLOOM_PARAMETER;
+	bus_make.bs.bloom.size = 64;
+	bus_make.bs.bloom.n_hash = 1;
+
+	bus_make.n_type = KDBUS_ITEM_MAKE_NAME;
+
+	uid = getuid();
+
+	/* missing uid prefix */
+	snprintf(bus_make.name, sizeof(bus_make.name), "foo");
+	bus_make.n_size = KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + 1;
+	bus_make.head.size = sizeof(struct kdbus_cmd_make) +
+			     sizeof(bus_make.bs) + bus_make.n_size;
+	ret = ioctl(env->control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	/* non alphanumeric character */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-blah@123", uid);
+	bus_make.n_size = KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + 1;
+	bus_make.head.size = sizeof(struct kdbus_cmd_make) +
+			     sizeof(bus_make.bs) + bus_make.n_size;
+	ret = ioctl(env->control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	/* '-' at the end */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-blah-", uid);
+	bus_make.n_size = KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + 1;
+	bus_make.head.size = sizeof(struct kdbus_cmd_make) +
+			     sizeof(bus_make.bs) + bus_make.n_size;
+	ret = ioctl(env->control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	/* create a new bus */
+	snprintf(bus_make.name, sizeof(bus_make.name), "%u-%s-1", uid, name);
+	bus_make.n_size = KDBUS_ITEM_HEADER_SIZE + strlen(bus_make.name) + 1;
+	bus_make.head.size = sizeof(struct kdbus_cmd_make) +
+			     sizeof(bus_make.bs) + bus_make.n_size;
+	ret = ioctl(env->control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == 0);
+
+	ret = ioctl(control_fd2, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == -1 && errno == EEXIST);
+
+	snprintf(s, sizeof(s), "%s/%u-%s-1/bus", env->root, uid, name);
+	ASSERT_RETURN(access(s, F_OK) == 0);
+
+	ret = test_bus_creator_info(s);
+	ASSERT_RETURN(ret == 0);
+
+	/* can't use the same fd for bus make twice */
+	ret = ioctl(env->control_fd, KDBUS_CMD_BUS_MAKE, &bus_make);
+	ASSERT_RETURN(ret == -1 && errno == EBADFD);
+
+	close(control_fd2);
+	free(name);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-chat.c b/tools/testing/selftests/kdbus/test-chat.c
new file mode 100644
index 000000000000..6a0efbcc3846
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-chat.c
@@ -0,0 +1,123 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_chat(struct kdbus_test_env *env)
+{
+	int ret, cookie;
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fds[2];
+	uint64_t flags;
+	int count;
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	flags = KDBUS_NAME_ALLOW_REPLACEMENT;
+	ret = kdbus_name_acquire(conn_a, "foo.bar.test", &flags);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(conn_a, "foo.bar.baz", NULL);
+	ASSERT_RETURN(ret == 0);
+
+	flags = KDBUS_NAME_QUEUE;
+	ret = kdbus_name_acquire(conn_b, "foo.bar.baz", &flags);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(conn_a, "foo.bar.double", NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(conn_a, "foo.bar.double", NULL);
+	ASSERT_RETURN(ret == -EALREADY);
+
+	ret = kdbus_name_release(conn_a, "foo.bar.double");
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_release(conn_a, "foo.bar.double");
+	ASSERT_RETURN(ret == -ESRCH);
+
+	ret = kdbus_name_list(conn_b, KDBUS_NAME_LIST_UNIQUE |
+				      KDBUS_NAME_LIST_NAMES  |
+				      KDBUS_NAME_LIST_QUEUED |
+				      KDBUS_NAME_LIST_ACTIVATORS);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_add_match_empty(conn_a);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_add_match_empty(conn_b);
+	ASSERT_RETURN(ret == 0);
+
+	cookie = 0;
+	ret = kdbus_msg_send(conn_b, NULL, 0xc0000000 | cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	fds[0].fd = conn_a->fd;
+	fds[1].fd = conn_b->fd;
+
+	kdbus_printf("-- entering poll loop ...\n");
+
+	for (count = 0;; count++) {
+		int i, nfds = sizeof(fds) / sizeof(fds[0]);
+
+		for (i = 0; i < nfds; i++) {
+			fds[i].events = POLLIN | POLLPRI | POLLHUP;
+			fds[i].revents = 0;
+		}
+
+		ret = poll(fds, nfds, 3000);
+		ASSERT_RETURN(ret >= 0);
+
+		if (fds[0].revents & POLLIN) {
+			if (count > 2)
+				kdbus_name_release(conn_a, "foo.bar.baz");
+
+			ret = kdbus_msg_recv(conn_a, NULL, NULL);
+			ASSERT_RETURN(ret == 0);
+			ret = kdbus_msg_send(conn_a, NULL,
+					     0xc0000000 | cookie++,
+					     0, 0, 0, conn_b->id);
+			ASSERT_RETURN(ret == 0);
+		}
+
+		if (fds[1].revents & POLLIN) {
+			ret = kdbus_msg_recv(conn_b, NULL, NULL);
+			ASSERT_RETURN(ret == 0);
+			ret = kdbus_msg_send(conn_b, NULL,
+					     0xc0000000 | cookie++,
+					     0, 0, 0, conn_a->id);
+			ASSERT_RETURN(ret == 0);
+		}
+
+		ret = kdbus_name_list(conn_b, KDBUS_NAME_LIST_UNIQUE |
+					      KDBUS_NAME_LIST_NAMES  |
+					      KDBUS_NAME_LIST_QUEUED |
+					      KDBUS_NAME_LIST_ACTIVATORS);
+		ASSERT_RETURN(ret == 0);
+
+		if (count > 10)
+			break;
+	}
+
+	kdbus_printf("-- closing bus connections\n");
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-connection.c b/tools/testing/selftests/kdbus/test-connection.c
new file mode 100644
index 000000000000..a21b6a581408
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-connection.c
@@ -0,0 +1,501 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/capability.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_hello(struct kdbus_test_env *env)
+{
+	struct kdbus_cmd_hello hello;
+	int fd, ret;
+
+	memset(&hello, 0, sizeof(hello));
+
+	fd = open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(fd >= 0);
+
+	hello.flags = KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	hello.attach_flags_recv = _KDBUS_ATTACH_ALL;
+	hello.size = sizeof(struct kdbus_cmd_hello);
+	hello.pool_size = POOL_SIZE;
+
+	/* an unaligned hello must result in -EFAULT */
+	ret = ioctl(fd, KDBUS_CMD_HELLO, (char *) &hello + 1);
+	ASSERT_RETURN(ret == -1 && errno == EFAULT);
+
+	/* a size of 0 must return EMSGSIZE */
+	hello.size = 1;
+	hello.flags = KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	hello.size = sizeof(struct kdbus_cmd_hello);
+
+	/* check faulty flags */
+	hello.flags = 1ULL << 32;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	/* kernel must have set its bit in the ioctl buffer */
+	ASSERT_RETURN(hello.kernel_flags & KDBUS_FLAG_KERNEL);
+
+	/* check for faulty pool sizes */
+	hello.pool_size = 0;
+	hello.flags = KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == EFAULT);
+
+	hello.pool_size = 4097;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == EFAULT);
+
+	hello.pool_size = POOL_SIZE;
+
+	/*
+	 * The connection created by the core requires ALL meta flags
+	 * to be sent. An attempt to send less that that should result
+	 * in -ECONNREFUSED.
+	 */
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL & ~KDBUS_ATTACH_TIMESTAMP;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == ECONNREFUSED);
+
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+
+	/* success test */
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == 0);
+
+	/* The kernel should have set KDBUS_FLAG_KERNEL */
+	ASSERT_RETURN(hello.attach_flags_send & KDBUS_FLAG_KERNEL);
+
+	close(fd);
+
+	fd = open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(fd >= 0);
+
+	/* no ACTIVATOR flag without a name */
+	hello.flags = KDBUS_HELLO_ACTIVATOR;
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	close(fd);
+
+	return TEST_OK;
+}
+
+int kdbus_test_byebye(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_cmd_recv recv = {};
+	int ret;
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	ret = kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_add_match_empty(env->conn);
+	ASSERT_RETURN(ret == 0);
+
+	/* send over 1st connection */
+	ret = kdbus_msg_send(env->conn, NULL, 0, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	/* say byebye on the 2nd, which must fail */
+	ret = ioctl(conn->fd, KDBUS_CMD_BYEBYE, 0);
+	ASSERT_RETURN(ret == -1 && errno == EBUSY);
+
+	/* receive the message */
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_RECV, &recv);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_free(conn, recv.offset);
+	ASSERT_RETURN(ret == 0);
+
+	/* and try again */
+	ret = ioctl(conn->fd, KDBUS_CMD_BYEBYE, 0);
+	ASSERT_RETURN(ret == 0);
+
+	/* a 2nd try should result in -EALREADY */
+	ret = ioctl(conn->fd, KDBUS_CMD_BYEBYE, 0);
+	ASSERT_RETURN(ret == -1 && errno == EALREADY);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+/* Get only the first item */
+static struct kdbus_item *kdbus_get_item(struct kdbus_info *info,
+					 uint64_t type)
+{
+	struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		if (item->type == type)
+			return item;
+
+	return NULL;
+}
+
+static unsigned int kdbus_count_item(struct kdbus_info *info,
+				     uint64_t type)
+{
+	unsigned int i = 0;
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, info, items)
+		if (item->type == type)
+			i++;
+
+	return i;
+}
+
+static int kdbus_fuzz_conn_info(struct kdbus_test_env *env)
+{
+	int ret;
+	unsigned int cnt = 0;
+	uint64_t offset = 0;
+	struct kdbus_info *info;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *privileged;
+	const struct kdbus_item *item;
+	uint64_t valid_flags = KDBUS_ATTACH_NAMES |
+			       KDBUS_ATTACH_CREDS |
+			       KDBUS_ATTACH_CONN_DESCRIPTION;
+
+	uint64_t invalid_flags = KDBUS_ATTACH_NAMES	|
+				 KDBUS_ATTACH_CREDS	|
+				 KDBUS_ATTACH_CAPS	|
+				 KDBUS_ATTACH_CGROUP	|
+				 KDBUS_ATTACH_CONN_DESCRIPTION;
+
+	struct kdbus_creds cached_creds = {
+		.uid	= getuid(),
+		.gid	= getgid(),
+		.pid	= getpid(),
+		.tid	= syscall(SYS_gettid),
+	};
+
+	ret = kdbus_info(env->conn, env->conn->id, NULL,
+			 valid_flags, &offset);
+	ASSERT_RETURN(ret == 0);
+
+	info = (struct kdbus_info *)(env->conn->buf + offset);
+	ASSERT_RETURN(info->id == env->conn->id);
+
+	/* We do not have any well-known name */
+	item = kdbus_get_item(info, KDBUS_ITEM_NAME);
+	ASSERT_RETURN(item == NULL);
+
+	item = kdbus_get_item(info, KDBUS_ITEM_CONN_DESCRIPTION);
+	ASSERT_RETURN(item);
+
+	kdbus_free(env->conn, offset);
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	privileged = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(privileged);
+
+	ret = kdbus_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret == 0);
+
+	info = (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id == conn->id);
+
+	/* We do not have any well-known name */
+	item = kdbus_get_item(info, KDBUS_ITEM_NAME);
+	ASSERT_RETURN(item == NULL);
+
+	cnt = kdbus_count_item(info, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(cnt == 1);
+
+	item = kdbus_get_item(info, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(item);
+
+	/* Compare item->creds with cached creds */
+	ASSERT_RETURN(item->creds.uid == cached_creds.uid &&
+		      item->creds.gid == cached_creds.gid &&
+		      item->creds.pid == cached_creds.pid &&
+		      item->creds.tid == cached_creds.tid);
+
+	/* We did not request KDBUS_ITEM_CAPS */
+	item = kdbus_get_item(info, KDBUS_ITEM_CAPS);
+	ASSERT_RETURN(item == NULL);
+
+	kdbus_free(conn, offset);
+
+	ret = kdbus_name_acquire(conn, "com.example.a", NULL);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret == 0);
+
+	info = (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id == conn->id);
+
+	item = kdbus_get_item(info, KDBUS_ITEM_OWNED_NAME);
+	ASSERT_RETURN(item && !strcmp(item->name.name, "com.example.a"));
+
+	kdbus_free(conn, offset);
+
+	ret = kdbus_info(conn, 0, "com.example.a", valid_flags, &offset);
+	ASSERT_RETURN(ret == 0);
+
+	info = (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id == conn->id);
+
+	kdbus_free(conn, offset);
+
+	ret = RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		ret = kdbus_info(conn, conn->id, NULL,
+				 valid_flags, &offset);
+		ASSERT_EXIT(ret == 0);
+
+		info = (struct kdbus_info *)(conn->buf + offset);
+		ASSERT_EXIT(info->id == conn->id);
+
+		item = kdbus_get_item(info, KDBUS_ITEM_OWNED_NAME);
+		ASSERT_EXIT(item &&
+			!strcmp(item->name.name, "com.example.a"));
+
+		item = kdbus_get_item(info, KDBUS_ITEM_CREDS);
+		ASSERT_EXIT(item);
+
+		/*
+		 * Compare item->creds with cached creds of
+		 * privileged one.
+		 *
+		 * cmd_info will always return cached creds.
+		 */
+		ASSERT_EXIT(item->creds.uid == cached_creds.uid &&
+			    item->creds.gid == cached_creds.gid &&
+			    item->creds.pid == cached_creds.pid &&
+			    item->creds.tid == cached_creds.tid);
+
+		kdbus_free(conn, offset);
+
+		/*
+		 * Use invalid_flags and make sure that userspace
+		 * do not play with us.
+		 */
+		ret = kdbus_info(conn, conn->id, NULL,
+				 invalid_flags, &offset);
+		ASSERT_EXIT(ret == 0);
+
+		/*
+		 * Make sure that we return only one creds item and
+		 * it points to the cached creds.
+		 */
+		cnt = kdbus_count_item(info, KDBUS_ITEM_CREDS);
+		ASSERT_EXIT(cnt == 1);
+
+		item = kdbus_get_item(info, KDBUS_ITEM_CREDS);
+		ASSERT_EXIT(item);
+
+		/* Compare item->creds with cached creds */
+		ASSERT_EXIT(item->creds.uid == cached_creds.uid &&
+			    item->creds.gid == cached_creds.gid &&
+			    item->creds.pid == cached_creds.pid &&
+			    item->creds.tid == cached_creds.tid);
+
+		cnt = kdbus_count_item(info, KDBUS_ITEM_CGROUP);
+		ASSERT_EXIT(cnt == 1);
+
+		cnt = kdbus_count_item(info, KDBUS_ITEM_CAPS);
+		ASSERT_EXIT(cnt == 1);
+
+		kdbus_free(conn, offset);
+	}),
+	({ 0; }));
+
+	/* A second name */
+	ret = kdbus_name_acquire(conn, "com.example.b", NULL);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_info(conn, conn->id, NULL, valid_flags, &offset);
+	ASSERT_RETURN(ret == 0);
+
+	info = (struct kdbus_info *)(conn->buf + offset);
+	ASSERT_RETURN(info->id == conn->id);
+
+	cnt = kdbus_count_item(info, KDBUS_ITEM_OWNED_NAME);
+	ASSERT_RETURN(cnt == 2);
+
+	kdbus_free(conn, offset);
+
+	ASSERT_RETURN(ret == 0);
+
+	return 0;
+}
+
+int kdbus_test_conn_info(struct kdbus_test_env *env)
+{
+	int ret;
+	struct {
+		struct kdbus_cmd_info cmd_info;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[64];
+		} name;
+	} buf;
+
+	buf.cmd_info.size = sizeof(struct kdbus_cmd_info);
+	buf.cmd_info.flags = 0;
+	buf.cmd_info.id = env->conn->id;
+
+	ret = kdbus_info(env->conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* try to pass a name that is longer than the buffer's size */
+	buf.name.size = KDBUS_ITEM_HEADER_SIZE + 1;
+	buf.name.type = KDBUS_ITEM_NAME;
+	strcpy(buf.name.str, "foo.bar.bla");
+
+	buf.cmd_info.id = 0;
+	buf.cmd_info.size = sizeof(buf.cmd_info) + buf.name.size;
+	ret = ioctl(env->conn->fd, KDBUS_CMD_CONN_INFO, &buf);
+	ASSERT_RETURN(ret == -1 && errno == EINVAL);
+
+	/* Pass a non existent name */
+	ret = kdbus_info(env->conn, 0, "non.existent.name", 0, NULL);
+	ASSERT_RETURN(ret == -ESRCH);
+
+	/* Test for caps here, so we run the previous test */
+	ret = test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >= 0);
+
+	if (!ret)
+		return TEST_SKIP;
+
+	ret = kdbus_fuzz_conn_info(env);
+	ASSERT_RETURN(ret == 0);
+
+	return TEST_OK;
+}
+
+int kdbus_test_conn_update(struct kdbus_test_env *env)
+{
+	const struct kdbus_item *item;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	int found = 0;
+	int ret;
+
+	/*
+	 * kdbus_hello() sets all attach flags. Receive a message by this
+	 * connection, and make sure a timestamp item (just to pick one) is
+	 * present.
+	 */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type == KDBUS_ITEM_TIMESTAMP)
+			found = 1;
+
+	kdbus_msg_free(msg);
+
+	ASSERT_RETURN(found == 1);
+
+	/*
+	 * Now, modify the attach flags and repeat the action. The item must
+	 * now be missing.
+	 */
+	found = 0;
+
+	ret = kdbus_conn_update_attach_flags(conn, _KDBUS_ATTACH_ALL &
+						   ~KDBUS_ATTACH_TIMESTAMP);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_send(env->conn, NULL, 0x12345678, 0, 0, 0, conn->id);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type == KDBUS_ITEM_TIMESTAMP)
+			found = 1;
+
+	ASSERT_RETURN(found == 0);
+
+	kdbus_msg_free(msg);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_writable_pool(struct kdbus_test_env *env)
+{
+	struct kdbus_cmd_hello hello;
+	int fd, ret;
+	void *map;
+
+	fd = open(env->buspath, O_RDWR | O_CLOEXEC);
+	ASSERT_RETURN(fd >= 0);
+
+	memset(&hello, 0, sizeof(hello));
+	hello.flags = KDBUS_HELLO_ACCEPT_FD;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+	hello.attach_flags_recv = _KDBUS_ATTACH_ALL;
+	hello.size = sizeof(struct kdbus_cmd_hello);
+	hello.pool_size = POOL_SIZE;
+
+	/* success test */
+	ret = ioctl(fd, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == 0);
+
+	/* pools cannot be mapped writable */
+	map = mmap(NULL, POOL_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	ASSERT_RETURN(map == MAP_FAILED);
+
+	/* pools can always be mapped readable */
+	map = mmap(NULL, POOL_SIZE, PROT_READ, MAP_SHARED, fd, 0);
+	ASSERT_RETURN(map != MAP_FAILED);
+
+	/* make sure we cannot change protection masks to writable */
+	ret = mprotect(map, POOL_SIZE, PROT_READ | PROT_WRITE);
+	ASSERT_RETURN(ret < 0);
+
+	munmap(map, POOL_SIZE);
+	close(fd);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-daemon.c b/tools/testing/selftests/kdbus/test-daemon.c
new file mode 100644
index 000000000000..9007e38d6a7a
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-daemon.c
@@ -0,0 +1,66 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_daemon(struct kdbus_test_env *env)
+{
+	struct pollfd fds[2];
+	int count;
+	int ret;
+
+	/* This test doesn't make any sense in non-interactive mode */
+	if (!kdbus_util_verbose)
+		return TEST_OK;
+
+	printf("Created connection %llu on bus '%s'\n",
+		(unsigned long long) env->conn->id, env->buspath);
+
+	ret = kdbus_name_acquire(env->conn, "com.example.kdbus-test", NULL);
+	ASSERT_RETURN(ret == 0);
+	printf("  Aquired name: com.example.kdbus-test\n");
+
+	fds[0].fd = env->conn->fd;
+	fds[1].fd = STDIN_FILENO;
+
+	printf("Monitoring connections:\n");
+
+	for (count = 0;; count++) {
+		int i, nfds = sizeof(fds) / sizeof(fds[0]);
+
+		for (i = 0; i < nfds; i++) {
+			fds[i].events = POLLIN | POLLPRI | POLLHUP;
+			fds[i].revents = 0;
+		}
+
+		ret = poll(fds, nfds, -1);
+		if (ret <= 0)
+			break;
+
+		if (fds[0].revents & POLLIN) {
+			ret = kdbus_msg_recv(env->conn, NULL, NULL);
+			ASSERT_RETURN(ret == 0);
+		}
+
+		/* stdin */
+		if (fds[1].revents & POLLIN)
+			break;
+	}
+
+	printf("Closing bus connection\n");
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-endpoint.c b/tools/testing/selftests/kdbus/test-endpoint.c
new file mode 100644
index 000000000000..1a2263f5b584
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-endpoint.c
@@ -0,0 +1,221 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <libgen.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+#define KDBUS_SYSNAME_MAX_LEN			63
+
+static int install_name_add_match(struct kdbus_conn *conn, const char *name)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	int ret;
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type = KDBUS_ITEM_NAME_ADD;
+	buf.item.chg.old_id.id = KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id = KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size = sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size = sizeof(buf.cmd) + buf.item.size;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int create_endpoint(const char *buspath, const char *name)
+{
+	struct {
+		struct kdbus_cmd_make head;
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			/* max should be KDBUS_SYSNAME_MAX_LEN */
+			char str[128];
+		} name;
+	} ep_make;
+	int fd, ret;
+
+	fd = open(buspath, O_RDWR);
+	if (fd < 0)
+		return fd;
+
+	memset(&ep_make, 0, sizeof(ep_make));
+
+	snprintf(ep_make.name.str,
+		 /* Use the KDBUS_SYSNAME_MAX_LEN or sizeof(str) */
+		 KDBUS_SYSNAME_MAX_LEN > strlen(name) ?
+		 KDBUS_SYSNAME_MAX_LEN : sizeof(ep_make.name.str),
+		 "%u-%s", getuid(), name);
+
+	ep_make.name.type = KDBUS_ITEM_MAKE_NAME;
+	ep_make.name.size = KDBUS_ITEM_HEADER_SIZE +
+			    strlen(ep_make.name.str) + 1;
+
+	ep_make.head.size = sizeof(ep_make.head) +
+			    ep_make.name.size;
+
+	ret = ioctl(fd, KDBUS_CMD_ENDPOINT_MAKE, &ep_make);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error creating endpoint: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return fd;
+}
+
+static int update_endpoint(int fd, const char *name)
+{
+	int len = strlen(name) + 1;
+	struct {
+		struct kdbus_cmd_update head;
+
+		/* name item */
+		struct {
+			uint64_t size;
+			uint64_t type;
+			char str[KDBUS_ALIGN8(len)];
+		} name;
+
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_policy_access access;
+		} access;
+	} ep_update;
+	int ret;
+
+	memset(&ep_update, 0, sizeof(ep_update));
+
+	ep_update.name.size = KDBUS_ITEM_HEADER_SIZE + len;
+	ep_update.name.type = KDBUS_ITEM_NAME;
+	strncpy(ep_update.name.str, name, sizeof(ep_update.name.str) - 1);
+
+	ep_update.access.size = sizeof(ep_update.access);
+	ep_update.access.type = KDBUS_ITEM_POLICY_ACCESS;
+	ep_update.access.access.type = KDBUS_POLICY_ACCESS_WORLD;
+	ep_update.access.access.access = KDBUS_POLICY_SEE;
+
+	ep_update.head.size = sizeof(ep_update);
+
+	ret = ioctl(fd, KDBUS_CMD_ENDPOINT_UPDATE, &ep_update);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error updating endpoint: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_test_custom_endpoint(struct kdbus_test_env *env)
+{
+	char *ep, *tmp;
+	int ret, ep_fd;
+	struct kdbus_msg *msg;
+	struct kdbus_conn *ep_conn;
+	const char *name = "foo.bar.baz";
+	const char *epname = "foo";
+	char fake_ep[KDBUS_SYSNAME_MAX_LEN + 1] = {'\0'};
+
+	memset(fake_ep, 'X', sizeof(fake_ep) - 1);
+
+	/* Try to create a custom endpoint with a long name */
+	ret = create_endpoint(env->buspath, fake_ep);
+	ASSERT_RETURN(ret == -ENAMETOOLONG);
+
+	/* create a custom endpoint, and open a connection on it */
+	ep_fd = create_endpoint(env->buspath, "foo");
+	ASSERT_RETURN(ep_fd >= 0);
+
+	tmp = strdup(env->buspath);
+	ASSERT_RETURN(tmp);
+
+	ret = asprintf(&ep, "%s/%u-%s", dirname(tmp), getuid(), epname);
+	free(tmp);
+	ASSERT_RETURN(ret >= 0);
+
+	ep_conn = kdbus_hello(ep, 0, NULL, 0);
+	ASSERT_RETURN(ep_conn);
+
+	/*
+	 * Add a name add match on the endpoint connection, acquire name from
+	 * the unfiltered connection, and make sure the filtered connection
+	 * did not get the notification on the name owner change. Also, the
+	 * endpoint connection may not be able to call conn_info, neither on
+	 * the name nor on the ID.
+	 */
+	ret = install_name_add_match(ep_conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(ep_conn, NULL, NULL);
+	ASSERT_RETURN(ret == -EAGAIN);
+
+	ret = kdbus_info(ep_conn, 0, name, 0, NULL);
+	ASSERT_RETURN(ret == -ENOENT);
+
+	ret = kdbus_info(ep_conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret == -ENOENT);
+
+	/*
+	 * Release the name again, update the custom endpoint policy,
+	 * and try again. This time, the connection on the custom endpoint
+	 * should have gotten it.
+	 */
+	ret = kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	ret = update_endpoint(ep_fd, name);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(ep_conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_NAME_ADD);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id == 0);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id == env->conn->id);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) == 0);
+	kdbus_msg_free(msg);
+
+	ret = kdbus_info(ep_conn, 0, name, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_info(ep_conn, env->conn->id, NULL, 0, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(ep_conn);
+	close(ep_fd);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-fd.c b/tools/testing/selftests/kdbus/test-fd.c
new file mode 100644
index 000000000000..3eda09f61089
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-fd.c
@@ -0,0 +1,664 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define KDBUS_MSG_MAX_ITEMS     128
+#define KDBUS_MSG_MAX_FDS       253
+#define KDBUS_USER_MAX_CONN	256
+
+static int make_msg_payload_dbus(uint64_t src_id, uint64_t dst_id,
+				 uint64_t msg_size,
+				 struct kdbus_msg **msg_dbus)
+{
+	struct kdbus_msg *msg;
+
+	msg = malloc(msg_size);
+	ASSERT_RETURN_VAL(msg, -ENOMEM);
+
+	memset(msg, 0, msg_size);
+	msg->size = msg_size;
+	msg->src_id = src_id;
+	msg->dst_id = dst_id;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+
+	*msg_dbus = msg;
+
+	return 0;
+}
+
+static void make_item_memfds(struct kdbus_item *item,
+			     int *memfds, size_t memfd_size)
+{
+	size_t i;
+
+	for (i = 0; i < memfd_size; i++) {
+		item->type = KDBUS_ITEM_PAYLOAD_MEMFD;
+		item->size = KDBUS_ITEM_HEADER_SIZE +
+			     sizeof(struct kdbus_memfd);
+		item->memfd.fd = memfds[i];
+		item->memfd.size = sizeof(uint64_t); /* const size */
+		item = KDBUS_ITEM_NEXT(item);
+	}
+}
+
+static void make_item_fds(struct kdbus_item *item,
+			  int *fd_array, size_t fd_size)
+{
+	size_t i;
+	item->type = KDBUS_ITEM_FDS;
+	item->size = KDBUS_ITEM_HEADER_SIZE + (sizeof(int) * fd_size);
+
+	for (i = 0; i < fd_size; i++)
+		item->fds[i] = fd_array[i];
+}
+
+static int memfd_write(const char *name, void *buf, size_t bufsize)
+{
+	ssize_t ret;
+	int memfd;
+
+	memfd = sys_memfd_create(name, 0);
+	ASSERT_RETURN_VAL(memfd >= 0, memfd);
+
+	ret = write(memfd, buf, bufsize);
+	ASSERT_RETURN_VAL(ret == (ssize_t)bufsize, -EAGAIN);
+
+	ret = sys_memfd_seal_set(memfd);
+	ASSERT_RETURN_VAL(ret == 0, -errno);
+
+	return memfd;
+}
+
+static int send_memfds(struct kdbus_conn *conn, uint64_t dst_id,
+		       int *memfds_array, size_t memfd_count)
+{
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += memfd_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+
+	if (dst_id == KDBUS_DST_ID_BROADCAST)
+		size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+
+	ret = make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	item = msg->items;
+
+	if (dst_id == KDBUS_DST_ID_BROADCAST) {
+		item->type = KDBUS_ITEM_BLOOM_FILTER;
+		item->size = KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + 64;
+		item = KDBUS_ITEM_NEXT(item);
+	}
+
+	make_item_memfds(item, memfds_array, memfd_count);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return 0;
+}
+
+static int send_fds(struct kdbus_conn *conn, uint64_t dst_id,
+		    int *fd_array, size_t fd_count)
+{
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(int) * fd_count);
+
+	ret = make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	item = msg->items;
+
+	make_item_fds(item, fd_array, fd_count);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return ret;
+}
+
+static int send_fds_memfds(struct kdbus_conn *conn, uint64_t dst_id,
+			   int *fds_array, size_t fd_count,
+			   int *memfds_array, size_t memfd_count)
+{
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	uint64_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += memfd_count * KDBUS_ITEM_SIZE(sizeof(struct kdbus_memfd));
+	size += KDBUS_ITEM_SIZE(sizeof(int) * fd_count);
+
+	ret = make_msg_payload_dbus(conn->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	item = msg->items;
+
+	make_item_fds(item, fds_array, fd_count);
+	item = KDBUS_ITEM_NEXT(item);
+	make_item_memfds(item, memfds_array, memfd_count);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+	return ret;
+}
+
+/* Return the number of received fds */
+static unsigned int kdbus_item_get_nfds(struct kdbus_msg *msg)
+{
+	unsigned int fds = 0;
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		switch (item->type) {
+		case KDBUS_ITEM_FDS: {
+			fds += (item->size - KDBUS_ITEM_HEADER_SIZE) /
+				sizeof(int);
+			break;
+		}
+
+		case KDBUS_ITEM_PAYLOAD_MEMFD:
+			fds++;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	return fds;
+}
+
+static struct kdbus_msg *
+get_kdbus_msg_with_fd(struct kdbus_conn *conn_src,
+		      uint64_t dst_id, uint64_t cookie, int fd)
+{
+	int ret;
+	uint64_t size;
+	struct kdbus_item *item;
+	struct kdbus_msg *msg;
+
+	size = sizeof(struct kdbus_msg);
+	if (fd >= 0)
+		size += KDBUS_ITEM_SIZE(sizeof(int));
+
+	ret = make_msg_payload_dbus(conn_src->id, dst_id, size, &msg);
+	ASSERT_RETURN_VAL(ret == 0, NULL);
+
+	msg->cookie = cookie;
+
+	if (fd >= 0) {
+		item = msg->items;
+
+		make_item_fds(item, (int *)&fd, 1);
+	}
+
+	return msg;
+}
+
+static int kdbus_test_no_fds(struct kdbus_test_env *env,
+			     int *fds, int *memfd)
+{
+	pid_t pid;
+	int ret, status;
+	uint64_t cookie;
+	int connfd1, connfd2;
+	struct kdbus_msg *msg, *msg_sync_reply;
+	struct kdbus_cmd_hello hello;
+	struct kdbus_conn *conn_src, *conn_dst, *conn_dummy;
+
+	conn_src = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_src);
+
+	connfd1 = open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(connfd1 >= 0);
+
+	connfd2 = open(env->buspath, O_RDWR|O_CLOEXEC);
+	ASSERT_RETURN(connfd2 >= 0);
+
+	/*
+	 * Create connections without KDBUS_HELLO_ACCEPT_FD
+	 * to test if send fd operations are blocked
+	 */
+	conn_dst = malloc(sizeof(*conn_dst));
+	ASSERT_RETURN(conn_dst);
+
+	conn_dummy = malloc(sizeof(*conn_dummy));
+	ASSERT_RETURN(conn_dummy);
+
+	memset(&hello, 0, sizeof(hello));
+	hello.size = sizeof(struct kdbus_cmd_hello);
+	hello.pool_size = POOL_SIZE;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+
+	ret = ioctl(connfd1, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == 0);
+
+	conn_dst->fd = connfd1;
+	conn_dst->id = hello.id;
+
+	memset(&hello, 0, sizeof(hello));
+	hello.size = sizeof(struct kdbus_cmd_hello);
+	hello.pool_size = POOL_SIZE;
+	hello.attach_flags_send = _KDBUS_ATTACH_ALL;
+
+	ret = ioctl(connfd2, KDBUS_CMD_HELLO, &hello);
+	ASSERT_RETURN(ret == 0);
+
+	conn_dummy->fd = connfd2;
+	conn_dummy->id = hello.id;
+
+	conn_dst->buf = mmap(NULL, POOL_SIZE, PROT_READ,
+			     MAP_PRIVATE, connfd1, 0);
+	ASSERT_RETURN(conn_dst->buf != MAP_FAILED);
+
+	conn_dummy->buf = mmap(NULL, POOL_SIZE, PROT_READ,
+			       MAP_PRIVATE, connfd2, 0);
+	ASSERT_RETURN(conn_dummy->buf != MAP_FAILED);
+
+	/*
+	 * Send fds to connection that do not accept fd passing
+	 */
+	ret = send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret == -ECOMM);
+
+	/*
+	 * memfd are kdbus payload
+	 */
+	ret = send_memfds(conn_src, conn_dst->id, memfd, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv_poll(conn_dst, 100, NULL, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	cookie = time(NULL);
+
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, pid);
+
+	if (pid == 0) {
+		struct timespec now;
+
+		/*
+		 * A sync send/reply to a connection that do not
+		 * accept fds should fail if it contains an fd
+		 */
+		msg_sync_reply = get_kdbus_msg_with_fd(conn_dst,
+						       conn_dummy->id,
+						       cookie, fds[0]);
+		ASSERT_EXIT(msg_sync_reply);
+
+		ret = clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
+		ASSERT_EXIT(ret == 0);
+
+		msg_sync_reply->timeout_ns = now.tv_sec * 1000000000ULL +
+					     now.tv_nsec + 100000000ULL;
+		msg_sync_reply->flags = KDBUS_MSG_FLAGS_EXPECT_REPLY |
+					KDBUS_MSG_FLAGS_SYNC_REPLY;
+
+
+		ret = ioctl(conn_dst->fd, KDBUS_CMD_MSG_SEND,
+			    msg_sync_reply);
+		ASSERT_EXIT(ret < 0 && -errno == -ECOMM);
+
+		/*
+		 * Now send a normal message, but the sync reply
+		 * will fail since it contains an fd that the
+		 * original sender do not want.
+		 *
+		 * The original sender will fail with -ETIMEDOUT
+		 */
+		cookie++;
+		ret = kdbus_msg_send(conn_dst, NULL, cookie,
+				     KDBUS_MSG_FLAGS_EXPECT_REPLY |
+				     KDBUS_MSG_FLAGS_SYNC_REPLY,
+				     5000000000ULL, 0, conn_src->id);
+		ASSERT_EXIT(ret == -EREMOTEIO);
+
+		cookie++;
+		ret = kdbus_msg_recv_poll(conn_dst, 100, &msg, NULL);
+		ASSERT_EXIT(ret == 0);
+		ASSERT_EXIT(msg->cookie == cookie);
+
+		free(msg_sync_reply);
+		kdbus_msg_free(msg);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret = kdbus_msg_recv_poll(conn_dummy, 100, NULL, NULL);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	cookie++;
+	ret = kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+
+	/*
+	 * Try to reply with a kdbus connection handle, this should
+	 * fail with -EOPNOTSUPP
+	 */
+	msg_sync_reply = get_kdbus_msg_with_fd(conn_src,
+					       conn_dst->id,
+					       cookie, conn_dst->fd);
+	ASSERT_RETURN(msg_sync_reply);
+
+	msg_sync_reply->cookie_reply = cookie;
+
+	ret = ioctl(conn_src->fd, KDBUS_CMD_MSG_SEND, msg_sync_reply);
+	ASSERT_RETURN(ret < 0 && -errno == -EOPNOTSUPP);
+
+	free(msg_sync_reply);
+
+	/*
+	 * Try to reply with a normal fd, this should fail even
+	 * if the response is a sync reply
+	 *
+	 * From the sender view we fail with -ECOMM
+	 */
+	msg_sync_reply = get_kdbus_msg_with_fd(conn_src,
+					       conn_dst->id,
+					       cookie, fds[0]);
+	ASSERT_RETURN(msg_sync_reply);
+
+	msg_sync_reply->cookie_reply = cookie;
+
+	ret = ioctl(conn_src->fd, KDBUS_CMD_MSG_SEND, msg_sync_reply);
+	ASSERT_RETURN(ret < 0 && -errno == -ECOMM);
+
+	free(msg_sync_reply);
+
+	/*
+	 * Resend another normal message and check if the queue
+	 * is clear
+	 */
+	cookie++;
+	ret = kdbus_msg_send(conn_src, NULL, cookie, 0, 0, 0,
+			     conn_dst->id);
+	ASSERT_RETURN(ret == 0);
+
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >= 0, ret);
+
+	kdbus_conn_free(conn_dummy);
+	kdbus_conn_free(conn_dst);
+	kdbus_conn_free(conn_src);
+
+	return (status == EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static int kdbus_send_multiple_fds(struct kdbus_conn *conn_src,
+				   struct kdbus_conn *conn_dst)
+{
+	int ret, i;
+	unsigned int nfds;
+	int fds[KDBUS_MSG_MAX_FDS + 1];
+	int memfds[KDBUS_MSG_MAX_ITEMS + 1];
+	struct kdbus_msg *msg;
+	uint64_t dummy_value;
+
+	dummy_value = time(NULL);
+
+	for (i = 0; i < KDBUS_MSG_MAX_FDS + 1; i++) {
+		fds[i] = open("/dev/null", O_RDWR|O_CLOEXEC);
+		ASSERT_RETURN_VAL(fds[i] >= 0, -errno);
+	}
+
+	/* Send KDBUS_MSG_MAX_FDS with one more fd */
+	ret = send_fds(conn_src, conn_dst->id, fds, KDBUS_MSG_MAX_FDS + 1);
+	ASSERT_RETURN(ret == -EMFILE);
+
+	/* Retry with the correct KDBUS_MSG_MAX_FDS */
+	ret = send_fds(conn_src, conn_dst->id, fds, KDBUS_MSG_MAX_FDS);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* Check we got the right number of fds */
+	nfds = kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds == KDBUS_MSG_MAX_FDS);
+
+	kdbus_msg_free(msg);
+
+	for (i = 0; i < KDBUS_MSG_MAX_ITEMS + 1; i++, dummy_value++) {
+		memfds[i] = memfd_write("memfd-name",
+					&dummy_value,
+					sizeof(dummy_value));
+		ASSERT_RETURN_VAL(memfds[i] >= 0, memfds[i]);
+	}
+
+	/* Send KDBUS_MSG_MAX_FDS with one more memfd */
+	ret = send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_ITEMS + 1);
+	ASSERT_RETURN(ret == -E2BIG);
+
+	/* Retry with the correct KDBUS_MSG_MAX_ITEMS */
+	ret = send_memfds(conn_src, conn_dst->id,
+			  memfds, KDBUS_MSG_MAX_ITEMS);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* Check we got the right number of fds */
+	nfds = kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds == KDBUS_MSG_MAX_ITEMS);
+
+	kdbus_msg_free(msg);
+
+
+	/* Combine multiple 254 fds and 100 memfds */
+	ret = send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_MSG_MAX_FDS + 1,
+			      memfds, 100);
+	ASSERT_RETURN(ret == -EMFILE);
+
+	/* Combine multiple 253 fds and 128 + 1 memfds */
+	ret = send_fds_memfds(conn_src, conn_dst->id,
+			      fds, KDBUS_MSG_MAX_FDS,
+			      memfds, KDBUS_MSG_MAX_ITEMS + 1);
+	ASSERT_RETURN(ret == -E2BIG);
+
+	ret = send_fds_memfds(conn_src, conn_dst->id,
+			      fds, 153, memfds, 100);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* Check we got the right number of fds */
+	nfds = kdbus_item_get_nfds(msg);
+	ASSERT_RETURN(nfds == 253);
+
+	kdbus_msg_free(msg);
+
+	for (i = 0; i < KDBUS_MSG_MAX_FDS + 1; i++)
+		close(fds[i]);
+
+	for (i = 0; i < KDBUS_MSG_MAX_ITEMS + 1; i++)
+		close(memfds[i]);
+
+	return 0;
+}
+
+int kdbus_test_fd_passing(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_src, *conn_dst;
+	const char *str = "stackenblocken";
+	const struct kdbus_item *item;
+	struct kdbus_msg *msg;
+	unsigned int i;
+	time_t now;
+	int fds_conn[2];
+	int sock_pair[2];
+	int fds[2];
+	int memfd;
+	int ret;
+
+	now = time(NULL);
+
+	/* create two connections */
+	conn_src = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_dst = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_src && conn_dst);
+
+	fds_conn[0] = conn_src->fd;
+	fds_conn[1] = conn_dst->fd;
+
+	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, sock_pair);
+	ASSERT_RETURN(ret == 0);
+
+	/* Setup memfd */
+	memfd = memfd_write("memfd-name", &now, sizeof(now));
+	ASSERT_RETURN(memfd >= 0);
+
+	/* Setup pipes */
+	ret = pipe(fds);
+	ASSERT_RETURN(ret == 0);
+
+	i = write(fds[1], str, strlen(str));
+	ASSERT_RETURN(i == strlen(str));
+
+	/*
+	 * Try to ass the handle of a connection as message payload.
+	 * This must fail.
+	 */
+	ret = send_fds(conn_src, conn_dst->id, fds_conn, 2);
+	ASSERT_RETURN(ret == -ENOTSUP);
+
+	ret = send_fds(conn_dst, conn_src->id, fds_conn, 2);
+	ASSERT_RETURN(ret == -ENOTSUP);
+
+	ret = send_fds(conn_src, conn_dst->id, sock_pair, 2);
+	ASSERT_RETURN(ret == -ENOTSUP);
+
+	/*
+	 * Send fds and memfds to connection that do not accept fds
+	 */
+	ret = kdbus_test_no_fds(env, fds, (int *)&memfd);
+	ASSERT_RETURN(ret == 0);
+
+	/* Try to broadcast file descriptors. This must fail. */
+	ret = send_fds(conn_src, KDBUS_DST_ID_BROADCAST, fds, 1);
+	ASSERT_RETURN(ret == -ENOTUNIQ);
+
+	/* Try to broadcast memfd. This must succeed. */
+	ret = send_memfds(conn_src, KDBUS_DST_ID_BROADCAST, (int *)&memfd, 1);
+	ASSERT_RETURN(ret == 0);
+
+	/* Open code this loop */
+loop_send_fds:
+
+	/*
+	 * Send the read end of the pipe and close it.
+	 */
+	ret = send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret == 0);
+	close(fds[0]);
+
+	ret = kdbus_msg_recv(conn_dst, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	KDBUS_ITEM_FOREACH(item, msg, items) {
+		if (item->type == KDBUS_ITEM_FDS) {
+			char tmp[14];
+			int nfds = (item->size - KDBUS_ITEM_HEADER_SIZE) /
+					sizeof(int);
+			ASSERT_RETURN(nfds == 1);
+
+			i = read(item->fds[0], tmp, sizeof(tmp));
+			if (i != 0) {
+				ASSERT_RETURN(i == sizeof(tmp));
+				ASSERT_RETURN(memcmp(tmp, str, sizeof(tmp)) == 0);
+
+				/* Write EOF */
+				close(fds[1]);
+
+				/*
+				 * Resend the read end of the pipe,
+				 * the receiver still holds a reference
+				 * to it...
+				 */
+				goto loop_send_fds;
+			}
+
+			/* Got EOF */
+
+			/*
+			 * Close the last reference to the read end
+			 * of the pipe, other references are
+			 * automatically closed just after send.
+			 */
+			close(item->fds[0]);
+		}
+	}
+
+	/*
+	 * Try to resend the read end of the pipe. Must fail with
+	 * -EBADF since both the sender and receiver closed their
+	 * references to it. We assume the above since sender and
+	 * receiver are on the same process.
+	 */
+	ret = send_fds(conn_src, conn_dst->id, fds, 1);
+	ASSERT_RETURN(ret == -EBADF);
+
+	/* Then we clear out received any data... */
+	kdbus_msg_free(msg);
+
+	ret = kdbus_send_multiple_fds(conn_src, conn_dst);
+	ASSERT_RETURN(ret == 0);
+
+	close(sock_pair[0]);
+	close(sock_pair[1]);
+	close(memfd);
+
+	kdbus_conn_free(conn_src);
+	kdbus_conn_free(conn_dst);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-free.c b/tools/testing/selftests/kdbus/test-free.c
new file mode 100644
index 000000000000..f43e3f616738
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-free.c
@@ -0,0 +1,34 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_free(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_cmd_free cmd_free;
+
+	/* free an unallocated buffer */
+	cmd_free.flags = 0;
+	cmd_free.offset = 0;
+	ret = ioctl(env->conn->fd, KDBUS_CMD_FREE, &cmd_free);
+	ASSERT_RETURN(ret == -1 && errno == ENXIO);
+
+	/* free a buffer out of the pool's bounds */
+	cmd_free.offset = POOL_SIZE + 1;
+	ret = ioctl(env->conn->fd, KDBUS_CMD_FREE, &cmd_free);
+	ASSERT_RETURN(ret == -1 && errno == ENXIO);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-match.c b/tools/testing/selftests/kdbus/test-match.c
new file mode 100644
index 000000000000..821ee89e0b02
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-match.c
@@ -0,0 +1,437 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+int kdbus_test_match_id_add(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+
+	buf.cmd.size = sizeof(buf);
+	buf.cmd.cookie = 0xdeafbeefdeaddead;
+	buf.item.size = sizeof(buf.item);
+	buf.item.type = KDBUS_ITEM_ID_ADD;
+	buf.item.chg.id = KDBUS_MATCH_ID_ANY;
+
+	/* match on id add */
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* create 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	/* 1st connection should have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_ID_ADD);
+	ASSERT_RETURN(msg->items[0].id_change.id == conn->id);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_id_remove(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	size_t id;
+	int ret;
+
+	/* create 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+	id = conn->id;
+
+	memset(&buf, 0, sizeof(buf));
+	buf.cmd.size = sizeof(buf);
+	buf.cmd.cookie = 0xdeafbeefdeaddead;
+	buf.item.size = sizeof(buf.item);
+	buf.item.type = KDBUS_ITEM_ID_REMOVE;
+	buf.item.chg.id = id;
+
+	/* register match on 2nd connection */
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* remove 2nd connection again */
+	kdbus_conn_free(conn);
+
+	/* 1st connection should have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_ID_REMOVE);
+	ASSERT_RETURN(msg->items[0].id_change.id == id);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_replace(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_id_change chg;
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	size_t id;
+	int ret;
+
+	/* add a match to id_add */
+	ASSERT_RETURN(kdbus_test_match_id_add(env) == TEST_OK);
+
+	/* do a replace of the match from id_add to id_remove */
+	memset(&buf, 0, sizeof(buf));
+
+	buf.cmd.size = sizeof(buf);
+	buf.cmd.cookie = 0xdeafbeefdeaddead;
+	buf.cmd.flags = KDBUS_MATCH_REPLACE;
+	buf.item.size = sizeof(buf.item);
+	buf.item.type = KDBUS_ITEM_ID_REMOVE;
+	buf.item.chg.id = KDBUS_MATCH_ID_ANY;
+
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+
+	/* create 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+	id = conn->id;
+
+	/* 1st connection should _not_ have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret != 0);
+
+	/* remove 2nd connection */
+	kdbus_conn_free(conn);
+
+	/* 1st connection should _now_ have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_ID_REMOVE);
+	ASSERT_RETURN(msg->items[0].id_change.id == id);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_add(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_msg *msg;
+	char *name;
+	int ret;
+
+	name = "foo.bla.blaz";
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type = KDBUS_ITEM_NAME_ADD;
+	buf.item.chg.old_id.id = KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id = KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size = sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size = sizeof(buf.cmd) + buf.item.size;
+
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* acquire the name */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* we should have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_NAME_ADD);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id == 0);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id == env->conn->id);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) == 0);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_remove(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_msg *msg;
+	char *name;
+	int ret;
+
+	name = "foo.bla.blaz";
+
+	/* acquire the name */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type = KDBUS_ITEM_NAME_REMOVE;
+	buf.item.chg.old_id.id = KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id = KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size = sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size = sizeof(buf.cmd) + buf.item.size;
+
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* release the name again */
+	kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* we should have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_NAME_REMOVE);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id == env->conn->id);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id == 0);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) == 0);
+
+	return TEST_OK;
+}
+
+int kdbus_test_match_name_change(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			struct kdbus_notify_name_change chg;
+		} item;
+		char name[64];
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	uint64_t flags;
+	char *name = "foo.bla.baz";
+	int ret;
+
+	/* acquire the name */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.item.type = KDBUS_ITEM_NAME_CHANGE;
+	buf.item.chg.old_id.id = KDBUS_MATCH_ID_ANY;
+	buf.item.chg.new_id.id = KDBUS_MATCH_ID_ANY;
+	strncpy(buf.name, name, sizeof(buf.name) - 1);
+	buf.item.size = sizeof(buf.item) + strlen(buf.name) + 1;
+	buf.cmd.size = sizeof(buf.cmd) + buf.item.size;
+
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	/* allow the new connection to own the same name */
+	/* queue the 2nd connection as waiting owner */
+	flags = KDBUS_NAME_QUEUE;
+	ret = kdbus_name_acquire(conn, name, &flags);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(flags & KDBUS_NAME_IN_QUEUE);
+
+	/* release name from 1st connection */
+	ret = kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* we should have received a notification */
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ASSERT_RETURN(msg->items[0].type == KDBUS_ITEM_NAME_CHANGE);
+	ASSERT_RETURN(msg->items[0].name_change.old_id.id == env->conn->id);
+	ASSERT_RETURN(msg->items[0].name_change.new_id.id == conn->id);
+	ASSERT_RETURN(strcmp(msg->items[0].name_change.name, name) == 0);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+static int send_bloom_filter(const struct kdbus_conn *conn,
+			     uint64_t cookie,
+			     const uint8_t *filter,
+			     size_t filter_size,
+			     uint64_t filter_generation)
+{
+	struct kdbus_msg *msg;
+	struct kdbus_item *item;
+	uint64_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) + filter_size;
+
+	msg = alloca(size);
+
+	memset(msg, 0, size);
+	msg->size = size;
+	msg->src_id = conn->id;
+	msg->dst_id = KDBUS_DST_ID_BROADCAST;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+	msg->cookie = cookie;
+
+	item = msg->items;
+	item->type = KDBUS_ITEM_BLOOM_FILTER;
+	item->size = KDBUS_ITEM_SIZE(sizeof(struct kdbus_bloom_filter)) +
+				filter_size;
+
+	item->bloom_filter.generation = filter_generation;
+	memcpy(item->bloom_filter.data, filter, filter_size);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+int kdbus_test_match_bloom(struct kdbus_test_env *env)
+{
+	struct {
+		struct kdbus_cmd_match cmd;
+		struct {
+			uint64_t size;
+			uint64_t type;
+			uint8_t data_gen0[64];
+			uint8_t data_gen1[64];
+		} item;
+	} buf;
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	uint64_t cookie = 0xf000f00f;
+	uint8_t filter[64];
+	int ret;
+
+	/* install the match rule */
+	memset(&buf, 0, sizeof(buf));
+	buf.cmd.size = sizeof(buf);
+
+	buf.item.size = sizeof(buf.item);
+	buf.item.type = KDBUS_ITEM_BLOOM_MASK;
+	buf.item.data_gen0[0] = 0x55;
+	buf.item.data_gen0[63] = 0x80;
+
+	buf.item.data_gen1[1] = 0xaa;
+	buf.item.data_gen1[9] = 0x02;
+
+	ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_ADD, &buf);
+	ASSERT_RETURN(ret == 0);
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	/* a message with a 0'ed out filter must not reach the other peer */
+	memset(filter, 0, sizeof(filter));
+	ret = send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == -EAGAIN);
+
+	/* now set the filter to the connection's mask and expect success */
+	filter[0] = 0x55;
+	filter[63] = 0x80;
+	ret = send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	/* broaden the filter and try again. this should also succeed. */
+	filter[0] = 0xff;
+	filter[8] = 0xff;
+	filter[63] = 0xff;
+	ret = send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 0);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	/* the same filter must not match against bloom generation 1 */
+	ret = send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == -EAGAIN);
+
+	/* set a different filter and try again */
+	filter[1] = 0xaa;
+	filter[9] = 0x02;
+	ret = send_bloom_filter(conn, ++cookie, filter, sizeof(filter), 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv(env->conn, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-message.c b/tools/testing/selftests/kdbus/test-message.c
new file mode 100644
index 000000000000..8422fbeadc2c
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-message.c
@@ -0,0 +1,371 @@
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+#include <sys/eventfd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+/* maximum number of queued messages from the same indvidual user */
+#define KDBUS_CONN_MAX_MSGS_PER_USER            16
+
+/* maximum number of queued messages in a connection */
+#define KDBUS_CONN_MAX_MSGS			256
+
+int kdbus_test_message_basic(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	struct kdbus_msg *msg;
+	uint64_t cookie = 0x1234abcd5678eeff;
+	uint64_t offset;
+	int ret;
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	ret = kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_add_match_empty(env->conn);
+	ASSERT_RETURN(ret == 0);
+
+	/* send over 1st connection */
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	/* ... and receive on the 2nd */
+	ret = kdbus_msg_recv_poll(conn, 100, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+
+	ret = kdbus_free(conn, offset);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+static int msg_recv_prio(struct kdbus_conn *conn,
+			 int64_t requested_prio,
+			 int64_t expected_prio)
+{
+	struct kdbus_cmd_recv recv = {
+		.flags = KDBUS_RECV_USE_PRIORITY,
+		.priority = requested_prio,
+	};
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_RECV, &recv);
+	if (ret < 0) {
+		kdbus_printf("error receiving message: %d (%m)\n", -errno);
+		return -errno;
+	}
+
+	msg = (struct kdbus_msg *)(conn->buf + recv.offset);
+	kdbus_msg_dump(conn, msg);
+
+	if (msg->priority != expected_prio) {
+		kdbus_printf("expected message prio %lld, got %lld\n",
+			     (unsigned long long) expected_prio,
+			     (unsigned long long) msg->priority);
+		return -EINVAL;
+	}
+
+	kdbus_msg_free(msg);
+	ret = kdbus_free(conn, recv.offset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int kdbus_test_message_prio(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b;
+	uint64_t cookie = 0;
+
+	a = kdbus_hello(env->buspath, 0, NULL, 0);
+	b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(a && b);
+
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   25, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -600, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -35, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -100, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   20, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -15, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -150, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,   10, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0, -800, a->id) == 0);
+	ASSERT_RETURN(kdbus_msg_send(b, NULL, ++cookie, 0, 0,  -10, a->id) == 0);
+
+	ASSERT_RETURN(msg_recv_prio(a, -200, -800) == 0);
+	ASSERT_RETURN(msg_recv_prio(a, -100, -800) == 0);
+	ASSERT_RETURN(msg_recv_prio(a, -400, -600) == 0);
+	ASSERT_RETURN(msg_recv_prio(a, -400, -600) == -ENOMSG);
+	ASSERT_RETURN(msg_recv_prio(a, 10, -150) == 0);
+	ASSERT_RETURN(msg_recv_prio(a, 10, -100) == 0);
+
+	kdbus_printf("--- get priority (all)\n");
+	ASSERT_RETURN(kdbus_msg_recv(a, NULL, NULL) == 0);
+
+	kdbus_conn_free(a);
+	kdbus_conn_free(b);
+
+	return TEST_OK;
+}
+
+/* Return the number of message successfully sent */
+static int kdbus_fill_conn_queue(struct kdbus_conn *conn_src,
+				 struct kdbus_conn *conn_dst,
+				 unsigned int max_msgs)
+{
+	unsigned int i;
+	uint64_t cookie = 0;
+	int ret;
+
+	for (i = 0; i < max_msgs; i++) {
+		ret = kdbus_msg_send(conn_src, NULL, ++cookie, 0,
+				     0, 0, conn_dst->id);
+		if (ret < 0)
+			break;
+	}
+
+	return i;
+}
+
+
+static int kdbus_test_multi_users_quota(struct kdbus_test_env *env)
+{
+	int ret, efd1, efd2;
+	unsigned int cnt, recved_count;
+	unsigned int max_user_msgs = KDBUS_CONN_MAX_MSGS_PER_USER;
+	struct kdbus_conn *conn;
+	struct kdbus_conn *privileged;
+	struct kdbus_conn *holder;
+	eventfd_t child1_count = 0, child2_count = 0;
+	struct kdbus_policy_access access = {
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	holder = kdbus_hello_registrar(env->buspath, "com.example.a",
+				       &access, 1,
+				       KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder);
+
+	privileged = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(privileged);
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/* Acquire name with access world so they can talk to us */
+	ret = kdbus_name_acquire(conn, "com.example.a", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/* Use this to tell parent how many messages have bee sent */
+	efd1 = eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd1 >= 0, efd1);
+
+	efd2 = eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd2 >= 0, efd2);
+
+	/*
+	 * Queue multiple messages as different users at the
+	 * same time.
+	 *
+	 * When the receiver queue count is below
+	 * KDBUS_CONN_MAX_MSGS_PER_USER messages are not accounted.
+	 *
+	 * So we start two threads running under different uid, they
+	 * race and each one will try to send:
+	 * (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1  msg
+	 *
+	 * Both threads will return how many message was successfull
+	 * queued, later we compute and try to validate the user quota
+	 * checks.
+	 */
+	ret = RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *unpriv;
+
+		unpriv = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv);
+
+		cnt = kdbus_fill_conn_queue(unpriv, conn,
+					    (max_user_msgs * 2) + 1);
+		/* Explicitly check for 0 we can't send it to eventfd */
+		ASSERT_EXIT(cnt > 0);
+
+		ret = eventfd_write(efd1, cnt);
+		ASSERT_EXIT(ret == 0);
+	}),
+	({;
+		/* Queue other messages as a different user */
+		ret = RUN_UNPRIVILEGED(UNPRIV_UID - 1, UNPRIV_GID - 1, ({
+			struct kdbus_conn *unpriv;
+
+			unpriv = kdbus_hello(env->buspath, 0, NULL, 0);
+			ASSERT_EXIT(unpriv);
+
+			cnt = kdbus_fill_conn_queue(unpriv, conn,
+						    (max_user_msgs * 2) + 1);
+			/* Explicitly check for 0 */
+			ASSERT_EXIT(cnt > 0);
+
+			ret = eventfd_write(efd2, cnt);
+			ASSERT_EXIT(ret == 0);
+		}),
+		({ 0; }));
+		ASSERT_RETURN(ret == 0);
+
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	/* Delay reading, so if children die we are not blocked */
+	ret = eventfd_read(efd1, &child1_count);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = eventfd_read(efd2, &child2_count);
+	ASSERT_RETURN(ret >= 0);
+
+	recved_count = child1_count + child2_count;
+
+	/* Validate how many messages have been sent */
+	ASSERT_RETURN(recved_count > 0);
+
+	/*
+	 * We start accounting after KDBUS_CONN_MAX_MSGS_PER_USER
+	 * so now we have a KDBUS_CONN_MAX_MSGS_PER_USER not
+	 * accounted, and given we have at least sent
+	 * (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1 for the two threads:
+	 * recved_count for both treads will for sure exceed that
+	 * value.
+	 *
+	 * 1) Both thread1 msgs + threads2 msgs exceed
+	 *    KDBUS_CONN_MAX_MSGS_PER_USER. Accounting is started.
+	 * 2) Now both of them will be able to send only his quota
+	 *    which is KDBUS_CONN_MAX_MSGS_PER_USER
+	 *    (previous sent messages of 1) were not accounted)
+	 */
+	ASSERT_RETURN(recved_count > (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1)
+
+	/*
+	 * A process should never send more than
+	 * (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1)
+	 */
+	ASSERT_RETURN(child1_count < (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1);
+
+	/*
+	 * Now both no accounted messages should give us
+	 * KDBUS_CONN_MAX_MSGS_PER_USER when the accounting
+	 * started.
+	 *
+	 * child1 non accounted + child2 non accounted =
+	 * KDBUS_CONN_MAX_MSGS_PER_USER
+	 */
+	ASSERT_RETURN(KDBUS_CONN_MAX_MSGS_PER_USER ==
+		((child1_count - KDBUS_CONN_MAX_MSGS_PER_USER) +
+		 ((recved_count - child1_count) -
+		  KDBUS_CONN_MAX_MSGS_PER_USER)));
+
+	/*
+	 * A process should never send more than
+	 * (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1)
+	 */
+	ASSERT_RETURN(child2_count < (KDBUS_CONN_MAX_MSGS_PER_USER * 2) + 1);
+
+	/*
+	 * Now both no accounted messages should give us
+	 * KDBUS_CONN_MAX_MSGS_PER_USER when the accounting
+	 * started.
+	 *
+	 * child1 non accounted + child2 non accounted =
+	 * KDBUS_CONN_MAX_MSGS_PER_USER
+	 */
+	ASSERT_RETURN(KDBUS_CONN_MAX_MSGS_PER_USER ==
+		((child2_count - KDBUS_CONN_MAX_MSGS_PER_USER) +
+		 ((recved_count - child2_count) -
+		  KDBUS_CONN_MAX_MSGS_PER_USER)));
+
+	/* Try to queue up more, but we fail no space in the pool */
+	cnt = kdbus_fill_conn_queue(privileged, conn, KDBUS_CONN_MAX_MSGS);
+	ASSERT_RETURN(cnt > 0 && cnt < KDBUS_CONN_MAX_MSGS);
+
+	ret = kdbus_msg_send(privileged, NULL, 0xdeadbeef, 0, 0,
+			     0, conn->id);
+	ASSERT_RETURN(ret == -ENOBUFS);
+
+	close(efd1);
+	close(efd2);
+
+	kdbus_conn_free(privileged);
+	kdbus_conn_free(holder);
+	kdbus_conn_free(conn);
+
+	return 0;
+}
+
+int kdbus_test_message_quota(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *a, *b;
+	uint64_t cookie = 0;
+	int ret;
+	int i;
+
+	if (geteuid() == 0) {
+		ret = kdbus_test_multi_users_quota(env);
+		ASSERT_RETURN(ret == 0);
+
+		/* Drop to 'nobody' and continue test */
+		ret = setresuid(UNPRIV_UID, UNPRIV_UID, UNPRIV_UID);
+		ASSERT_RETURN(ret == 0);
+	}
+
+	a = kdbus_hello(env->buspath, 0, NULL, 0);
+	b = kdbus_hello(env->buspath, 0, NULL, 0);
+
+	ret = kdbus_fill_conn_queue(b, a,
+				    KDBUS_CONN_MAX_MSGS_PER_USER * 2);
+	ASSERT_RETURN(ret == (KDBUS_CONN_MAX_MSGS_PER_USER * 2));
+
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ASSERT_RETURN(ret == -ENOBUFS);
+
+	for (i = 0; i < KDBUS_CONN_MAX_MSGS_PER_USER * 2; ++i) {
+		ret = kdbus_msg_recv(a, NULL, NULL);
+		ASSERT_RETURN(ret == 0);
+	}
+
+	ret = kdbus_fill_conn_queue(b, a,
+				    KDBUS_CONN_MAX_MSGS_PER_USER * 2);
+	ASSERT_RETURN(ret == (KDBUS_CONN_MAX_MSGS_PER_USER * 2));
+
+	ret = kdbus_msg_send(b, NULL, ++cookie, 0, 0, 0, a->id);
+	ASSERT_RETURN(ret == -ENOBUFS);
+
+	kdbus_conn_free(a);
+	kdbus_conn_free(b);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-metadata-ns.c b/tools/testing/selftests/kdbus/test-metadata-ns.c
new file mode 100644
index 000000000000..3af67d98084a
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-metadata-ns.c
@@ -0,0 +1,258 @@
+/* Test metadata in new namespaces */
+
+#include <stdio.h>
+#include <string.h>
+#include <sched.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <sys/capability.h>
+#include <linux/sched.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static int __kdbus_clone_userns_test(const char *bus, struct kdbus_conn *conn)
+{
+	int efd = -1;
+	pid_t pid;
+	int ret;
+	int status;
+	unsigned int uid = 65534;
+	int test_status = TEST_ERR;
+
+	ret = drop_privileges(UNPRIV_UID, UNPRIV_GID);
+	if (ret < 0)
+		goto out;
+
+	/**
+	 * Since we just dropped privileges, the dumpable flag was just
+	 * cleared which makes the /proc/$clone_child/uid_map to be
+	 * owned by root, hence any userns uid mapping will fail with
+	 * -EPERM since the mapping will be done by uid 65534.
+	 *
+	 * To avoid this set the dumpable flag again which makes procfs
+	 * update the /proc/$clone_child/ inodes owner to 65534.
+	 *
+	 * Using this we will be able write to /proc/$clone_child/uid_map
+	 * as uid 65534 and map the uid 65534 to 0 inside the user
+	 * namespace.
+	 */
+	ret = prctl(PR_SET_DUMPABLE, SUID_DUMP_USER);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error prctl: %d (%m)\n", ret);
+		goto out;
+	}
+
+	/* sync with parent */
+	efd = eventfd(0, EFD_CLOEXEC);
+	if (efd < 0) {
+		ret = -errno;
+		kdbus_printf("error eventfd: %d (%m)\n", ret);
+		goto out;
+	}
+
+	pid = syscall(__NR_clone, SIGCHLD | CLONE_NEWUSER, NULL);
+	if (pid < 0) {
+		ret = -errno;
+		kdbus_printf("error clone: %d (%m)\n", ret);
+
+		/* Unprivileged can't create user namespace ? */
+		if (ret == -EPERM) {
+			kdbus_printf("-- CLONE_NEWUSER TEST Failed for "
+				     "uid: %u\n -- Make sure that your kernel "
+				     "do not allow CLONE_NEWUSER for "
+				     "unprivileged users\n",
+				uid);
+			test_status = TEST_SKIP;
+		}
+
+		goto out;
+	}
+
+	if (pid == 0) {
+		struct kdbus_conn *conn_src;
+		eventfd_t event_status = 0;
+
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (ret < 0) {
+			ret = -errno;
+			kdbus_printf("error prctl: %d (%m)\n", ret);
+			_exit(TEST_ERR);
+		}
+
+		ret = eventfd_read(efd, &event_status);
+		if (ret < 0 || event_status != 1)
+			_exit(TEST_ERR);
+
+		/* ping connection from the new user namespace */
+		conn_src = kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(conn_src);
+
+		ret = kdbus_add_match_empty(conn_src);
+		ASSERT_EXIT(ret == 0);
+
+		ret = kdbus_msg_send(conn_src, NULL, 0xabcd1234,
+				     0, 0, 0, conn->id);
+		ASSERT_EXIT(ret == 0);
+
+		kdbus_conn_free(conn_src);
+		_exit(TEST_OK);
+	}
+
+	ret = userns_map_uid_gid(pid, "0 65534 1", "0 65534 1");
+	if (ret < 0) {
+		/* send error to child */
+		eventfd_write(efd, 2);
+		kdbus_printf("error mapping uid/gid in new user namespace\n");
+		goto out;
+	}
+
+	ret = eventfd_write(efd, 1);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error eventfd_write: %d (%m)\n", ret);
+		goto out;
+	}
+
+	ret = waitpid(pid, &status, 0);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error waitpid: %d (%m)\n", ret);
+		goto out;
+	}
+
+	if (WIFEXITED(status))
+		test_status = WEXITSTATUS(status);
+
+out:
+	if (efd != -1)
+		close(efd);
+
+	return test_status;
+}
+
+/* Get only the first item */
+static struct kdbus_item *kdbus_get_item(struct kdbus_msg *msg,
+					 uint64_t type)
+{
+	struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type == type)
+			return item;
+
+	return NULL;
+}
+
+static int kdbus_clone_userns_test(const char *bus, struct kdbus_conn *conn)
+{
+	int ret;
+	pid_t pid;
+	int status;
+	struct kdbus_msg *msg;
+	const struct kdbus_item *item;
+	/* unpriv user will create its user_ns and change its uid/gid */
+	const struct kdbus_creds unpriv_cached_creds = {
+		.uid	= UNPRIV_UID,
+		.gid	= UNPRIV_GID,
+	};
+
+	kdbus_printf("STARTING TEST 'metadata-ns' in a new user namespace.\n");
+
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, -errno);
+
+	if (pid == 0) {
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT_VAL(ret == 0, -errno);
+
+		ret = __kdbus_clone_userns_test(bus, conn);
+		_exit(ret);
+	}
+
+	/* Receive in the original (root privileged) user namespace */
+	ret = kdbus_msg_recv_poll(conn, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* We do not get KDBUS_ITEM_CAPS */
+	item = kdbus_get_item(msg, KDBUS_ITEM_CAPS);
+	ASSERT_RETURN(item == NULL);
+
+	item = kdbus_get_item(msg, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(item);
+
+	/*
+	 * Compare received items, creds must be translated into
+	 * the domain user namespace, so that used is unprivileged
+	 */
+	ASSERT_RETURN(item->creds.uid == unpriv_cached_creds.uid &&
+		      item->creds.gid == unpriv_cached_creds.gid);
+
+	kdbus_msg_free(msg);
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN(ret >= 0);
+
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+
+	return TEST_OK;
+}
+
+int kdbus_test_metadata_ns(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_conn *holder, *conn;
+	struct kdbus_policy_access policy_access = {
+		/* Allow world so we can inspect metadata in namespace */
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	/* we require user-namespaces */
+	if (access("/proc/self/uid_map", F_OK) != 0)
+		return TEST_SKIP;
+
+	ret = test_is_capable(CAP_SETUID, CAP_SETGID, CAP_SYS_ADMIN, -1);
+	ASSERT_RETURN(ret >= 0);
+
+	/* no enough privileges, SKIP test */
+	if (!ret)
+		return TEST_SKIP;
+
+	holder = kdbus_hello_registrar(env->buspath, "com.example.metadata",
+				       &policy_access, 1,
+				       KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder);
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret = kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_acquire(conn, "com.example.metadata", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	ret = kdbus_clone_userns_test(env->buspath, conn);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(holder);
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-monitor.c b/tools/testing/selftests/kdbus/test-monitor.c
new file mode 100644
index 000000000000..dfda5dccb7af
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-monitor.c
@@ -0,0 +1,156 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <assert.h>
+#include <signal.h>
+#include <sys/time.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static bool kdbus_item_in_message(struct kdbus_msg *msg,
+				  uint64_t type)
+{
+	const struct kdbus_item *item;
+
+	KDBUS_ITEM_FOREACH(item, msg, items)
+		if (item->type == type)
+			return true;
+
+	return false;
+}
+
+int kdbus_test_monitor(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *monitor, *conn;
+	unsigned int cookie = 0xdeadbeef;
+	struct kdbus_msg *msg;
+	uint64_t offset = 0;
+	int ret;
+
+	monitor = kdbus_hello(env->buspath, KDBUS_HELLO_MONITOR, NULL, 0);
+	ASSERT_RETURN(monitor);
+
+	/* check that we can acquire a name */
+	ret = kdbus_name_acquire(monitor, "foo.bar.baz", NULL);
+	ASSERT_RETURN(ret == -EOPNOTSUPP);
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0,  0, conn->id);
+	ASSERT_RETURN(ret == 0);
+
+	/* the recipient should have got the message */
+	ret = kdbus_msg_recv(conn, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+	kdbus_msg_free(msg);
+	kdbus_free(conn, offset);
+
+	/* and so should the monitor */
+	ret = kdbus_msg_recv(monitor, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	cookie++;
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	/* The monitor did not install matches, this will timeout */
+	ret = kdbus_msg_recv_poll(monitor, 100, NULL, NULL);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	/* Install empty match for monitor */
+	ret = kdbus_add_match_empty(monitor);
+	ASSERT_RETURN(ret == 0);
+
+	cookie++;
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	/* The monitor should get the message now. */
+	ret = kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	/*
+	 * Since we are the only monitor, update the attach flags
+	 * and tell we are not interessted in attach flags
+	*/
+
+	ret = kdbus_conn_update_attach_flags(monitor, 0);
+	ASSERT_RETURN(ret == 0);
+
+	cookie++;
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	ret = kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	/*
+	 * Now we are interested in KDBUS_ITEM_TIMESTAMP and
+	 * KDBUS_ITEM_CREDS
+	 */
+	ret = kdbus_conn_update_attach_flags(monitor,
+					     KDBUS_ATTACH_TIMESTAMP |
+					     KDBUS_ATTACH_CREDS);
+	ASSERT_RETURN(ret == 0);
+
+	cookie++;
+	ret = kdbus_msg_send(env->conn, NULL, cookie, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv_poll(monitor, 100, &msg, &offset);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(msg->cookie == cookie);
+
+	ret = kdbus_item_in_message(msg, KDBUS_ITEM_TIMESTAMP);
+	ASSERT_RETURN(ret == 1);
+
+	ret = kdbus_item_in_message(msg, KDBUS_ITEM_CREDS);
+	ASSERT_RETURN(ret == 1);
+
+	/* the KDBUS_ITEM_PID_COMM was not requested */
+	ret = kdbus_item_in_message(msg, KDBUS_ITEM_PID_COMM);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_msg_free(msg);
+	kdbus_free(monitor, offset);
+
+	kdbus_conn_free(monitor);
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-names.c b/tools/testing/selftests/kdbus/test-names.c
new file mode 100644
index 000000000000..83d479646315
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-names.c
@@ -0,0 +1,184 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <limits.h>
+#include <sys/ioctl.h>
+#include <getopt.h>
+#include <stdbool.h>
+
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+#include "kdbus-test.h"
+
+static int conn_is_name_owner(const struct kdbus_conn *conn,
+			      const char *needle)
+{
+	struct kdbus_cmd_name_list cmd_list;
+	struct kdbus_name_list *list;
+	struct kdbus_name_info *name;
+	bool found = false;
+	int ret;
+
+	cmd_list.flags = KDBUS_NAME_LIST_NAMES;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_NAME_LIST, &cmd_list);
+	ASSERT_RETURN(ret == 0);
+
+	list = (struct kdbus_name_list *)(conn->buf + cmd_list.offset);
+	KDBUS_ITEM_FOREACH(name, list, names) {
+		struct kdbus_item *item;
+		const char *n = NULL;
+
+		KDBUS_ITEM_FOREACH(item, name, items)
+			if (item->type == KDBUS_ITEM_OWNED_NAME)
+				n = item->name.name;
+
+		if (name->owner_id == conn->id &&
+		    n && strcmp(needle, n) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	ret = kdbus_free(conn, cmd_list.offset);
+	ASSERT_RETURN(ret == 0);
+
+	return found ? 0 : -1;
+}
+
+int kdbus_test_name_basic(struct kdbus_test_env *env)
+{
+	char *name, *dot_name, *invalid_name, *wildcard_name;
+	int ret;
+
+	name = "foo.bla.blaz";
+	dot_name = ".bla.blaz";
+	invalid_name = "foo";
+	wildcard_name = "foo.bla.bl.*";
+
+	/* Name is not valid, must fail */
+	ret = kdbus_name_acquire(env->conn, dot_name, NULL);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	ret = kdbus_name_acquire(env->conn, invalid_name, NULL);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	ret = kdbus_name_acquire(env->conn, wildcard_name, NULL);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	/* check that we can acquire a name */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* ... and release it again */
+	ret = kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	ret = conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret != 0);
+
+	/* check that we can't release it again */
+	ret = kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == -ESRCH);
+
+	/* check that we can't release a name that we don't own */
+	ret = kdbus_name_release(env->conn, "foo.bar.xxx");
+	ASSERT_RETURN(ret == -ESRCH);
+
+	/* Name is not valid, must fail */
+	ret = kdbus_name_release(env->conn, dot_name);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	ret = kdbus_name_release(env->conn, invalid_name);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	ret = kdbus_name_release(env->conn, wildcard_name);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	return TEST_OK;
+}
+
+int kdbus_test_name_conflict(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	char *name;
+	int ret;
+
+	name = "foo.bla.blaz";
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	/* allow the new connection to own the same name */
+	/* acquire name from the 1st connection */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* check that we can't acquire it again from the 1st connection */
+	ret = kdbus_name_acquire(env->conn, name, NULL);
+	ASSERT_RETURN(ret == -EALREADY);
+
+	/* check that we also can't acquire it again from the 2nd connection */
+	ret = kdbus_name_acquire(conn, name, NULL);
+	ASSERT_RETURN(ret == -EEXIST);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
+
+int kdbus_test_name_queue(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn;
+	const char *name;
+	uint64_t flags;
+	int ret;
+
+	name = "foo.bla.blaz";
+
+	flags = KDBUS_NAME_ALLOW_REPLACEMENT;
+
+	/* create a 2nd connection */
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn != NULL);
+
+	/* allow the new connection to own the same name */
+	/* acquire name from the 1st connection */
+	ret = kdbus_name_acquire(env->conn, name, &flags);
+	ASSERT_RETURN(ret == 0);
+
+	ret = conn_is_name_owner(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* queue the 2nd connection as waiting owner */
+	flags = KDBUS_NAME_QUEUE;
+	ret = kdbus_name_acquire(conn, name, &flags);
+	ASSERT_RETURN(ret == 0);
+	ASSERT_RETURN(flags & KDBUS_NAME_IN_QUEUE);
+
+	/* release name from 1st connection */
+	ret = kdbus_name_release(env->conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	/* now the name should be owned by the 2nd connection */
+	ret = conn_is_name_owner(conn, name);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(conn);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy-ns.c b/tools/testing/selftests/kdbus/test-policy-ns.c
new file mode 100644
index 000000000000..eea9e16e3418
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy-ns.c
@@ -0,0 +1,622 @@
+/*
+ * Copyright (C) 2014 Djalal Harouni
+ *
+ * kdbus is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU Lesser General Public License as published by the
+ * Free Software Foundation; either version 2.1 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <errno.h>
+#include <signal.h>
+#include <sys/wait.h>
+#include <sys/prctl.h>
+#include <sys/ioctl.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <linux/sched.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+#define MAX_CONN	64
+#define POLICY_NAME	"foo.test.policy-test"
+
+#define KDBUS_CONN_MAX_MSGS_PER_USER            16
+
+/**
+ * Note: this test can be used to inspect policy_db->talk_access_hash
+ *
+ * The purpose of these tests:
+ * 1) Check KDBUS_POLICY_TALK
+ * 2) Check the cache state: kdbus_policy_db->talk_access_hash
+ * Should be extended
+ */
+
+/**
+ * Check a list of connections against conn_db[0]
+ * conn_db[0] will own the name "foo.test.policy-test" and the
+ * policy holder connection for this name will update the policy
+ * entries, so different use cases can be tested.
+ */
+static struct kdbus_conn **conn_db;
+
+static void *kdbus_recv_echo(void *ptr)
+{
+	int ret;
+	struct kdbus_conn *conn = ptr;
+
+	ret = kdbus_msg_recv_poll(conn, 200, NULL, NULL);
+
+	return (void *)(long)ret;
+}
+
+/* Trigger kdbus_policy_set() */
+static int kdbus_set_policy_talk(struct kdbus_conn *conn,
+				 const char *name,
+				 uid_t id, unsigned int type)
+{
+	int ret;
+	struct kdbus_policy_access access = {
+		.type = type,
+		.id = id,
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(conn, name, &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	return TEST_OK;
+}
+
+/* return TEST_OK or TEST_ERR on failure */
+static int kdbus_register_same_activator(char *bus, const char *name,
+					 struct kdbus_conn **c)
+{
+	int ret;
+	struct kdbus_conn *activator;
+
+	activator = kdbus_hello_activator(bus, name, NULL, 0);
+	if (activator) {
+		*c = activator;
+		fprintf(stderr, "--- error was able to register name twice '%s'.\n",
+			name);
+		return TEST_ERR;
+	}
+
+	ret = -errno;
+	/* -EEXIST means test succeeded */
+	if (ret == -EEXIST)
+		return TEST_OK;
+
+	return TEST_ERR;
+}
+
+/* return TEST_OK or TEST_ERR on failure */
+static int kdbus_register_policy_holder(char *bus, const char *name,
+					struct kdbus_conn **conn)
+{
+	struct kdbus_conn *c;
+	struct kdbus_policy_access access[2];
+
+	access[0].type = KDBUS_POLICY_ACCESS_USER;
+	access[0].access = KDBUS_POLICY_OWN;
+	access[0].id = geteuid();
+
+	access[1].type = KDBUS_POLICY_ACCESS_WORLD;
+	access[1].access = KDBUS_POLICY_TALK;
+	access[1].id = geteuid();
+
+	c = kdbus_hello_registrar(bus, name, access, 2,
+				  KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(c);
+
+	*conn = c;
+
+	return TEST_OK;
+}
+
+/**
+ * Create new threads for receiving from multiple senders,
+ * The 'conn_db' will be populated by newly created connections.
+ * Caller should free all allocated connections.
+ *
+ * return 0 on success, negative errno on failure.
+ */
+static int kdbus_recv_in_threads(const char *bus, const char *name,
+				 struct kdbus_conn **conn_db)
+{
+	int ret;
+	bool pool_full = false;
+	unsigned int sent_packets = 0;
+	unsigned int lost_packets = 0;
+	unsigned int i, tid;
+	unsigned long dst_id;
+	unsigned long cookie = 1;
+	unsigned int thread_nr = MAX_CONN - 1;
+	pthread_t thread_id[MAX_CONN - 1] = {'\0'};
+
+	dst_id = name ? KDBUS_DST_ID_NAME : conn_db[0]->id;
+
+	for (tid = 0, i = 1; tid < thread_nr; tid++, i++) {
+		ret = pthread_create(&thread_id[tid], NULL,
+				     kdbus_recv_echo, (void *)conn_db[0]);
+		if (ret < 0) {
+			ret = -errno;
+			kdbus_printf("error pthread_create: %d (%m)\n",
+				      ret);
+			break;
+		}
+
+		/* just free before re-using */
+		kdbus_conn_free(conn_db[i]);
+		conn_db[i] = NULL;
+
+		/* We need to create connections here */
+		conn_db[i] = kdbus_hello(bus, 0, NULL, 0);
+		if (!conn_db[i]) {
+			ret = -errno;
+			break;
+		}
+
+		ret = kdbus_add_match_empty(conn_db[i]);
+		if (ret < 0)
+			break;
+
+		ret = kdbus_msg_send(conn_db[i], name, cookie++,
+				     0, 0, 0, dst_id);
+		if (ret < 0) {
+			/*
+			 * Receivers are not reading their messages,
+			 * not scheduled ?!
+			 *
+			 * So set the pool full here, perhaps the
+			 * connection pool or queue was full, later
+			 * recheck receivers errors
+			 */
+			if (ret == -ENOBUFS || ret == -EXFULL)
+				pool_full = true;
+			break;
+		}
+
+		sent_packets++;
+	}
+
+	for (tid = 0; tid < thread_nr; tid++) {
+		int thread_ret = 0;
+
+		if (thread_id[tid]) {
+			pthread_join(thread_id[tid], (void *)&thread_ret);
+			if (thread_ret < 0) {
+				/* Update only if send did not fail */
+				if (ret == 0)
+					ret = thread_ret;
+
+				lost_packets++;
+			}
+		}
+	}
+
+	/*
+	 * When sending if we did fail with -ENOBUFS or -EXFULL
+	 * then we should have set lost_packet and we should at
+	 * least have sent_packets set to KDBUS_CONN_MAX_MSGS_PER_USER
+	 */
+	if (pool_full) {
+		ASSERT_RETURN(lost_packets > 0);
+
+		/*
+		 * We should at least send KDBUS_CONN_MAX_MSGS_PER_USER
+		 *
+		 * For every send operation we create a thread to
+		 * recv the packet, so we keep the queue clean
+		 */
+		ASSERT_RETURN(sent_packets >= KDBUS_CONN_MAX_MSGS_PER_USER);
+
+		/*
+		 * Set ret to zero since we only failed due to
+		 * the receiving threads that have not been
+		 * scheduled
+		 */
+		ret = 0;
+	}
+
+	return ret;
+}
+
+/* Return: TEST_OK or TEST_ERR on failure */
+static int kdbus_normal_test(const char *bus, const char *name,
+			     struct kdbus_conn **conn_db)
+{
+	int ret;
+
+	ret = kdbus_recv_in_threads(bus, name, conn_db);
+	ASSERT_RETURN(ret >= 0);
+
+	return TEST_OK;
+}
+
+static int kdbus_fork_test_by_id(const char *bus,
+				 struct kdbus_conn **conn_db,
+				 int parent_status, int child_status)
+{
+	int ret;
+	pid_t pid;
+	uint64_t cookie = 0x9876ecba;
+	struct kdbus_msg *msg = NULL;
+	uint64_t offset = 0;
+	int status = 0;
+
+	/*
+	 * If the child_status is not EXIT_SUCCESS, then we expect
+	 * that sending from the child will fail, thus receiving
+	 * from parent must error with -ETIMEDOUT, and vice versa.
+	 */
+	bool parent_timedout = !!child_status;
+	bool child_timedout = !!parent_status;
+
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, pid);
+
+	if (pid == 0) {
+		struct kdbus_conn *conn_src;
+
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret == 0);
+
+		ret = drop_privileges(65534, 65534);
+		ASSERT_EXIT(ret == 0);
+
+		conn_src = kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(conn_src);
+
+		ret = kdbus_add_match_empty(conn_src);
+		ASSERT_EXIT(ret == 0);
+
+		/*
+		 * child_status is always checked against send
+		 * operations, in case it fails always return
+		 * EXIT_FAILURE.
+		 */
+		ret = kdbus_msg_send(conn_src, NULL, cookie,
+				     0, 0, 0, conn_db[0]->id);
+		ASSERT_EXIT(ret == child_status);
+
+		ret = kdbus_msg_recv_poll(conn_src, 100, NULL, NULL);
+
+		kdbus_conn_free(conn_src);
+
+		/*
+		 * Child kdbus_msg_recv_poll() should timeout since
+		 * the parent_status was set to a non EXIT_SUCCESS
+		 * value.
+		 */
+		if (child_timedout)
+			_exit(ret == -ETIMEDOUT ? EXIT_SUCCESS : EXIT_FAILURE);
+
+		_exit(ret == 0 ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret = kdbus_msg_recv_poll(conn_db[0], 100, &msg, &offset);
+	/*
+	 * If parent_timedout is set then this should fail with
+	 * -ETIMEDOUT since the child_status was set to a non
+	 * EXIT_SUCCESS value. Otherwise, assume
+	 * that kdbus_msg_recv_poll() has succeeded.
+	 */
+	if (parent_timedout) {
+		ASSERT_RETURN_VAL(ret == -ETIMEDOUT, TEST_ERR);
+
+		/* timedout no need to continue, we don't have the
+		 * child connection ID, so just terminate. */
+		goto out;
+	} else {
+		ASSERT_RETURN_VAL(ret == 0, ret);
+	}
+
+	ret = kdbus_msg_send(conn_db[0], NULL, ++cookie,
+			     0, 0, 0, msg->src_id);
+	/*
+	 * parent_status is checked against send operations,
+	 * on failures always return TEST_ERR.
+	 */
+	ASSERT_RETURN_VAL(ret == parent_status, TEST_ERR);
+
+	kdbus_msg_free(msg);
+	kdbus_free(conn_db[0], offset);
+
+out:
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >= 0, ret);
+
+	return (status == EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+/*
+ * Return: TEST_OK, TEST_ERR or TEST_SKIP
+ * we return TEST_OK only if the children return with the expected
+ * 'expected_status' that is specified as an argument.
+ */
+static int kdbus_fork_test(const char *bus, const char *name,
+			   struct kdbus_conn **conn_db, int expected_status)
+{
+	pid_t pid;
+	int ret = 0;
+	int status = 0;
+
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, pid);
+
+	if (pid == 0) {
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret == 0);
+
+		ret = drop_privileges(65534, 65534);
+		ASSERT_EXIT(ret == 0);
+
+		ret = kdbus_recv_in_threads(bus, name, conn_db);
+		_exit(ret == expected_status ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN(ret >= 0);
+
+	return (status == EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+/* Return EXIT_SUCCESS, EXIT_FAILURE or negative errno */
+static int __kdbus_clone_userns_test(const char *bus,
+				     const char *name,
+				     struct kdbus_conn **conn_db,
+				     int expected_status)
+{
+	int efd;
+	pid_t pid;
+	int ret = 0;
+	unsigned int uid = 65534;
+	int status;
+
+	ret = drop_privileges(uid, uid);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	/*
+	 * Since we just dropped privileges, the dumpable flag was just
+	 * cleared which makes the /proc/$clone_child/uid_map to be
+	 * owned by root, hence any userns uid mapping will fail with
+	 * -EPERM since the mapping will be done by uid 65534.
+	 *
+	 * To avoid this set the dumpable flag again which makes procfs
+	 * update the /proc/$clone_child/ inodes owner to 65534.
+	 *
+	 * Using this we will be able write to /proc/$clone_child/uid_map
+	 * as uid 65534 and map the uid 65534 to 0 inside the user
+	 * namespace.
+	 */
+	ret = prctl(PR_SET_DUMPABLE, SUID_DUMP_USER);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	/* sync parent/child */
+	efd = eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >= 0, efd);
+
+	pid = syscall(__NR_clone, SIGCHLD|CLONE_NEWUSER, NULL);
+	if (pid < 0) {
+		ret = -errno;
+		kdbus_printf("error clone: %d (%m)\n", ret);
+		/*
+		 * Normal user not allowed to create userns,
+		 * so nothing to worry about ?
+		 */
+		if (ret == -EPERM) {
+			kdbus_printf("-- CLONE_NEWUSER TEST Failed for uid: %u\n"
+				"-- Make sure that your kernel do not allow "
+				"CLONE_NEWUSER for unprivileged users\n"
+				"-- Upstream Commit: "
+				"https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5eaf563e\n",
+				uid);
+			ret = 0;
+		}
+
+		return ret;
+	}
+
+	if (pid == 0) {
+		struct kdbus_conn *conn_src;
+		eventfd_t event_status = 0;
+
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		ASSERT_EXIT(ret == 0);
+
+		ret = eventfd_read(efd, &event_status);
+		ASSERT_EXIT(ret >= 0 && event_status == 1);
+
+		/* ping connection from the new user namespace */
+		conn_src = kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(conn_src);
+
+		ret = kdbus_add_match_empty(conn_src);
+		ASSERT_EXIT(ret == 0);
+
+		ret = kdbus_msg_send(conn_src, name, 0xabcd1234,
+				     0, 0, 0, KDBUS_DST_ID_NAME);
+		kdbus_conn_free(conn_src);
+
+		_exit(ret == expected_status ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	ret = userns_map_uid_gid(pid, "0 65534 1", "0 65534 1");
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	/* Tell child we are ready */
+	ret = eventfd_write(efd, 1);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >= 0, ret);
+
+	close(efd);
+
+	return status == EXIT_SUCCESS ? TEST_OK : TEST_ERR;
+}
+
+static int kdbus_clone_userns_test(const char *bus,
+				   const char *name,
+				   struct kdbus_conn **conn_db,
+				   int expected_status)
+{
+	pid_t pid;
+	int ret = 0;
+	int status;
+
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, -errno);
+
+	if (pid == 0) {
+		ret = prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (ret < 0)
+			_exit(EXIT_FAILURE);
+
+		ret = __kdbus_clone_userns_test(bus, name, conn_db,
+						expected_status);
+		_exit(ret);
+	}
+
+	/*
+	 * Receive in the original (root privileged) user namespace,
+	 * must fail with -ETIMEDOUT.
+	 */
+	ret = kdbus_msg_recv_poll(conn_db[0], 100, NULL, NULL);
+	ASSERT_RETURN_VAL(ret == -ETIMEDOUT, ret);
+
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >= 0, ret);
+
+	return (status == EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+int kdbus_test_policy_ns(struct kdbus_test_env *env)
+{
+	int i;
+	int ret;
+	struct kdbus_conn *activator = NULL;
+	struct kdbus_conn *policy_holder = NULL;
+	char *bus = env->buspath;
+
+	if (geteuid() > 0) {
+		kdbus_printf("error geteuid() != 0, %s() needs root\n",
+			     __func__);
+		return TEST_SKIP;
+	}
+
+	/* we require user-namespaces */
+	if (access("/proc/self/uid_map", F_OK) != 0)
+		return TEST_SKIP;
+
+	conn_db = calloc(MAX_CONN, sizeof(struct kdbus_conn *));
+	ASSERT_RETURN(conn_db);
+
+	memset(conn_db, 0, MAX_CONN * sizeof(struct kdbus_conn *));
+
+	conn_db[0] = kdbus_hello(bus, 0, NULL, 0);
+	ASSERT_RETURN(conn_db[0]);
+
+	ret = kdbus_add_match_empty(conn_db[0]);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_fork_test_by_id(bus, conn_db, -EPERM, -EPERM);
+	ASSERT_EXIT(ret == 0);
+
+	ret = kdbus_register_policy_holder(bus, POLICY_NAME,
+					   &policy_holder);
+	ASSERT_RETURN(ret == 0);
+
+	/* Try to register the same name with an activator */
+	ret = kdbus_register_same_activator(bus, POLICY_NAME,
+					    &activator);
+	ASSERT_RETURN(ret == 0);
+
+	/* Acquire POLICY_NAME */
+	ret = kdbus_name_acquire(conn_db[0], POLICY_NAME, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_normal_test(bus, POLICY_NAME, conn_db);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_name_list(conn_db[0], KDBUS_NAME_LIST_NAMES |
+					  KDBUS_NAME_LIST_UNIQUE |
+					  KDBUS_NAME_LIST_ACTIVATORS |
+					  KDBUS_NAME_LIST_QUEUED);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_fork_test(bus, POLICY_NAME, conn_db, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * children connections are able to talk to conn_db[0] since
+	 * current POLICY_NAME TALK type is KDBUS_POLICY_ACCESS_WORLD,
+	 * so expect EXIT_SUCCESS when sending from child. However,
+	 * since the child's connection does not own any well-known
+	 * name, The parent connection conn_db[0] should fail with
+	 * -EPERM but since it is a privileged bus user the TALK is
+	 *  allowed.
+	 */
+	ret = kdbus_fork_test_by_id(bus, conn_db,
+				    EXIT_SUCCESS, EXIT_SUCCESS);
+	ASSERT_EXIT(ret == 0);
+
+	/*
+	 * Connections that can talk are perhaps being destroyed now.
+	 * Restrict the policy and purge cache entries where the
+	 * conn_db[0] is the destination.
+	 *
+	 * Now only connections with uid == 0 are allowed to talk.
+	 */
+	ret = kdbus_set_policy_talk(policy_holder, POLICY_NAME,
+				    geteuid(), KDBUS_POLICY_ACCESS_USER);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Testing connections (FORK+DROP) again:
+	 * After setting the policy re-check connections
+	 * we expect the children to fail with -EPERM
+	 */
+	ret = kdbus_fork_test(bus, POLICY_NAME, conn_db, -EPERM);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Now expect that both parent and child to fail.
+	 *
+	 * Child should fail with -EPERM since we just restricted
+	 * the POLICY_NAME TALK to uid 0 and its uid is 65534.
+	 *
+	 * Since the parent's connection will timeout when receiving
+	 * from the child, we never continue. FWIW just put -EPERM.
+	 */
+	ret = kdbus_fork_test_by_id(bus, conn_db, -EPERM, -EPERM);
+	ASSERT_EXIT(ret == 0);
+
+	/* Check if the name can be reached in a new userns */
+	ret = kdbus_clone_userns_test(bus, POLICY_NAME, conn_db, -EPERM);
+	ASSERT_RETURN(ret == 0);
+
+	for (i = 0; i < MAX_CONN; i++)
+		kdbus_conn_free(conn_db[i]);
+
+	kdbus_conn_free(activator);
+	kdbus_conn_free(policy_holder);
+
+	free(conn_db);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy-priv.c b/tools/testing/selftests/kdbus/test-policy-priv.c
new file mode 100644
index 000000000000..3463792c0f58
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy-priv.c
@@ -0,0 +1,1168 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <time.h>
+#include <sys/capability.h>
+#include <sys/eventfd.h>
+#include <sys/ioctl.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static int test_policy_priv_by_id(const char *bus,
+				  struct kdbus_conn *conn_dst,
+				  bool drop_second_user,
+				  int parent_status,
+				  int child_status)
+{
+	int ret;
+	uint64_t expected_cookie = time(NULL) ^ 0xdeadbeef;
+
+	ASSERT_RETURN(conn_dst);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, bus, ({
+		ret = kdbus_msg_send(unpriv, NULL,
+				     expected_cookie, 0, 0, 0,
+				     conn_dst->id);
+		ASSERT_EXIT(ret == child_status);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(conn_dst, 100, NULL, NULL);
+	ASSERT_RETURN(ret == parent_status);
+
+	return 0;
+}
+
+static int test_policy_priv_by_broadcast(const char *bus,
+					 struct kdbus_conn *conn_dst,
+					 int drop_second_user,
+					 int parent_status,
+					 int child_status)
+{
+	int ret;
+	int efd;
+	eventfd_t event_status = 0;
+	struct kdbus_msg *msg = NULL;
+	uid_t second_uid = UNPRIV_UID;
+	gid_t second_gid = UNPRIV_GID;
+	struct kdbus_conn *child_2 = conn_dst;
+	uint64_t expected_cookie = time(NULL) ^ 0xdeadbeef;
+
+	/* Drop to another unprivileged user other than UNPRIV_UID */
+	if (drop_second_user == DROP_OTHER_UNPRIV) {
+		second_uid = UNPRIV_UID - 1;
+		second_gid = UNPRIV_GID - 1;
+	}
+
+	/* child will signal parent to send broadcast */
+	efd = eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >= 0, efd);
+
+	ret = RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *child;
+
+		child = kdbus_hello(bus, 0, NULL, 0);
+		ASSERT_EXIT(child);
+
+		ret = kdbus_add_match_empty(child);
+		ASSERT_EXIT(ret == 0);
+
+		/* signal parent */
+		ret = eventfd_write(efd, 1);
+		ASSERT_EXIT(ret == 0);
+
+		ret = kdbus_msg_recv_poll(child, 300, &msg, NULL);
+		ASSERT_EXIT(ret == child_status);
+
+		/*
+		 * If we expect the child to get the broadcast
+		 * message, then check the received cookie.
+		 */
+		if (ret == 0) {
+			ASSERT_EXIT(expected_cookie == msg->cookie);
+		}
+
+		/* Use expected_cookie since 'msg' might be NULL */
+		ret = kdbus_msg_send(child, NULL, expected_cookie + 1,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret == 0);
+
+		kdbus_msg_free(msg);
+		kdbus_conn_free(child);
+	}),
+	({
+		if (drop_second_user == DO_NOT_DROP) {
+			ASSERT_RETURN(child_2);
+
+			ret = eventfd_read(efd, &event_status);
+			ASSERT_RETURN(ret >= 0 && event_status == 1);
+
+			ret = kdbus_msg_send(child_2, NULL,
+					     expected_cookie, 0, 0, 0,
+					     KDBUS_DST_ID_BROADCAST);
+			ASSERT_RETURN(ret == 0);
+
+			ret = kdbus_msg_recv_poll(child_2, 300,
+						  &msg, NULL);
+			ASSERT_RETURN(ret == parent_status);
+
+			/*
+			 * Check returned cookie in case we expect
+			 * success.
+			 */
+			if (ret == 0) {
+				ASSERT_RETURN(msg->cookie ==
+					      expected_cookie + 1);
+			}
+
+			kdbus_msg_free(msg);
+		} else {
+			/*
+			 * Two unprivileged users will try to
+			 * communicate using broadcast.
+			 */
+			ret = RUN_UNPRIVILEGED(second_uid, second_gid, ({
+				child_2 = kdbus_hello(bus, 0, NULL, 0);
+				ASSERT_EXIT(child_2);
+
+				ret = kdbus_add_match_empty(child_2);
+				ASSERT_EXIT(ret == 0);
+
+				ret = eventfd_read(efd, &event_status);
+				ASSERT_RETURN(ret >= 0 && event_status == 1);
+
+				ret = kdbus_msg_send(child_2, NULL,
+						expected_cookie, 0, 0, 0,
+						KDBUS_DST_ID_BROADCAST);
+				ASSERT_EXIT(ret == 0);
+
+				ret = kdbus_msg_recv_poll(child_2, 100,
+							  &msg, NULL);
+				ASSERT_EXIT(ret == parent_status);
+
+				/*
+				 * Check returned cookie in case we expect
+				 * success.
+				 */
+				if (ret == 0) {
+					ASSERT_EXIT(msg->cookie ==
+						    expected_cookie + 1);
+				}
+
+				kdbus_msg_free(msg);
+				kdbus_conn_free(child_2);
+			}),
+			({ 0; }));
+		}
+	}));
+
+	close(efd);
+
+	return ret;
+}
+
+static void nosig(int sig)
+{
+}
+
+static int test_priv_before_policy_upload(struct kdbus_test_env *env)
+{
+	int ret;
+	struct kdbus_conn *conn;
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Make sure unprivileged bus user cannot acquire names
+	 * before registring any policy holder.
+	 */
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default
+	 * to privileged ones, unless a policy holder that allows
+	 * this was uploaded.
+	 */
+
+	ret = test_policy_priv_by_id(env->buspath, conn, false,
+				     -ETIMEDOUT, -EPERM);
+	ASSERT_RETURN(ret == 0);
+
+	/* Activate matching for a privileged connection */
+	ret = kdbus_add_match_empty(conn);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * First make sure that BROADCAST with msg flag
+	 * KDBUS_MSG_FLAGS_EXPECT_REPLY will fail with -ENOTUNIQ
+	 */
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, NULL, 0xdeadbeef,
+				     KDBUS_MSG_FLAGS_EXPECT_REPLY,
+				     5000000000ULL, 0,
+				     KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret == -ENOTUNIQ);
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Test broadcast with a privileged connection.
+	 *
+	 * The first receiver should get the broadcast message since
+	 * the sender is a privileged connection.
+	 *
+	 * The privileged connection should not get the broadcast
+	 * message since the sender is an unprivileged connection.
+	 * It will fail with -ETIMEDOUT.
+	 *
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, conn,
+					    DO_NOT_DROP,
+					    -ETIMEDOUT, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under the same user.
+	 *
+	 * Both connections should succeed.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_SAME_UNPRIV,
+					    EXIT_SUCCESS, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under different users.
+	 *
+	 * Both connections will fail with -ETIMEDOUT.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_OTHER_UNPRIV,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(conn);
+
+	return ret;
+}
+
+static int test_broadcast_after_policy_upload(struct kdbus_test_env *env)
+{
+	int ret;
+	int efd;
+	eventfd_t event_status = 0;
+	struct kdbus_msg *msg = NULL;
+	struct kdbus_conn *owner_a, *owner_b;
+	struct kdbus_conn *holder_a, *holder_b;
+	struct kdbus_policy_access access = {};
+	uint64_t expected_cookie = time(NULL) ^ 0xdeadbeef;
+
+	owner_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner_a);
+
+	ret = kdbus_name_acquire(owner_a, "com.example.broadcastA", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default
+	 * to privileged ones, unless a policy holder that allows
+	 * this was uploaded.
+	 */
+
+	ret = test_policy_priv_by_id(env->buspath, owner_a, false,
+				     -ETIMEDOUT, -EPERM);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Make sure that conn wont receive broadcasts unless it
+	 * installs a match.
+	 *
+	 * At same time check that the unprivileged connection will
+	 * receive the broadcast message from the privileged one.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, owner_a,
+					    DO_NOT_DROP,
+					    -ETIMEDOUT, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+	/* Activate matching for a privileged connection */
+	ret = kdbus_add_match_empty(owner_a);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Redo the previous test. The privileged conn won't receive
+	 * broadcast messages from the unprivileged one.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, owner_a,
+					    DO_NOT_DROP,
+					    -ETIMEDOUT, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Test that broadcast between two unprivileged users running
+	 * under the same user still succeed.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_SAME_UNPRIV,
+					    EXIT_SUCCESS, EXIT_SUCCESS);
+	ASSERT_RETURN(ret == 0);
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	holder_a = kdbus_hello_registrar(env->buspath,
+					 "com.example.broadcastA",
+					 &access, 1,
+					 KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder_a);
+
+	holder_b = kdbus_hello_registrar(env->buspath,
+					 "com.example.broadcastB",
+					 &access, 1,
+					 KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(holder_b);
+
+	owner_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner_b);
+
+	ret = kdbus_name_acquire(owner_b, "com.example.broadcastB", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/* Activate matching for a privileged connection */
+	ret = kdbus_add_match_empty(owner_b);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Test that even if "com.example.broadcastA" and
+	 * "com.example.broadcastB" do restrict TALK access by default
+	 * they are able to signal each other using broadcast due to
+	 * the fact they are privileged connections.
+	 */
+
+	ret = kdbus_msg_send(owner_a, NULL, 0xdeadbeef, 0, 0, 0,
+			     KDBUS_DST_ID_BROADCAST);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_msg_recv_poll(owner_b, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* Check src ID */
+	ASSERT_RETURN(msg->src_id == owner_a->id);
+
+	kdbus_msg_free(msg);
+	kdbus_free(owner_b, msg->offset_reply);
+
+
+	/* Release name "com.example.broadcastB" */
+
+	ret = kdbus_name_release(owner_b, "com.example.broadcastB");
+	ASSERT_EXIT(ret >= 0);
+
+	/* KDBUS_POLICY_OWN for unprivileged connections */
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	/* Update the policy so unprivileged will own the name */
+
+	ret = kdbus_conn_update_policy(holder_b,
+				       "com.example.broadcastB",
+				       &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Test broadcasts from an unprivileged connection that
+	 * owns a name.
+	 *
+	 * We'll have four destinations here:
+	 *
+	 * owner_a: privileged connection that owns
+	 * "com.example.broadcastA". TALK access are subject to policy
+	 * rules and they are stricted so it should not receive
+	 * the signal. Should fail with -ETIMEDOUT
+	 *
+	 * owner_b: privileged connection (running under a different
+	 * uid) that do not own names, but with an empty broadcast
+	 * match, so it will receive broadcasts. Should get the
+	 * message.
+	 *
+	 * unpriv_a: unpriv connection that do not own any name.
+	 * It will receive the broadcast since it is running under
+	 * the same user of the one broadcasting and did install
+	 * matches. It should get the message.
+	 *
+	 * unpriv_b: unpriv connection is not interested in broadcast
+	 * messages, so it did not install broadcast matches. Should
+	 * fail with -ETIMEDOUT
+	 */
+
+	++expected_cookie;
+	efd = eventfd(0, EFD_CLOEXEC);
+	ASSERT_RETURN_VAL(efd >= 0, efd);
+
+	ret = RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_UID, ({
+		struct kdbus_conn *unpriv_owner;
+		struct kdbus_conn *unpriv_a, *unpriv_b;
+
+		unpriv_owner = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_owner);
+
+		unpriv_a = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_a);
+
+		unpriv_b = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_EXIT(unpriv_b);
+
+		ret = kdbus_name_acquire(unpriv_owner,
+					 "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >= 0);
+
+		ret = kdbus_add_match_empty(unpriv_a);
+		ASSERT_EXIT(ret == 0);
+
+		/* Signal that we are doing broadcasts */
+		ret = eventfd_write(efd, 1);
+		ASSERT_EXIT(ret == 0);
+
+		/*
+		 * Do broadcast from a connection that owns the
+		 * names "com.example.broadcastB".
+		 */
+		ret = kdbus_msg_send(unpriv_owner, NULL,
+				     expected_cookie,
+				     0, 0, 0,
+				     KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret == 0);
+
+		/*
+		 * Unprivileged connection running under the same
+		 * user. It should succeed.
+		 */
+		ret = kdbus_msg_recv_poll(unpriv_a, 100, &msg, NULL);
+		ASSERT_EXIT(ret == 0 && msg->cookie == expected_cookie);
+
+		/* Not interested in broadcast */
+		ret = kdbus_msg_recv_poll(unpriv_b, 100, NULL, NULL);
+		ASSERT_EXIT(ret == -ETIMEDOUT);
+	}),
+	({
+		ret = eventfd_read(efd, &event_status);
+		ASSERT_RETURN(ret >= 0 && event_status == 1);
+
+		/*
+		 * owner_a must fail with -ETIMEDOUT, since it owns
+		 * name "com.example.broadcastA" and its TALK
+		 * access is restriced.
+		 */
+		ret = kdbus_msg_recv_poll(owner_a, 100, NULL, NULL);
+		ASSERT_RETURN(ret == -ETIMEDOUT);
+
+		/*
+		 * owner_b got the broadcast from an unprivileged
+		 * connection.
+		 */
+		ret = kdbus_msg_recv_poll(owner_b, 100, &msg, NULL);
+		ASSERT_RETURN(ret == 0);
+
+		/* confirm the received cookie */
+		ASSERT_RETURN(msg->cookie == expected_cookie);
+
+		kdbus_msg_free(msg);
+		kdbus_free(owner_b, msg->offset_reply);
+
+
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	close(efd);
+
+	/*
+	 * Test broadcast with two unprivileged connections running
+	 * under different users.
+	 *
+	 * Both connections will fail with -ETIMEDOUT.
+	 */
+
+	ret = test_policy_priv_by_broadcast(env->buspath, NULL,
+					    DROP_OTHER_UNPRIV,
+					    -ETIMEDOUT, -ETIMEDOUT);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Perform last tests, allow others to talk to name
+	 * "com.example.broadcastA". So now broadcasting to that
+	 * connection should succeed since the policy allow it.
+	 */
+
+	/* KDBUS_POLICY_OWN for unprivileged connections */
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(holder_a,
+				       "com.example.broadcastA",
+				       &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	++expected_cookie;
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >= 0);
+		ret = kdbus_msg_send(unpriv, NULL, expected_cookie,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret == 0);
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	/* owner_a will get the broadcast now. */
+	ret = kdbus_msg_recv_poll(owner_a, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* confirm the received cookie */
+	ASSERT_RETURN(msg->cookie == expected_cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(owner_a, msg->offset_reply);
+
+	/*
+	 * owner_a released name "com.example.broadcastA". It should
+	 * receive broadcasts, no more policies and it has a match.
+	 *
+	 * Unprivileged connection will own a name and will try to
+	 * signal to the privileged connection. It should succeeded.
+	 */
+
+	ret = kdbus_name_release(owner_a, "com.example.broadcastA");
+	ASSERT_EXIT(ret >= 0);
+
+	++expected_cookie;
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.broadcastB",
+					 NULL);
+		ASSERT_EXIT(ret >= 0);
+		ret = kdbus_msg_send(unpriv, NULL, expected_cookie,
+				     0, 0, 0, KDBUS_DST_ID_BROADCAST);
+		ASSERT_EXIT(ret == 0);
+	}));
+	ASSERT_RETURN(ret == 0);
+
+	/* owner_a will get the broadcast now. */
+	ret = kdbus_msg_recv_poll(owner_a, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	/* confirm the received cookie */
+	ASSERT_RETURN(msg->cookie == expected_cookie);
+
+	kdbus_msg_free(msg);
+	kdbus_free(owner_a, msg->offset_reply);
+
+	kdbus_conn_free(owner_a);
+	kdbus_conn_free(owner_b);
+	kdbus_conn_free(holder_a);
+	kdbus_conn_free(holder_b);
+
+	return 0;
+}
+
+static int test_policy_priv(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b, *conn, *owner;
+	struct kdbus_policy_access access, *acc;
+	sigset_t sset;
+	size_t num;
+	int ret;
+
+	/*
+	 * Make sure we have CAP_SETUID/SETGID so we can drop privileges
+	 */
+
+	ret = test_is_capable(CAP_SETUID, CAP_SETGID, -1);
+	ASSERT_RETURN(ret >= 0);
+
+	if (!ret)
+		return TEST_SKIP;
+
+	/*
+	 * Setup:
+	 *  conn_a: policy holder for com.example.a
+	 *  conn_b: name holder of com.example.b
+	 */
+
+	signal(SIGUSR1, nosig);
+	sigemptyset(&sset);
+	sigaddset(&sset, SIGUSR1);
+	sigprocmask(SIG_BLOCK, &sset, NULL);
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	/*
+	 * Before registering any policy holder, make sure that the
+	 * bus is secure by default. This test is necessary, it catches
+	 * several cases where old D-Bus was vulnerable.
+	 */
+
+	ret = test_priv_before_policy_upload(env);
+	ASSERT_RETURN(ret == 0);
+
+	/* Register policy holder */
+
+	conn_a = kdbus_hello_registrar(env->buspath, "com.example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a);
+
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_b);
+
+	ret = kdbus_name_acquire(conn_b, "com.example.b", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure bus-owners can always acquire names.
+	 */
+	ret = kdbus_name_acquire(conn, "com.example.a", NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	kdbus_conn_free(conn);
+
+	/*
+	 * Make sure unprivileged users cannot acquire names with default
+	 * policy assigned.
+	 */
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * world-accessible.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = 0,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * gid-accessible. But only if the gid matches.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_GROUP,
+		.id = UNPRIV_GID,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_GROUP,
+		.id = 1,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if we make them
+	 * uid-accessible. But only if the uid matches.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = UNPRIV_UID,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = 1,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged users cannot acquire names if no owner-policy
+	 * matches, even if SEE/TALK policies match.
+	 */
+
+	num = 4;
+	acc = (struct kdbus_policy_access[]){
+		{
+			.type = KDBUS_POLICY_ACCESS_GROUP,
+			.id = UNPRIV_GID,
+			.access = KDBUS_POLICY_SEE,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = UNPRIV_UID,
+			.access = KDBUS_POLICY_TALK,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_WORLD,
+			.id = 0,
+			.access = KDBUS_POLICY_TALK,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_WORLD,
+			.id = 0,
+			.access = KDBUS_POLICY_SEE,
+		},
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", acc, num);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret < 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged users can acquire names if the only matching
+	 * policy is somewhere in the middle.
+	 */
+
+	num = 5;
+	acc = (struct kdbus_policy_access[]){
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 1,
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 2,
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = UNPRIV_UID,
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 3,
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 4,
+			.access = KDBUS_POLICY_OWN,
+		},
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", acc, num);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_name_acquire(unpriv, "com.example.a", NULL);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Clear policies
+	 */
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", NULL, 0);
+	ASSERT_RETURN(ret == 0);
+
+	/*
+	 * Make sure privileged bus users can _always_ talk to others.
+	 */
+
+	conn = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn);
+
+	ret = kdbus_msg_send(conn, "com.example.b", 0xdeadbeef, 0, 0, 0, 0);
+	ASSERT_EXIT(ret >= 0);
+	ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	kdbus_conn_free(conn);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk by default.
+	 */
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to equals, even without
+	 * policy.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = UNPRIV_UID,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.c", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		struct kdbus_conn *owner;
+
+		owner = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(owner);
+
+		ret = kdbus_name_acquire(owner, "com.example.c", NULL);
+		ASSERT_EXIT(ret >= 0);
+
+		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+		ret = kdbus_msg_recv_poll(owner, 100, NULL, NULL);
+		ASSERT_EXIT(ret >= 0);
+
+		kdbus_conn_free(owner);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable UID policy is set.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = UNPRIV_UID,
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable GID policy is set.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_GROUP,
+		.id = UNPRIV_GID,
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable WORLD policy is set.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = 0,
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users cannot talk to privileged users if
+	 * no suitable policy is set.
+	 */
+
+	num = 5;
+	acc = (struct kdbus_policy_access[]){
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 0,
+			.access = KDBUS_POLICY_OWN,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 1,
+			.access = KDBUS_POLICY_TALK,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = UNPRIV_UID,
+			.access = KDBUS_POLICY_SEE,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 3,
+			.access = KDBUS_POLICY_TALK,
+		},
+		{
+			.type = KDBUS_POLICY_ACCESS_USER,
+			.id = 4,
+			.access = KDBUS_POLICY_TALK,
+		},
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", acc, num);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure unprivileged bus users can talk to privileged users if a
+	 * suitable OWN privilege overwrites TALK.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = 0,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+	ASSERT_EXIT(ret >= 0);
+
+	/*
+	 * Make sure the TALK cache is reset correctly when policies are
+	 * updated.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = 0,
+		.access = KDBUS_POLICY_TALK,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.b", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = RUN_UNPRIVILEGED_CONN(unpriv, env->buspath, ({
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+
+		ret = kdbus_msg_recv_poll(conn_b, 100, NULL, NULL);
+		ASSERT_EXIT(ret >= 0);
+
+		ret = kdbus_conn_update_policy(conn_a, "com.example.b",
+					       NULL, 0);
+		ASSERT_RETURN(ret == 0);
+
+		ret = kdbus_msg_send(unpriv, "com.example.b", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret == -EPERM);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+	/*
+	 * Make sure the TALK cache is reset correctly when policy holders
+	 * disconnect.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_WORLD,
+		.id = 0,
+		.access = KDBUS_POLICY_OWN,
+	};
+
+	conn = kdbus_hello_registrar(env->buspath, "com.example.c",
+				     NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn);
+
+	ret = kdbus_conn_update_policy(conn, "com.example.c", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	owner = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(owner);
+
+	ret = kdbus_name_acquire(owner, "com.example.c", NULL);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = RUN_UNPRIVILEGED(UNPRIV_UID, UNPRIV_GID, ({
+		struct kdbus_conn *unpriv;
+
+		/* wait for parent to be finished */
+		sigemptyset(&sset);
+		ret = sigsuspend(&sset);
+		ASSERT_RETURN(ret == -1 && errno == EINTR);
+
+		unpriv = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(unpriv);
+
+		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret >= 0);
+
+		ret = kdbus_msg_recv_poll(owner, 100, NULL, NULL);
+		ASSERT_EXIT(ret >= 0);
+
+		/* free policy holder */
+		kdbus_conn_free(conn);
+
+		ret = kdbus_msg_send(unpriv, "com.example.c", 0xdeadbeef, 0, 0,
+				     0, 0);
+		ASSERT_EXIT(ret == -EPERM);
+
+		kdbus_conn_free(unpriv);
+	}), ({
+		/* make sure policy holder is only valid in child */
+		kdbus_conn_free(conn);
+		kill(pid, SIGUSR1);
+	}));
+	ASSERT_RETURN(ret >= 0);
+
+
+	/*
+	 * The following tests are necessary.
+	 */
+
+	ret = test_broadcast_after_policy_upload(env);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_conn_free(owner);
+
+	/*
+	 * cleanup resources
+	 */
+
+	kdbus_conn_free(conn_b);
+	kdbus_conn_free(conn_a);
+
+	return TEST_OK;
+}
+
+int kdbus_test_policy_priv(struct kdbus_test_env *env)
+{
+	pid_t pid;
+	int ret;
+
+	/* make sure to exit() if a child returns from fork() */
+	pid = getpid();
+	ret = test_policy_priv(env);
+	if (pid != getpid())
+		exit(1);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/kdbus/test-policy.c b/tools/testing/selftests/kdbus/test-policy.c
new file mode 100644
index 000000000000..4eb6e65f96d1
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-policy.c
@@ -0,0 +1,81 @@
+#include <errno.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int kdbus_test_policy(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b;
+	struct kdbus_policy_access access;
+	int ret;
+
+	/* Invalid name */
+	conn_a = kdbus_hello_registrar(env->buspath, ".example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a == NULL);
+
+	conn_a = kdbus_hello_registrar(env->buspath, "example",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a == NULL);
+
+	conn_a = kdbus_hello_registrar(env->buspath, "com.example.a",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_a);
+
+	conn_b = kdbus_hello_registrar(env->buspath, "com.example.b",
+				       NULL, 0, KDBUS_HELLO_POLICY_HOLDER);
+	ASSERT_RETURN(conn_b);
+
+	/*
+	 * Verify there cannot be any duplicate entries, except for specific vs.
+	 * wildcard entries.
+	 */
+
+	access = (struct kdbus_policy_access){
+		.type = KDBUS_POLICY_ACCESS_USER,
+		.id = geteuid(),
+		.access = KDBUS_POLICY_SEE,
+	};
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_conn_update_policy(conn_b, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == -EEXIST);
+
+	ret = kdbus_conn_update_policy(conn_b, "com.example.a.*", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.a.*", &access, 1);
+	ASSERT_RETURN(ret == -EEXIST);
+
+	ret = kdbus_conn_update_policy(conn_a, "com.example.*", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_conn_update_policy(conn_b, "com.example.a", &access, 1);
+	ASSERT_RETURN(ret == 0);
+
+	ret = kdbus_conn_update_policy(conn_b, "com.example.*", &access, 1);
+	ASSERT_RETURN(ret == -EEXIST);
+
+	/* Invalid name */
+	ret = kdbus_conn_update_policy(conn_b, ".example.*", &access, 1);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	ret = kdbus_conn_update_policy(conn_b, "example", &access, 1);
+	ASSERT_RETURN(ret == -EINVAL);
+
+	kdbus_conn_free(conn_b);
+	kdbus_conn_free(conn_a);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-race.c b/tools/testing/selftests/kdbus/test-race.c
new file mode 100644
index 000000000000..75cec3fe28a1
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-race.c
@@ -0,0 +1,313 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <pthread.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+struct race_thread {
+	pthread_spinlock_t lock;
+	pthread_t thread;
+	int (*fn) (struct kdbus_test_env *env, void *ctx);
+	struct kdbus_test_env *env;
+	void *ctx;
+	int ret;
+};
+
+static void *race_thread_fn(void *data)
+{
+	struct race_thread *thread = data;
+	int ret;
+
+	ret = pthread_spin_lock(&thread->lock);
+	if (ret < 0)
+		goto error;
+
+	ret = thread->fn(thread->env, thread->ctx);
+	pthread_spin_unlock(&thread->lock);
+
+error:
+	return (void*)(long)ret;
+}
+
+static int race_thread_init(struct race_thread *thread)
+{
+	int ret;
+
+	ret = pthread_spin_init(&thread->lock, PTHREAD_PROCESS_PRIVATE);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = pthread_spin_lock(&thread->lock);
+	ASSERT_RETURN(ret >= 0);
+
+	ret = pthread_create(&thread->thread, NULL, race_thread_fn, thread);
+	ASSERT_RETURN(ret >= 0);
+
+	return TEST_OK;
+}
+
+static void race_thread_run(struct race_thread *thread,
+			    int (*fn)(struct kdbus_test_env *env, void *ctx),
+			    struct kdbus_test_env *env, void *ctx)
+{
+	int ret;
+
+	thread->fn = fn;
+	thread->env = env;
+	thread->ctx = ctx;
+
+	ret = pthread_spin_unlock(&thread->lock);
+	if (ret < 0)
+		abort();
+}
+
+static int race_thread_join(struct race_thread *thread)
+{
+	void *val = (void*)(long)-EFAULT;
+	int ret;
+
+	ret = pthread_join(thread->thread, &val);
+	ASSERT_RETURN(ret >= 0);
+
+	thread->ret = (long)val;
+
+	return TEST_OK;
+}
+
+static void shuffle(size_t *array, size_t n)
+{
+	size_t i, j, t;
+
+	if (n <= 1)
+		return;
+
+	for (i = 0; i < n - 1; i++) {
+		j = i + rand() / (RAND_MAX / (n - i) + 1);
+		t = array[j];
+		array[j] = array[i];
+		array[i] = t;
+	}
+}
+
+static int race_thread(int (*init_fn) (struct kdbus_test_env *env, void *ctx),
+		       int (*exit_fn) (struct kdbus_test_env *env, void *ctx,
+		                       int *ret, size_t n_ret),
+		       int (*verify_fn) (struct kdbus_test_env *env, void *ctx),
+		       int (**fns) (struct kdbus_test_env *env, void *ctx),
+		       size_t n_fns, struct kdbus_test_env *env, void *ctx,
+		       size_t runs)
+{
+	struct race_thread *t;
+	size_t i, num, *order;
+	int *ret, r;
+
+	t = calloc(sizeof(*t), n_fns);
+	ASSERT_RETURN(t != NULL);
+
+	ret = calloc(sizeof(*ret), n_fns);
+	ASSERT_RETURN(ret != NULL);
+
+	order = calloc(sizeof(*order), n_fns);
+	ASSERT_RETURN(order != NULL);
+
+	for (num = 0; num < runs; ++num) {
+		ASSERT_RETURN(init_fn(env, ctx) == TEST_OK);
+
+		for (i = 0; i < n_fns; ++i) {
+			ASSERT_RETURN(race_thread_init(&t[i]) == TEST_OK);
+			order[i] = i;
+		}
+
+		/* random order */
+		shuffle(order, n_fns);
+		for (i = 0; i < n_fns; ++i)
+			race_thread_run(&t[order[i]], fns[order[i]], env, ctx);
+
+		for (i = 0; i < n_fns; ++i) {
+			ASSERT_RETURN(race_thread_join(&t[i]) == TEST_OK);
+			ret[i] = t[i].ret;
+		}
+
+		ASSERT_RETURN(exit_fn(env, ctx, ret, n_fns) == TEST_OK);
+	}
+
+	r = verify_fn(env, ctx);
+	free(order);
+	free(ret);
+	free(t);
+	return r;
+}
+
+#define ASSERT_RACE(env, ctx, runs, init_fn, exit_fn, verify_fn, ...) ({\
+		int (*fns[])(struct kdbus_test_env*, void*) = {		\
+			__VA_ARGS__					\
+		};							\
+		size_t cnt = sizeof(fns) / sizeof(*fns);		\
+		race_thread(init_fn, exit_fn, verify_fn,		\
+				fns, cnt, env, ctx, runs);		\
+	})
+
+#define TEST_RACE2(_name_, _runs_, _ctx_, _a_, _b_, _init_, _exit_, _verify_)\
+	static int _name_ ## ___a(struct kdbus_test_env *env, void *_ctx)\
+	{								\
+		__attribute__((__unused__)) _ctx_ *ctx = _ctx;		\
+		_a_;							\
+		return TEST_OK;						\
+	}								\
+	static int _name_ ## ___b(struct kdbus_test_env *env, void *_ctx)\
+	{								\
+		__attribute__((__unused__)) _ctx_ *ctx = _ctx;		\
+		_b_;							\
+		return TEST_OK;						\
+	}								\
+	static int _name_ ## ___init(struct kdbus_test_env *env,	\
+				void *_ctx)				\
+	{								\
+		__attribute__((__unused__)) _ctx_ *ctx = _ctx;		\
+		_init_;							\
+		return TEST_OK;						\
+	}								\
+	static int _name_ ## ___exit(struct kdbus_test_env *env,	\
+				void *_ctx, int *ret, size_t n_ret)	\
+	{								\
+		__attribute__((__unused__)) _ctx_ *ctx = _ctx;		\
+		_exit_;							\
+		return TEST_OK;						\
+	}								\
+	static int _name_ ## ___verify(struct kdbus_test_env *env,	\
+				void *_ctx)				\
+	{								\
+		__attribute__((__unused__)) _ctx_ *ctx = _ctx;		\
+		_verify_;						\
+		return TEST_OK;						\
+	}								\
+	int _name_ (struct kdbus_test_env *env) {			\
+		_ctx_ ctx;						\
+		memset(&ctx, 0, sizeof(ctx));				\
+		return ASSERT_RACE(env, &ctx, _runs_,			\
+				_name_ ## ___init,			\
+				_name_ ## ___exit,			\
+				_name_ ## ___verify,			\
+				_name_ ## ___a,				\
+				_name_ ## ___b);			\
+	}
+
+/*
+ * Race Testing
+ * This file provides some rather trivial helpers to run multiple threads in
+ * parallel and test for races. You can define races with TEST_RACEX(), whereas
+ * 'X' is the number of threads you want. The arguments to this function should
+ * be code-blocks that are executed in the threads. Each code-block, if it
+ * does not contain a "return" statement, will implicitly return TEST_OK.
+ *
+ * The arguments are:
+ * @arg1: The name of the test to define
+ * @arg2: The number of runs
+ * @arg3: The datatype used as context across all test runs
+ * @arg4-@argN: The code-blocks for the threads to run.
+ * @argN+1: The code-block that is run before each test-run. Use it to
+ *          initialize your contexts.
+ * @argN+2: The code-block that is run after each test-run. Use it to verify
+ *          everything went as expected.
+ * @argN+3: The code-block that is executed after all runs are finished. Use it
+ *          to verify the sum of results.
+ *
+ * Each function has "env" and "ctx" as variables implicitly defined.
+ * Furthermore, the function executed after the tests were run can access "ret",
+ * which is an array of return values of all threads. "n_ret" is the number of
+ * threads.
+ *
+ * Race testing is kinda nasty if you cannot place breakpoints yourself.
+ * Therefore, we run each thread multiple times and allow you to verify the
+ * results of all test-runs after we're finished. Usually, we try to verify all
+ * possible outcomes happened. However, no-one can predict how the scheduler
+ * ran each thread, even if we run 10k times. Furthermore, the execution of all
+ * threads is randomized by us, so we cannot predict how they're run. Therefore,
+ * we only return TEST_SKIP in those cases. This is not a hard-failure, but
+ * signals test-runners that something went unexpected.
+ */
+
+/*
+ * We run BYEBYE in parallel in two threads. Only one of them is allowed to
+ * succeed, the other one *MUST* return -EALREADY.
+ */
+TEST_RACE2(kdbus_test_race_byebye, 100, int,
+	({
+		return ioctl(env->conn->fd, KDBUS_CMD_BYEBYE, 0) ? -errno : 0;
+	}),
+	({
+		return ioctl(env->conn->fd, KDBUS_CMD_BYEBYE, 0) ? -errno : 0;
+	}),
+	({
+		env->conn = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(env->conn);
+	}),
+	({
+		ASSERT_RETURN((ret[0] == 0 && ret[1] == -EALREADY) ||
+			      (ret[1] == 0 && ret[0] == -EALREADY));
+		kdbus_conn_free(env->conn);
+		env->conn = NULL;
+	}),
+	({
+	}))
+
+/*
+ * Run BYEBYE against MATCH_REMOVE. If BYEBYE is first, it returns 0 and
+ * MATCH_REMOVE must fail with ECONNRESET. If BYEBYE is last, it still succeeds
+ * but MATCH_REMOVE does, too.
+ * Run 10k times; at least on my machine it takes usually about ~100 runs to
+ * trigger ECONNRESET races.
+ */
+TEST_RACE2(kdbus_test_race_byebye_match, 10000,
+	struct {
+		bool res1 : 1;
+		bool res2 : 1;
+	},
+	({
+		return ioctl(env->conn->fd, KDBUS_CMD_BYEBYE, 0) ? -errno : 0;
+	}),
+	({
+		struct kdbus_cmd_match cmd = { };
+		int ret;
+
+		cmd.size = sizeof(cmd);
+		cmd.cookie = 0xdeadbeef;
+		ret = ioctl(env->conn->fd, KDBUS_CMD_MATCH_REMOVE, &cmd);
+		if (ret == 0 || errno == ENOENT)
+			return 0;
+
+		return -errno;
+	}),
+	({
+		env->conn = kdbus_hello(env->buspath, 0, NULL, 0);
+		ASSERT_RETURN(env->conn);
+	}),
+	({
+		if (ret[0] == 0 && ret[1] == 0) {
+			/* MATCH_REMOVE ran first, then BYEBYE */
+			ctx->res1 = true;
+		} else if (ret[0] == 0 && ret[1] == -ECONNRESET) {
+			/* BYEBYE ran first, then MATCH_REMOVE failed */
+			ctx->res2 = true;
+		} else {
+			ASSERT_RETURN(0);
+		}
+
+		kdbus_conn_free(env->conn);
+		env->conn = NULL;
+	}),
+	({
+		if (!ctx->res1 || !ctx->res2)
+			return TEST_SKIP;
+	}))
diff --git a/tools/testing/selftests/kdbus/test-sync.c b/tools/testing/selftests/kdbus/test-sync.c
new file mode 100644
index 000000000000..7aff75bc611d
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-sync.c
@@ -0,0 +1,241 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/ioctl.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <signal.h>
+#include <sys/wait.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+static struct kdbus_conn *conn_a, *conn_b;
+static unsigned int cookie = 0xdeadbeef;
+
+static void nop_handler(int sig) {}
+
+static int send_reply(const struct kdbus_conn *conn,
+		      uint64_t reply_cookie,
+		      uint64_t dst_id)
+{
+	struct kdbus_msg *msg;
+	const char ref1[1024 * 128 + 3] = "0123456789_0";
+	struct kdbus_item *item;
+	uint64_t size;
+	int ret;
+
+	size = sizeof(struct kdbus_msg);
+	size += KDBUS_ITEM_SIZE(sizeof(struct kdbus_vec));
+
+	msg = malloc(size);
+	if (!msg) {
+		ret = -errno;
+		kdbus_printf("unable to malloc()!?\n");
+		return ret;
+	}
+
+	memset(msg, 0, size);
+	msg->size = size;
+	msg->src_id = conn->id;
+	msg->dst_id = dst_id;
+	msg->cookie_reply = reply_cookie;
+	msg->payload_type = KDBUS_PAYLOAD_DBUS;
+
+	item = msg->items;
+
+	item->type = KDBUS_ITEM_PAYLOAD_VEC;
+	item->size = KDBUS_ITEM_HEADER_SIZE + sizeof(struct kdbus_vec);
+	item->vec.address = (uintptr_t)&ref1;
+	item->vec.size = sizeof(ref1);
+	item = KDBUS_ITEM_NEXT(item);
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_SEND, msg);
+	if (ret < 0) {
+		ret = -errno;
+		kdbus_printf("error sending message: %d (%m)\n", ret);
+		return ret;
+	}
+
+	free(msg);
+
+	return 0;
+}
+
+static int interrupt_sync(struct kdbus_conn *conn_src,
+			  struct kdbus_conn *conn_dst)
+{
+	pid_t pid;
+	int ret, status;
+	struct kdbus_msg *msg = NULL;
+	struct sigaction sa = {
+		.sa_handler = nop_handler,
+		.sa_flags = SA_NOCLDSTOP|SA_RESTART,
+	};
+
+	cookie++;
+	pid = fork();
+	ASSERT_RETURN_VAL(pid >= 0, pid);
+
+	if (pid == 0) {
+		ret = sigaction(SIGINT, &sa, NULL);
+		ASSERT_EXIT(ret == 0);
+
+		ret = kdbus_msg_send(conn_dst, NULL, cookie,
+				     KDBUS_MSG_FLAGS_EXPECT_REPLY |
+				     KDBUS_MSG_FLAGS_SYNC_REPLY,
+				     100000000ULL, 0, conn_src->id);
+		ASSERT_EXIT(ret == -ETIMEDOUT);
+
+		_exit(EXIT_SUCCESS);
+	}
+
+	ret = kdbus_msg_recv_poll(conn_src, 100, &msg, NULL);
+	ASSERT_RETURN(ret == 0 && msg->cookie == cookie);
+
+	kdbus_msg_free(msg);
+
+	ret = kill(pid, SIGINT);
+	ASSERT_RETURN_VAL(ret == 0, ret);
+
+	ret = waitpid(pid, &status, 0);
+	ASSERT_RETURN_VAL(ret >= 0, ret);
+
+	if (WIFSIGNALED(status))
+		return TEST_ERR;
+
+	ret = kdbus_msg_recv_poll(conn_src, 100, NULL, NULL);
+	ASSERT_RETURN(ret == -ETIMEDOUT);
+
+	return (status == EXIT_SUCCESS) ? TEST_OK : TEST_ERR;
+}
+
+static void *run_thread_reply(void *data)
+{
+	int ret;
+
+	ret = kdbus_msg_recv_poll(conn_a, 3000, NULL, NULL);
+	if (ret == 0) {
+		kdbus_printf("Thread received message, sending reply ...\n");
+		send_reply(conn_a, cookie, conn_b->id);
+	}
+
+	pthread_exit(NULL);
+	return NULL;
+}
+
+int kdbus_test_sync_reply(struct kdbus_test_env *env)
+{
+	pthread_t thread;
+	int ret;
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_reply, NULL);
+
+	ret = kdbus_msg_send(conn_b, NULL, cookie,
+			     KDBUS_MSG_FLAGS_EXPECT_REPLY |
+			     KDBUS_MSG_FLAGS_SYNC_REPLY,
+			     5000000000ULL, 0, conn_a->id);
+
+	pthread_join(thread, NULL);
+	ASSERT_RETURN(ret == 0);
+
+	ret = interrupt_sync(conn_a, conn_b);
+	ASSERT_RETURN(ret == 0);
+
+	kdbus_printf("-- closing bus connections\n");
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
+
+#define BYEBYE_ME ((void*)0L)
+#define BYEBYE_THEM ((void*)1L)
+
+static void *run_thread_byebye(void *data)
+{
+	int ret;
+
+	ret = kdbus_msg_recv_poll(conn_a, 3000, NULL, NULL);
+	if (ret == 0) {
+		kdbus_printf("Thread received message, invoking BYEBYE ...\n");
+		kdbus_msg_recv(conn_a, NULL, NULL);
+		if (data == BYEBYE_ME)
+			ioctl(conn_b->fd, KDBUS_CMD_BYEBYE, 0);
+		else if (data == BYEBYE_THEM)
+			ioctl(conn_a->fd, KDBUS_CMD_BYEBYE, 0);
+	}
+
+	pthread_exit(NULL);
+	return NULL;
+}
+
+int kdbus_test_sync_byebye(struct kdbus_test_env *env)
+{
+	pthread_t thread;
+	int ret;
+
+	/*
+	 * This sends a synchronous message to a thread, which waits until it
+	 * received the message and then invokes BYEBYE on the *ORIGINAL*
+	 * connection. That is, on the same connection that synchronously waits
+	 * for an reply.
+	 * This should properly wake the connection up and cause ECONNRESET as
+	 * the connection is disconnected now.
+	 *
+	 * The second time, we do the same but invoke BYEBYE on the *TARGET*
+	 * connection. This should also wake up the synchronous sender as the
+	 * reply cannot be sent by a disconnected target.
+	 */
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_byebye, BYEBYE_ME);
+
+	ret = kdbus_msg_send(conn_b, NULL, cookie,
+			     KDBUS_MSG_FLAGS_EXPECT_REPLY |
+			     KDBUS_MSG_FLAGS_SYNC_REPLY,
+			     5000000000ULL, 0, conn_a->id);
+
+	ASSERT_RETURN(ret == -ECONNRESET);
+
+	pthread_join(thread, NULL);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	pthread_create(&thread, NULL, run_thread_byebye, BYEBYE_THEM);
+
+	ret = kdbus_msg_send(conn_b, NULL, cookie,
+			     KDBUS_MSG_FLAGS_EXPECT_REPLY |
+			     KDBUS_MSG_FLAGS_SYNC_REPLY,
+			     5000000000ULL, 0, conn_a->id);
+
+	ASSERT_RETURN(ret == -EPIPE);
+
+	pthread_join(thread, NULL);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
diff --git a/tools/testing/selftests/kdbus/test-timeout.c b/tools/testing/selftests/kdbus/test-timeout.c
new file mode 100644
index 000000000000..f0b1a568e27c
--- /dev/null
+++ b/tools/testing/selftests/kdbus/test-timeout.c
@@ -0,0 +1,97 @@
+#include <stdio.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <errno.h>
+#include <assert.h>
+#include <poll.h>
+#include <sys/ioctl.h>
+#include <stdbool.h>
+
+#include "kdbus-test.h"
+#include "kdbus-util.h"
+#include "kdbus-enum.h"
+
+int timeout_msg_recv(struct kdbus_conn *conn, uint64_t *expected)
+{
+	struct kdbus_cmd_recv recv = {};
+	struct kdbus_msg *msg;
+	int ret;
+
+	ret = ioctl(conn->fd, KDBUS_CMD_MSG_RECV, &recv);
+	if (ret < 0) {
+		kdbus_printf("error receiving message: %d (%m)\n", ret);
+		return -errno;
+	}
+
+	msg = (struct kdbus_msg *)(conn->buf + recv.offset);
+
+	ASSERT_RETURN_VAL(msg->payload_type == KDBUS_PAYLOAD_KERNEL, -EINVAL);
+	ASSERT_RETURN_VAL(msg->src_id == KDBUS_SRC_ID_KERNEL, -EINVAL);
+	ASSERT_RETURN_VAL(msg->dst_id == conn->id, -EINVAL);
+
+	*expected &= ~(1ULL << msg->cookie_reply);
+	kdbus_printf("Got message timeout for cookie %llu\n",
+		     msg->cookie_reply);
+
+	ret = kdbus_free(conn, recv.offset);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int kdbus_test_timeout(struct kdbus_test_env *env)
+{
+	struct kdbus_conn *conn_a, *conn_b;
+	struct pollfd fd;
+	int ret, i, n_msgs = 4;
+	uint64_t expected = 0;
+
+	conn_a = kdbus_hello(env->buspath, 0, NULL, 0);
+	conn_b = kdbus_hello(env->buspath, 0, NULL, 0);
+	ASSERT_RETURN(conn_a && conn_b);
+
+	fd.fd = conn_b->fd;
+
+	/*
+	 * send messages that expect a reply (within 100 msec),
+	 * but never answer it.
+	 */
+	for (i = 0; i < n_msgs; i++) {
+		kdbus_printf("Sending message with cookie %u ...\n", i);
+		ASSERT_RETURN(kdbus_msg_send(conn_b, NULL, i,
+			      KDBUS_MSG_FLAGS_EXPECT_REPLY,
+			      (i + 1) * 100ULL * 1000000ULL, 0,
+			      conn_a->id) == 0);
+		expected |= 1ULL << i;
+	}
+
+	for (;;) {
+		fd.events = POLLIN | POLLPRI | POLLHUP;
+		fd.revents = 0;
+
+		ret = poll(&fd, 1, (n_msgs + 1) * 100);
+		if (ret == 0)
+			kdbus_printf("--- timeout\n");
+		if (ret <= 0)
+			break;
+
+		if (fd.revents & POLLIN)
+			ASSERT_RETURN(!timeout_msg_recv(conn_b, &expected));
+
+		if (expected == 0)
+			break;
+	}
+
+	ASSERT_RETURN(expected == 0);
+
+	kdbus_conn_free(conn_a);
+	kdbus_conn_free(conn_b);
+
+	return TEST_OK;
+}
-- 
2.1.3

