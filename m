Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaDBPyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:54:04 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:52172 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbaDBPyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:54:01 -0400
Date: Wed, 2 Apr 2014 11:53:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Loc Ho <lho@apm.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH libata/for-3.15-fixes] libata: drop COMPILE_TEST from
 AHCI_XGENE
Message-ID: <20140402155357.GA16631@htj.dyndns.org>
References: <20140401184916.GA21938@kroah.com>
 <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
 <20140402022858.GA4901@kroah.com>
 <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
 <533C0B45.4050909@ti.com>
 <CAPw-ZTn3_oEMFFNua1zoDibOBJOLC92k7zdc8Do+hk3Ai-BSaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPw-ZTn3_oEMFFNua1zoDibOBJOLC92k7zdc8Do+hk3Ai-BSaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied the following patch to libata/for-3.15-fixes.

Thanks.
------- 8< -------
>From 9c23f2cf7f6e107e85eef57fdf3049a93b6e157c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 2 Apr 2014 11:47:04 -0400

AHCI_XGENE is only applicable on ARM64 but it can also be enabled for
compile testing; however, AHCI_XGENE selects PHY_XGENE which has other
arch specific dependencies.  This leads to the following warning when
enabling it on other archs for compile testing.

  warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
  dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))

Let's drop COMPILE_TEST from AHCI_XGENE.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Loc Ho <lho@apm.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 20e03a7..0a4fa5e 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -134,7 +134,7 @@ config AHCI_SUNXI
 
 config AHCI_XGENE
 	tristate "APM X-Gene 6.0Gbps AHCI SATA host controller support"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARM64
 	select PHY_XGENE
 	help
 	 This option enables support for APM X-Gene SoC SATA host controller.
-- 
1.9.0

