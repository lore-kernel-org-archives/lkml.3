Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3J1JTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:19:47 -0400
Received: from thoth.sbs.de ([192.35.17.2]:23107 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab3J1JTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:19:46 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v6 06/21] module: Do not inline do_init_module
Date: Mon, 28 Oct 2013 09:58:43 +0100
Message-Id: <2169d6a3b72d76d902f68b21e798b53fdd550792.1382950737.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1382950737.git.jan.kiszka@siemens.com>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1382950737.git.jan.kiszka@siemens.com>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a reliable breakpoint target, required for automatic
symbol loading via the gdb helper command 'lx-symbols'.

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

