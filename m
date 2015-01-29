Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbbA2Gxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:53:52 -0500
Received: from goliath.siemens.de ([192.35.17.28]:52165 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbA2Gxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:53:50 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v11 06/28] module: Do not inline do_init_module
Date: Thu, 29 Jan 2015 07:46:25 +0100
Message-Id: <07d780075603bb8a52a829016f88e95711b02785.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
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
index d856e96..2df6cec 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3011,8 +3011,13 @@ static void do_free_init(struct rcu_head *head)
 	kfree(m);
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
 	struct mod_initfree *freeinit;
-- 
2.1.4

