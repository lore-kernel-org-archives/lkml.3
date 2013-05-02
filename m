Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3EBPQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab3EBPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH, RFC 18/22] Xen: SWIOTLB is only used on x86
Date: Thu,  2 May 2013 17:16:22 +0200
Message-Id: <1367507786-505303-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5NgCMOIYRrlGYigNuA8q//lkYFw1a4EC6fBxg8g7f8N
 uxdKsVXem+oAIRBvpTITQu7cVCdRCeUYabQRKWvPHxeuR9GzlH
 dcULnZFwFn3xUizrFaSUVHW8mkKGorusYRiCyqK1AVh/5auY1a
 7/f4tIa/OzV07Nes1W513TC40gklpQCxd3G3QNAXURI/lyF+0a
 FbxcsXK0zmvdXqMKaGzKDSO/AJS7IRuwptrWa9yVZTN3yY+erW
 PU2eD35G8YO9ShItEk+7xy+rnBLITQuVYaujdqFYBdOiiBwEYS
 o++P2rSy0fkL8XTjpukyb3gar2xuRa2Py4f56bYRcwcQLDYWKt
 TRk9EwPnc5wPV6xbDLbdzUfVlZ/41kjdSUlevpBfO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling SWIOTLB_XEN on ARM results in build errors because the
underlying SWIOTLB is only available on X86:

drivers/xen/swiotlb-xen.c: In function 'is_xen_swiotlb_buffer':
drivers/xen/swiotlb-xen.c:105:2: error: implicit declaration of function 'mfn_to_local_pfn

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/xen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index dd4d9cb..f03bf50 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -141,7 +141,7 @@ config XEN_GRANT_DEV_ALLOC
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on PCI
+	depends on PCI && X86
 	select SWIOTLB
 
 config XEN_TMEM
-- 
1.8.1.2

