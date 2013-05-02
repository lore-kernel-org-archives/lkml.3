Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3EBPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3EBPQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH, RFC 20/22] media: coda: select GENERIC_ALLOCATOR
Date: Thu,  2 May 2013 17:16:24 +0200
Message-Id: <1367507786-505303-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:omrMGDMOD2uGXqKArzZhR6pC5MajaQIUDyE3GX0XiRc
 0PDsI5S2KNuc85QF+RfH9hQCSTfzs/CB1UWxPRlGow1ugAc7/M
 vp/7zPdZTw4F9G3Xk8ytKUQ0KJs9yuXh7ruIFRdIvW8FPFML5p
 7agQ0Gwu1kiPBePYqv+KFfganxy5g9tb0F88hiY+MSThcg3X30
 aM43tx58hrKAUTSCRlHweMP/v5Vw70NCDL+7cFNRExnzrPaNij
 CLWKjBmhE4gVcctDhor7gUTlijmXWI4hTqUt4P/meUqqEUEkKK
 4n10FynRNIUPkujCPA93XaeH6pJv9y+mGzV+/EVtim7JY86iQE
 q2RRHNLb9Um3LIhfUmXZDfIOr0DwG9s0PdGidB3t4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The coda driver uses the generic allocator to get at the
"iram" memory, so add the necessary dependency to avoid:

drivers/built-in.o: In function `coda_remove':
 :(.text+0x2ab680): undefined reference to `gen_pool_free'
drivers/built-in.o: In function `coda_probe':
:(.text+0x2ad168): undefined reference to `of_get_named_gen_pool'
:(.text+0x2ad188): undefined reference to `dev_get_gen_pool'
:(.text+0x2ad220): undefined reference to `gen_pool_alloc'
:(.text+0x2ad2ec): undefined reference to `gen_pool_virt_to_phys'

Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0494d27..4608d03 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -145,6 +145,7 @@ config VIDEO_CODA
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select GENERIC_ALLOCATOR
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
-- 
1.8.1.2

