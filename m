Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJOVZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:25:23 -0400
Received: from mga03.intel.com ([134.134.136.65]:17603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaJOVZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:25:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,727,1406617200"; 
   d="scan'208";a="589748685"
From: David Cohen <david.a.cohen@linux.intel.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] staging: comedi: ii_pci20kc: add CONFIG_HAS_IOMEM dependence
Date: Wed, 15 Oct 2014 14:25:39 -0700
Message-Id: <1413408339-12816-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ii_pci20kc uses io memory which makes it not compilable on architectures
without HAS_IOMEM such as UML:

  CC      drivers/net/wireless/ti/wl1251/main.o
drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_attach’:
drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit
declaration of function ‘ioremap’
[-Werror=implicit-function-declaration]
  dev->mmio = ioremap(membase, II20K_SIZE);
  ^
drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment
makes pointer from integer without a cast
  dev->mmio = ioremap(membase, II20K_SIZE);
            ^
drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_detach’:
drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit
declaration of function ‘iounmap’
[-Werror=implicit-function-declaration]
   iounmap(dev->mmio);
   ^

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/staging/comedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a8bc2b567789..56be2112c731 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -425,6 +425,7 @@ config COMEDI_AIO_IIRO_16
 	  called aio_iiro_16.
 
 config COMEDI_II_PCI20KC
+	depends on HAS_IOMEM
 	tristate "Intelligent Instruments PCI-20001C carrier support"
 	---help---
 	  Enable support for Intelligent Instruments PCI-20001C carrier
-- 
2.1.0

