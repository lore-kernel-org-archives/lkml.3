Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3GHG2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:28:39 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57620 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3GHG2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:28:38 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] xen: remove unused Kconfig parameter
Date: Mon,  8 Jul 2013 08:28:24 +0200
Message-Id: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the XEN_PRIVILEGED_GUEST kernel
configuration parameter defined in arch/x86/xen/Kconfig, but used
nowhere in the makefiles and source code.

This dummy parameter was added 3 years back, and it may
make sense to remove it now, as the reasons to use it were not
very clear.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/x86/xen/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 1a3c765..b6401dc 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -19,11 +19,6 @@ config XEN_DOM0
 	depends on XEN && PCI_XEN && SWIOTLB_XEN
 	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
 
-# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
-# name in tools.
-config XEN_PRIVILEGED_GUEST
-	def_bool XEN_DOM0
-
 config XEN_PVHVM
 	def_bool y
 	depends on XEN && PCI && X86_LOCAL_APIC
-- 
1.8.1.2

