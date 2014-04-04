Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaDDSqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:46:00 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39383 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaDDSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:45:55 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 01/10] lib: add fdt_empty_tree.c
Date: Fri,  4 Apr 2014 19:45:04 +0100
Message-Id: <1396637113-22790-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
References: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

CONFIG_LIBFDT support does not include fdt_empty_tree.c which is
needed by arm64 EFI stub. Add it to libfdt_files.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/Makefile         |    3 ++-
 lib/fdt_empty_tree.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 lib/fdt_empty_tree.c

diff --git a/lib/Makefile b/lib/Makefile
index 02da5b6..5f5b6a2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -149,7 +149,8 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 
-libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o
+libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
+	       fdt_empty_tree.o
 $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
diff --git a/lib/fdt_empty_tree.c b/lib/fdt_empty_tree.c
new file mode 100644
index 0000000..5d30c58
--- /dev/null
+++ b/lib/fdt_empty_tree.c
@@ -0,0 +1,2 @@
+#include <linux/libfdt_env.h>
+#include "../scripts/dtc/libfdt/fdt_empty_tree.c"
-- 
1.7.10.4

