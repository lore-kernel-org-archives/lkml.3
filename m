Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3KEAGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:06:44 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11155 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3KEAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:06:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Nov 2013 16:05:45 -0800
From: Eric Miao <eric.miao@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: Eric Miao <eric.miao@nvidia.com>, David Howells <dhowells@redhat.com>,
        "Dan Willemsen" <dwillemsen@nvidia.com>
Subject: [PATCH 1/2] module: export sig_enforce readonly even if MODULE_SIG_FORCE is on
Date: Mon, 4 Nov 2013 16:06:34 -0800
Message-ID: <1383609995-8251-1-git-send-email-eric.miao@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if MODULE_SIG_FORCE is turned on, it is still useful if module
can export sig_enforce, so user space will know if module signature
is turned on and forced.

Signed-off-by: Eric Miao <eric.miao@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dan Willemsen <dwillemsen@nvidia.com>
---
 kernel/module.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index dc58274..d55646b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -110,6 +110,14 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 #ifdef CONFIG_MODULE_SIG
 #ifdef CONFIG_MODULE_SIG_FORCE
 static bool sig_enforce = true;
+
+static const struct kernel_param_ops param_ops_bool_read_only = {
+	.flags = KERNEL_PARAM_FL_NOARG,
+	.get = param_get_bool,
+};
+#define param_check_bool_read_only param_check_bool
+
+module_param(sig_enforce, bool_read_only, 0444);
 #else
 static bool sig_enforce = false;
 
-- 
1.8.4.1

