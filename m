Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbANTeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:34:03 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40694 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbANTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:33:58 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org,
        stefano.stabellini@eu.citrix.com
Cc: bpoirier@suse.de, x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        julien.grall@linaro.org, rientjes@google.com, mcgrof@suse.com
Subject: [PATCH v3 0/2] x86/arm64: add xenconfig
Date: Wed, 14 Jan 2015 11:33:45 -0800
Message-Id: <1421264027-10706-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v3 addresses Stefano's feedback from the v2 series, namely
moving PCI stuff to x86 as its all x86 specific and also just
removing the CONFIG_TCG_XEN=m from the general config. To be
clear the changes from the v2 series are below.

Luis R. Rodriguez (2):
  x86, platform, xen, kconfig: clarify kvmconfig is for kvm
  x86, arm, platform, xen, kconfig: add xen defconfig helper

 arch/x86/configs/xen.config | 10 ++++++++++
 kernel/configs/xen.config   | 26 ++++++++++++++++++++++++++
 scripts/kconfig/Makefile    |  7 ++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/configs/xen.config
 create mode 100644 kernel/configs/xen.config

-- 
2.1.1

diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
index 92b8587f..fa7d214 100644
--- a/arch/x86/configs/xen.config
+++ b/arch/x86/configs/xen.config
@@ -5,3 +5,6 @@ CONFIG_XEN_SAVE_RESTORE=y
 # CONFIG_XEN_DEBUG_FS is not set
 CONFIG_XEN_PVH=y
 CONFIG_XEN_MCE_LOG=y
+CONFIG_PCI_XEN=y
+CONFIG_XEN_PCIDEV_FRONTEND=m
+CONFIG_XEN_ACPI_PROCESSOR=m
diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
index d2ec010..476fcf0 100644
--- a/kernel/configs/xen.config
+++ b/kernel/configs/xen.config
@@ -1,8 +1,6 @@
 # generic config
 CONFIG_XEN=y
 CONFIG_XEN_DOM0=y
-CONFIG_PCI_XEN=y
-CONFIG_XEN_PCIDEV_FRONTEND=m
 CONFIG_XEN_BLKDEV_FRONTEND=m
 CONFIG_XEN_BLKDEV_BACKEND=m
 CONFIG_XEN_NETDEV_FRONTEND=m
@@ -10,7 +8,6 @@ CONFIG_XEN_NETDEV_BACKEND=m
 CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
 CONFIG_HVC_XEN=y
 CONFIG_HVC_XEN_FRONTEND=y
-CONFIG_TCG_XEN=m
 CONFIG_XEN_WDT=m
 CONFIG_XEN_FBDEV_FRONTEND=y
 CONFIG_XEN_BALLOON=y
@@ -27,4 +24,3 @@ CONFIG_XEN_GRANT_DEV_ALLOC=m
 CONFIG_SWIOTLB_XEN=y
 CONFIG_XEN_PCIDEV_BACKEND=m
 CONFIG_XEN_PRIVCMD=m
-CONFIG_XEN_ACPI_PROCESSOR=m
