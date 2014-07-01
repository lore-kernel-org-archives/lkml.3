Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaGAVrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:47:53 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:42403 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbaGAVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:37 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/50] mars: add new file include/linux/brick/brick_say.h
Date: Tue,  1 Jul 2014 23:46:43 +0200
Message-Id: <1404251250-22992-4-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/brick_say.h | 80 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 include/linux/brick/brick_say.h

diff --git a/include/linux/brick/brick_say.h b/include/linux/brick/brick_say.h
new file mode 100644
index 0000000..9f240c8
--- /dev/null
+++ b/include/linux/brick/brick_say.h
@@ -0,0 +1,80 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef BRICK_SAY_H
+#define BRICK_SAY_H
+
+/***********************************************************************/
+
+extern int brick_say_logging;
+extern int brick_say_debug;
+extern int brick_say_syslog_min;
+extern int brick_say_syslog_max;
+extern int brick_say_syslog_flood_class;
+extern int brick_say_syslog_flood_limit;
+extern int brick_say_syslog_flood_recovery;
+extern int delay_say_on_overflow;
+
+/*  printk() replacements */
+
+enum {
+	SAY_DEBUG,
+	SAY_INFO,
+	SAY_WARN,
+	SAY_ERROR,
+	SAY_FATAL,
+	SAY_TOTAL,
+	MAX_SAY_CLASS
+};
+
+extern const char *say_class[MAX_SAY_CLASS];
+
+struct say_channel;
+
+extern struct say_channel *default_channel;
+
+extern struct say_channel *make_channel(const char *name, bool must_exit);
+
+extern void del_channel(struct say_channel *ch);
+
+extern void bind_to_channel(struct say_channel *ch, struct task_struct *whom);
+
+#define bind_me(_name)							\
+	bind_to_channel(make_channel(_name), current)
+
+extern struct say_channel *get_binding(struct task_struct *whom);
+
+extern void remove_binding_from(struct say_channel *ch, struct task_struct *whom);
+extern void remove_binding(struct task_struct *whom);
+
+extern void rollover_channel(struct say_channel *ch);
+extern void rollover_all(void);
+
+extern void say_to(struct say_channel *ch, int class, const char *fmt, ...) __printf(3, 4);
+
+#define say(_class, _fmt, _args...)					\
+	say_to(NULL, _class, _fmt, ##_args)
+
+extern void brick_say_to(struct say_channel *ch,
+	int class,
+	bool dump,
+	const char *prefix,
+	const char *file,
+	int line,
+	const char *func,
+	const char *fmt,
+
+	...) __printf(8,
+	9);
+
+#define brick_say(_class, _dump, _prefix, _file, _line, _func, _fmt, _args...)\
+	brick_say_to(NULL, _class, _dump, _prefix, _file, _line, _func, _fmt, ##_args)
+
+extern void init_say(void);
+extern void exit_say(void);
+
+#ifdef CONFIG_MARS_DEBUG
+extern void brick_dump_stack(void);
+#else /*  CONFIG_MARS_DEBUG */
+#define brick_dump_stack() /*empty*/
+#endif /*  CONFIG_MARS_DEBUG */
+
+#endif
-- 
2.0.0

