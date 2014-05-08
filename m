Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaEHPC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:02:58 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55715 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaEHO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Subject: [PATCH 1/2] dmaengine: omap: hide filter_fn for built-in drivers
Date: Thu,  8 May 2014 16:56:12 +0200
Message-Id: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:CIqsGp9MKxEPFQhUWT77wfQPa+Xjhyt9Vjx3N+YZcXk
 v6PPINCGzeEMvD5aDpmKvIGWNEqK9TcVm9lmjG+uOogA7hkiTZ
 EpXn1EefT0+yHOB/FY62xK9sG3mUmcwEDA8tXukUDzv9DiglmD
 6ziMFxd+lfkVma2JLjIfgDbDBPNcH4iZ8kVCuo+ghaNKQeXhL7
 f6NWDmBgZb4JMp4W5VcQ5ssN4WpQrM8TE9/51H9g/ITw9JB+U9
 VzqMujGq4Wr/3SJesNErcO5xqskUXAssxVq9SGAy2MO26H9ZLV
 2ewJ1bZzks8c/syt+TymDmlN+txdwyOsRYc1SYKxeh25/xgUar
 p66qPr9weabC0pXBe4DmFSAryDZDdQHAdC8HketPu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not possible to reference the omap_dma_filter_fn filter
function from a built-in driver if the dmaengine driver itself
is a loadable module, which is a valid configuration otherwise.

This provides only the dummy alternative if the function
is referenced by a built-in driver to allow a successful
build. The filter function is only required by ATAGS based
platforms, which will continue to be broken after this change
for the bogus configuration. When booting from DT, with the
dma channels correctly listed there, it will work fine.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org
---
 include/linux/omap-dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/omap-dma.h b/include/linux/omap-dma.h
index 0a1a2e2..c29a6de 100644
--- a/include/linux/omap-dma.h
+++ b/include/linux/omap-dma.h
@@ -10,7 +10,7 @@
 
 struct dma_chan;
 
-#if defined(CONFIG_DMA_OMAP) || defined(CONFIG_DMA_OMAP_MODULE)
+#if defined(CONFIG_DMA_OMAP) || (defined(CONFIG_DMA_OMAP_MODULE) && defined(MODULE))
 bool omap_dma_filter_fn(struct dma_chan *, void *);
 #else
 static inline bool omap_dma_filter_fn(struct dma_chan *c, void *d)
-- 
1.8.3.2

