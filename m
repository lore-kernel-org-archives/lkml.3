Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3DWB25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:28:57 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49773 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3DWB24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:28:56 -0400
From: vinayakm.list@gmail.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, rientjes@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vinayak Menon <vinayakm.list@gmail.com>
Subject: [PATCH v2] mm: add an option to disable bounce
Date: Tue, 23 Apr 2013 06:58:26 +0530
Message-Id: <1366680506-2812-1-git-send-email-vinayakm.list@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinayak Menon <vinayakm.list@gmail.com>

There are times when HIGHMEM is enabled, but
we don't prefer CONFIG_BOUNCE to be enabled.
CONFIG_BOUNCE can reduce the block device
throughput, and this is not ideal for machines
where we don't gain much by enabling it. So
provide an option to deselect CONFIG_BOUNCE. The
observation was made while measuring eMMC throughput
using iozone on an ARM device with 1GB RAM.

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
---
 mm/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 3bea74f..e742d06 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -263,8 +263,14 @@ config ZONE_DMA_FLAG
 	default "1"
 
 config BOUNCE
-	def_bool y
+	bool "Enable bounce buffers"
+	default y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
+	help
+	  Enable bounce buffers for devices that cannot access
+	  the full range of memory available to the CPU. Enabled
+	  by default when ZONE_DMA or HIGHMEM is selected, but you
+	  may say n to override this.
 
 # On the 'tile' arch, USB OHCI needs the bounce pool since tilegx will often
 # have more than 4GB of memory, but we don't currently use the IOTLB to present
-- 
1.7.10.4

