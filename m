Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaJDMgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 08:36:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaJDMgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 08:36:43 -0400
Date: Sat, 4 Oct 2014 14:36:37 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] CMA: Document cma=0
Message-ID: <20141004143637.26eb9a11@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't obvious that CMA can be disabled on the kernel's command
line, so document it.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    3 ++-
 drivers/base/Kconfig                |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- linux-3.17-rc7.orig/Documentation/kernel-parameters.txt	2014-09-23 13:19:06.644838292 +0200
+++ linux-3.17-rc7/Documentation/kernel-parameters.txt	2014-10-04 14:10:03.257579721 +0200
@@ -656,7 +656,8 @@ bytes respectively. Such letter suffixes
 			Sets the size of kernel global memory area for
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
-			memory allocations. For more information, see
+			memory allocations. A value of 0 disables CMA
+			altogether. For more information, see
 			include/linux/dma-contiguous.h
 
 	cmo_free_hint=	[PPC] Format: { yes | no }
--- linux-3.17-rc7.orig/drivers/base/Kconfig	2014-09-12 16:23:14.911353676 +0200
+++ linux-3.17-rc7/drivers/base/Kconfig	2014-10-04 13:41:37.672347240 +0200
@@ -231,6 +231,9 @@ config DMA_CMA
 	  to allocate big physically-contiguous blocks of memory for use with
 	  hardware components that do not support I/O map nor scatter-gather.
 
+	  You can disable CMA by specifying "cma=0" on the kernel's command
+	  line.
+
 	  For more information see <include/linux/dma-contiguous.h>.
 	  If unsure, say "n".
 


-- 
Jean Delvare
SUSE L3 Support
