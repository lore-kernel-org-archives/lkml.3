Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaJBOfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:35:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41644 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaJBOff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:35:35 -0400
Message-ID: <542D640E.6010200@gmail.com>
Date: Thu, 02 Oct 2014 22:41:18 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, luca.ellero@brickedbrain.com,
        lisovy@gmail.com
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC depend
 on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

COMEDI_II_PCI20KC needs HAS_IOMEM, so depend on it. The related error (
with allmodconfig under um):

    CC [M]  drivers/staging/comedi/drivers/ii_pci20kc.o
  drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_attach’:
  drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit declaration of function ‘ioremap’ [-Werror=implicit-function-declaration]
    dev->mmio = ioremap(membase, II20K_SIZE);
    ^
  drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment makes pointer from integer without a cast [enabled by default]
    dev->mmio = ioremap(membase, II20K_SIZE);
              ^
  drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_detach’:
  drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
     iounmap(dev->mmio);
     ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/comedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index a8bc2b5..b709736 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -426,6 +426,7 @@ config COMEDI_AIO_IIRO_16
 
 config COMEDI_II_PCI20KC
 	tristate "Intelligent Instruments PCI-20001C carrier support"
+	depends on HAS_IOMEM
 	---help---
 	  Enable support for Intelligent Instruments PCI-20001C carrier
 	  PCI-20001, PCI-20006 and PCI-20341
-- 
1.9.3
