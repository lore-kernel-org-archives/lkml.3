Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3JKTlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab3JKTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [ 059/135] ARM: mach-integrator: Add stub for pci_v3_early_init() for !CONFIG_PCI
Date: Fri, 11 Oct 2013 12:39:00 -0700
Message-Id: <20131011193951.694592128@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit 4dc3231f818baf7415c67ee06c51ace0973ae736 upstream.

This fixes a compile error where CONFIG_PCI is disabled:

  LD      init/built-in.o
arch/arm/mach-integrator/built-in.o: In function `ap_map_io':
integrator_cp.c:(.init.text+0x570): undefined reference to `pci_v3_early_init'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-integrator/pci_v3.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/arm/mach-integrator/pci_v3.h
+++ b/arch/arm/mach-integrator/pci_v3.h
@@ -1,2 +1,9 @@
 /* Simple oneliner include to the PCIv3 early init */
+#ifdef CONFIG_PCI
 extern int pci_v3_early_init(void);
+#else
+static inline int pci_v3_early_init(void)
+{
+	return 0;
+}
+#endif


