Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbaGWTDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:03:38 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:63372 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaGWTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:03:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0RAMMF0FNXQypd/2dsb2JhbABZgw6BKa82BQEBAQEBAQUBbgGdQYE3gQsXdoRgI4EaN4hGAcAPF4V7iGxkHYQwBY5FjGiLbIhUggOBRzsvgQM
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/1 linux-next] staging: ion: vm_insert_pfn and zap_page_range rely on CONFIG_MMU
Date: Wed, 23 Jul 2014 21:04:38 +0200
Message-Id: <1406142278-21067-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following sh-allmodconfig errors reported on kisskb
"
drivers/built-in.o: In function `ion_vm_fault':
ion.c:(.text+0x1f2d8f8): undefined reference to `vm_insert_pfn'
drivers/built-in.o: In function `ion_buffer_sync_for_device':
ion.c:(.text+0x1f316bc): undefined reference to `zap_page_range'
make: *** [vmlinux] Error 1
"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 drivers/staging/android/ion/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index 0a6e4d03..3452346 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -1,6 +1,6 @@
 menuconfig ION
 	bool "Ion Memory Manager"
-	depends on HAVE_MEMBLOCK && HAS_DMA
+	depends on HAVE_MEMBLOCK && HAS_DMA && MMU
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
 	---help---
-- 
1.8.4.5

