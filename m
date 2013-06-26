Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3FZFc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:32:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33215 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3FZFcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:32:43 -0400
X-Spam-Score: -100.8
Message-ID: <51CA5F71.207@asianux.com>
Date: Wed, 26 Jun 2013 11:26:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: arm64: include: asm: add pci.h to pass compiling
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add pci.h for compiling, the related error (with allmodconfig):

  drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_exit’:
  drivers/media/usb/b2c2/flexcop-usb.c:393:3: error: implicit declaration of function ‘pci_free_consistent’ [-Werror=implicit-function-declaration]
  drivers/media/usb/b2c2/flexcop-usb.c: In function ‘flexcop_usb_transfer_init’:
  drivers/media/usb/b2c2/flexcop-usb.c:410:2: error: implicit declaration of function ‘pci_alloc_consistent’ [-Werror=implicit-function-declaration]
  drivers/media/usb/b2c2/flexcop-usb.c:410:21: warning: assignment makes pointer from integer without a cast [enabled by default]
  cc1: some warnings being treated as errors

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/pci.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h

diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..2ed467f
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,11 @@
+#ifndef ASMARM64_PCI_H
+#define ASMARM64_PCI_H
+
+#ifdef __KERNEL__
+
+#include <asm-generic/pci-dma-compat.h>
+#include <asm-generic/pci.h>
+
+#endif /* __KERNEL__ */
+
+#endif
-- 
1.7.7.6
