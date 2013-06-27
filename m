Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab3F0EEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:04:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30924 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3F0EES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:04:18 -0400
X-Spam-Score: -100.8
Message-ID: <51CBB98D.3040304@asianux.com>
Date: Thu, 27 Jun 2013 12:03:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hirokazu Takata <takata@linux-m32r.org>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-m32r-ja@ml.linux-m32r.org, linux-m32r@ml.linux-m32r.org
Subject: [PATCH] include/asm-generic/pci.h: include generic "pci-dma-compat.h"
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an architecture need "generic pci.h", it also need generic "pci-dma-
compat.h",  so recommend to include it in asm-generic directly.

And now, for arm64 and m32r, may cause compiling error about it.

The related error (with allmodconfig):

  drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_exit’:
  drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function ‘pci_free_consistent’ [-Werror=implicit-function-declaration]
  drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_init’:
  drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function ‘pci_alloc_consistent’ [-Werror=implicit-function-declaration]
  drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
  cc1: some warnings being treated as errors


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/asm-generic/pci.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/pci.h b/include/asm-generic/pci.h
index e80a049..64e2a15 100644
--- a/include/asm-generic/pci.h
+++ b/include/asm-generic/pci.h
@@ -6,6 +6,8 @@
 #ifndef _ASM_GENERIC_PCI_H
 #define _ASM_GENERIC_PCI_H
 
+#include <asm-generic/pci-dma-compat.h>
+
 static inline struct resource *
 pcibios_select_root(struct pci_dev *pdev, struct resource *res)
 {
-- 
1.7.7.6
