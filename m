Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaLRRuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:50:50 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49222 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaLRRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:50:48 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, matthew.garrett@nebula.com, jk@ozlabs.org,
        matt.fleming@intel.com, pjones@redhat.com
Subject: [RFC] fs: make efivarfs a pseudo filesystem, built by default with EFI
Date: Thu, 18 Dec 2014 17:50:49 +0000
Message-Id: <1418925049-3659-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efivars is currently enabled under MISC_FILESYSTEMS, which is decribed
as "such as filesystems that came from other operating systems".
In reality, it is a pseudo filesystem, providing access to the kernel
UEFI variable interface.

Since this is the preferred interface for accessing UEFI variables, over
the legacy efivars interface, also build it by default as a module if
CONFIG_EFI.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 fs/Kconfig          | 2 +-
 fs/efivarfs/Kconfig | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 664991a..a6bb530 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -165,6 +165,7 @@ config HUGETLB_PAGE
 	def_bool HUGETLBFS
 
 source "fs/configfs/Kconfig"
+source "fs/efivarfs/Kconfig"
 
 endmenu
 
@@ -209,7 +210,6 @@ source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
-source "fs/efivarfs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/efivarfs/Kconfig b/fs/efivarfs/Kconfig
index 367bbb1..c2499ef 100644
--- a/fs/efivarfs/Kconfig
+++ b/fs/efivarfs/Kconfig
@@ -1,6 +1,7 @@
 config EFIVAR_FS
 	tristate "EFI Variable filesystem"
 	depends on EFI
+	default m
 	help
 	  efivarfs is a replacement filesystem for the old EFI
 	  variable support via sysfs, as it doesn't suffer from the
-- 
2.1.3

