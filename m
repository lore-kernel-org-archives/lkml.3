Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaKTREo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:04:44 -0500
Received: from thoth.sbs.de ([192.35.17.2]:43829 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459AbaKTRCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:54 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v10 06/27] module: Do not inline do_init_module
Date: Thu, 20 Nov 2014 18:01:43 +0100
Message-Id: <41d11fd6e84a9ed821f6c7ae8ce792f8b47fe7e3.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
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
index 88cec1d..da477eb 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3007,8 +3007,13 @@ static void do_mod_ctors(struct module *mod)
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
1.8.4.5

