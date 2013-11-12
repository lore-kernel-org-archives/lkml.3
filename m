Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3KLHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:16:57 -0500
Received: from goliath.siemens.de ([192.35.17.28]:21307 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3KLHPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:20 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v7 06/21] module: Do not inline do_init_module
Date: Tue, 12 Nov 2013 08:14:24 +0100
Message-Id: <cf629f0b8fb6a7075f9dc6e9279f24d3bb1f8eb3.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
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
index dc58274..a40d48a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3035,8 +3035,13 @@ static void do_mod_ctors(struct module *mod)
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

