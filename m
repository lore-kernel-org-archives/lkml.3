Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaLIXgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:36:16 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55736 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaLIXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:35:54 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org
Cc: bpoirier@suse.de, x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 2/2] x86, arm, platform, xen, kconfig: add xen defconfig helper
Date: Tue,  9 Dec 2014 15:35:38 -0800
Message-Id: <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This lets you build a kernel which can support xen dom0
or xen guests by just using:

   make xenconfig

on both x86 and arm64 kernels. This also splits out the
options which are available currently to be built with x86
and 'make ARCH=arm64' under a shared config.

Technically xen supports a dom0 kernel and also a guest
kernel configuration but upon review with the xen team
since we don't have many dom0 options its best to just
combine these two into one.

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: penberg@kernel.org
Cc: levinsasha928@gmail.com
Cc: mtosatti@redhat.com
Cc: fengguang.wu@intel.com
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/configs/xen.config |  7 +++++++
 kernel/configs/xen.config   | 30 ++++++++++++++++++++++++++++++
 scripts/kconfig/Makefile    |  5 +++++
 3 files changed, 42 insertions(+)
 create mode 100644 arch/x86/configs/xen.config
 create mode 100644 kernel/configs/xen.config

diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
new file mode 100644
index 0000000..92b8587f
--- /dev/null
+++ b/arch/x86/configs/xen.config
@@ -0,0 +1,7 @@
+# x86 xen specific config options
+CONFIG_XEN_PVHVM=y
+CONFIG_XEN_MAX_DOMAIN_MEMORY=500
+CONFIG_XEN_SAVE_RESTORE=y
+# CONFIG_XEN_DEBUG_FS is not set
+CONFIG_XEN_PVH=y
+CONFIG_XEN_MCE_LOG=y
diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
new file mode 100644
index 0000000..d2ec010
--- /dev/null
+++ b/kernel/configs/xen.config
@@ -0,0 +1,30 @@
+# generic config
+CONFIG_XEN=y
+CONFIG_XEN_DOM0=y
+CONFIG_PCI_XEN=y
+CONFIG_XEN_PCIDEV_FRONTEND=m
+CONFIG_XEN_BLKDEV_FRONTEND=m
+CONFIG_XEN_BLKDEV_BACKEND=m
+CONFIG_XEN_NETDEV_FRONTEND=m
+CONFIG_XEN_NETDEV_BACKEND=m
+CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
+CONFIG_HVC_XEN=y
+CONFIG_HVC_XEN_FRONTEND=y
+CONFIG_TCG_XEN=m
+CONFIG_XEN_WDT=m
+CONFIG_XEN_FBDEV_FRONTEND=y
+CONFIG_XEN_BALLOON=y
+CONFIG_XEN_BALLOON_MEMORY_HOTPLUG=y
+CONFIG_XEN_SCRUB_PAGES=y
+CONFIG_XEN_DEV_EVTCHN=m
+CONFIG_XEN_BACKEND=y
+CONFIG_XENFS=m
+CONFIG_XEN_COMPAT_XENFS=y
+CONFIG_XEN_SYS_HYPERVISOR=y
+CONFIG_XEN_XENBUS_FRONTEND=y
+CONFIG_XEN_GNTDEV=m
+CONFIG_XEN_GRANT_DEV_ALLOC=m
+CONFIG_SWIOTLB_XEN=y
+CONFIG_XEN_PCIDEV_BACKEND=m
+CONFIG_XEN_PRIVCMD=m
+CONFIG_XEN_ACPI_PROCESSOR=m
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index ff612b0..f4a8f89 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -117,6 +117,10 @@ PHONY += kvmconfig
 kvmconfig:
 	$(call mergeconfig,kvm_guest)
 
+PHONY += xenconfig
+xenconfig:
+	$(call mergeconfig,xen)
+
 PHONY += tinyconfig
 tinyconfig: allnoconfig
 	$(call mergeconfig,tiny)
@@ -142,6 +146,7 @@ help:
 	@echo  '  listnewconfig   - List new options'
 	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
 	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
+	@echo  '  xenconfig       - Enable additional options for xen dom0 and guest kernel support'
 	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
 
 # lxdialog stuff
-- 
2.1.1

