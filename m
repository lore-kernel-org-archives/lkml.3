Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaKKIPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:31 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34481 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:27 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 02/21] backports: ifdef around module_init() module_exit() for modules
Date: Tue, 11 Nov 2014 00:14:53 -0800
Message-Id: <1415693712-23743-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We only need this for modules.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/backport-include/linux/module.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/backport/backport-include/linux/module.h b/backport/backport-include/linux/module.h
index 82c96bd..e8f28b1 100644
--- a/backport/backport-include/linux/module.h
+++ b/backport/backport-include/linux/module.h
@@ -25,6 +25,7 @@ extern void backport_dependency_symbol(void);
 		       " using backports " BACKPORTS_VERSION);
 #endif
 
+#ifdef MODULE
 #undef module_init
 #define module_init(initfn)						\
 	static int __init __init_backport(void)				\
@@ -58,6 +59,7 @@ extern void backport_dependency_symbol(void);
 		rcu_barrier();						\
 	}								\
 	void cleanup_module(void) __attribute__((alias("__exit_compat")));
+#endif
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
 #undef param_check_bool
-- 
2.1.1

