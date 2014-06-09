Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaFIShR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:37:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60529 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaFISgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:36:44 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: [PATCH v2 3/3] x86, platform, xen, kconfig: add xen defconfig helper
Date: Mon,  9 Jun 2014 11:36:24 -0700
Message-Id: <1402338984-9774-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com>
References: <1402338984-9774-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This lets you build a kernel which can support xen dom0
or xen guests by just using:

   make xenconfig

Technically xen supports a dom0 kernel and also a guest
kernel configuration but upon review with the xen team
since we don't have many dom0 options its best to just
combine these two into one.

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
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 arch/x86/Makefile           |  5 +++++
 arch/x86/configs/xen.config | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)
 create mode 100644 arch/x86/configs/xen.config

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 36eea65..cbd9e06 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -260,6 +260,10 @@ PHONY += kvmconfig
 kvmconfig:
 	$(call build-virtconfig,kvm_guest.config)
 
+PHONY += xenconfig
+xenconfig:
+	$(call build-virtconfig,xen.config)
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -274,4 +278,5 @@ define archhelp
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
   echo  '  kvmconfig	- Enable additional options for kvm guest kernel support'
+  echo  '  xenconfig    - Enable additional options for xen dom0 and guest kernel support'
 endef
diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
new file mode 100644
index 0000000..fbfbe5c
--- /dev/null
+++ b/arch/x86/configs/xen.config
@@ -0,0 +1,36 @@
+CONFIG_XEN=y
+CONFIG_XEN_DOM0=y
+CONFIG_XEN_PVHVM=y
+CONFIG_XEN_MAX_DOMAIN_MEMORY=500
+CONFIG_XEN_SAVE_RESTORE=y
+# CONFIG_XEN_DEBUG_FS is not set
+CONFIG_XEN_PVH=y
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
+CONFIG_XEN_MCE_LOG=y
+CONFIG_XEN_HAVE_PVMMU=y
-- 
2.0.0.rc3.18.g00a5b79

