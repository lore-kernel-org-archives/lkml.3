Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3JHKcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:32:36 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50028 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3JHKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:32:35 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minchan Kim <minchan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] zsmalloc: Fix "map_vm_area" undefined reference errors.
Date: Tue,  8 Oct 2013 16:02:15 +0530
Message-Id: <1381228335-18213-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a MMU dependency to configure the ZSMALLOC in
drivers/staging/zsmalloc/Kconfig. Without this patch, build
system can lead to build failure. This was observed during
randconfig testing, in which ZSMALLOC was enabled w/o MMU being
enabled. Following was the error:

LD      vmlinux
drivers/built-in.o: In function `__zs_map_object':
drivers/staging/zsmalloc/zsmalloc-main.c:650: undefined reference to `map_vm_area'
make: *** [vmlinux] Error 1

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/zsmalloc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
index 7fab032..0ae13cd 100644
--- a/drivers/staging/zsmalloc/Kconfig
+++ b/drivers/staging/zsmalloc/Kconfig
@@ -1,5 +1,6 @@
 config ZSMALLOC
 	bool "Memory allocator for compressed pages"
+	depends on MMU
 	default n
 	help
 	  zsmalloc is a slab-based memory allocator designed to store
-- 
1.7.9.5

