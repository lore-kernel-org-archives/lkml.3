Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbAUSar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:30:47 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:52134 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751941AbbAUSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:30:39 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:968:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2538:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3872:3873:3874:4321:4385:5007:6261:7875:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cars24_571620012004
X-Filterd-Recvd-Size: 2459
Date: Wed, 21 Jan 2015 13:30:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/5] tracefs: Add new tracefs file system
Message-ID: <20150121133036.6d90fc73@gandalf.local.home>
In-Reply-To: <20150121172101.503176929@goodmis.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121172101.503176929@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need to learn how to use git better :-/

I forgot to git add include/linux/tracefs.h:

-- Steve

---
 include/linux/tracefs.h    |  41 ++++
 create mode 100644 include/linux/tracefs.h

diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
new file mode 100644
index 000000000000..23e04ce21749
--- /dev/null
+++ b/include/linux/tracefs.h
@@ -0,0 +1,41 @@
+/*
+ *  tracefs.h - a pseudo file system for activating tracing
+ *
+ * Based on debugfs by: 2004 Greg Kroah-Hartman <greg@kroah.com>
+ *
+ *  Copyright (C) 2014 Red Hat Inc, author: Steven Rostedt <srostedt@redhat.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ * tracefs is the file system that is used by the tracing infrastructure.
+ *
+ */
+
+#ifndef _TRACEFS_H_
+#define _TRACEFS_H_
+
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+
+#include <linux/types.h>
+
+struct file_operations;
+
+#ifdef CONFIG_TRACING
+
+struct dentry *tracefs_create_file(const char *name, umode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops);
+
+struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
+
+void tracefs_remove(struct dentry *dentry);
+void tracefs_remove_recursive(struct dentry *dentry);
+
+bool tracefs_initialized(void);
+
+#endif /* CONFIG_TRACING */
+
+#endif
