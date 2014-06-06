Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaFFXLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:11:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44111 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaFFXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:11:28 -0400
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
Subject: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig helper
Date: Fri,  6 Jun 2014 16:11:09 -0700
Message-Id: <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This lets you use:

   make virtconfig

to merge you current kernel configuration with options to
enable both kvm and xen (dom0 and guest) requirements.

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
 arch/x86/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9db34e2..f2df13e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -262,6 +262,11 @@ xenconfig:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config $(srctree)/arch/x86/configs/xen.config
 	$(Q)yes "" | $(MAKE) -f $(srctree)/Makefile oldconfig
 
+PHONY += virtconfig
+virtconfig:
+	$(Q)$(MAKE) kvmconfig
+	$(Q)$(MAKE) xenconfig
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -277,4 +282,5 @@ define archhelp
   echo  '                  FDINITRD=file initrd for the booted kernel'
   echo  '  kvmconfig	- Enable additional options for kvm guest kernel support'
   echo  '  xenconfig    - Enable additional options for xen dom0 and guest kernel support'
+  echo  '  virtconfig   - Enable additional options for kvm and xen kernel support'
 endef
-- 
2.0.0.rc3.18.g00a5b79

