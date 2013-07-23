Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab3GWQrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:47:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14252 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933115Ab3GWQrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:47:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,729,1367971200"; 
   d="scan'208";a="38764151"
Date: Tue, 23 Jul 2013 17:46:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <xen-devel@lists.xensource.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] do not allow XEN_TMEM on ARM64
Message-ID: <alpine.DEB.2.02.1307231745520.4893@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmem is not supported on arm or arm64 yet.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 9e02d60..a18f350 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -145,7 +146,7 @@ config SWIOTLB_XEN
 
 config XEN_TMEM
 	tristate
-	depends on !ARM
+	depends on !ARM && !ARM64
 	default m if (CLEANCACHE || FRONTSWAP)
 	help
 	  Shim to interface in-kernel Transcendent Memory hooks
