Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356AbaH0PWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:22:40 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33857 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935318AbaH0PWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:37 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v9 06/23] module: Do not inline do_init_module
Date: Wed, 27 Aug 2014 17:21:21 +0200
Message-Id: <707b4ba0981a98be82747bf59a13a81f02f1329c.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a reliable breakpoint target, required for automatic
symbol loading via the gdb helper command 'lx-symbols'.

CC: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 kernel/module.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 03214bd2..ac4f7e8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3005,8 +3005,13 @@ static void do_mod_ctors(struct module *mod)
 #endif
 }
 
-/* This is where the real work happens */
-static int do_init_module(struct module *mod)
+/*
+ * This is where the real work happens.
+ *
+ * Keep it uninlined to provide a reliable breakpoint target, e.g. for the gdb
+ * helper command 'lx-symbols'.
+ */
+static noinline int do_init_module(struct module *mod)
 {
 	int ret = 0;
 
-- 
1.8.1.1.298.ge7eed54

