Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaDYQfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:35:45 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42924 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaDYQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:09:59 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com,
        grant.likely@linaro.org, roy.franz@linaro.org,
        ard.biesheuvel@linaro.org, mark.rutland@arm.com,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 01/10] lib: add fdt_empty_tree.c
Date: Fri, 25 Apr 2014 17:09:05 +0100
Message-Id: <1398442154-19974-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

CONFIG_LIBFDT support does not include fdt_empty_tree.c which is
needed by arm64 EFI stub. Add it to libfdt_files.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 lib/Makefile         |    3 ++-
 lib/fdt_empty_tree.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 lib/fdt_empty_tree.c

diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68..74a32dc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -148,7 +148,8 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
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

