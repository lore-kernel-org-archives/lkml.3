Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3EVOqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:46:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41795 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab3EVOqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:46:44 -0400
Date: Wed, 22 May 2013 16:46:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: [PATCH -v2] x86: Add a kvm config file
Message-ID: <20130522144638.GB15085@pd.tnic>
References: <20130503142900.GA3433@pd.tnic>
 <5183CFAC.8020005@infradead.org>
 <20130503150818.GC3433@pd.tnic>
 <5183D357.8000204@suse.cz>
 <20130503153134.GD3433@pd.tnic>
 <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
 <aea679e3-048a-4f28-b164-73191095a995@email.android.com>
 <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com>
 <51840B70.2000205@linux.intel.com>
 <20130503233610.GE3433@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130503233610.GE3433@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an config file snippet which enables additional options useful for
running the kernel in a kvm guest. When you execute 'make kvmconfig' it
merges those options with an already existing user config before you
build the kernel.

Based on an patch from the external lkvm tree.

Signed-off-by: Borislav Petkov <bp@suse.de>
---

So I've been running this for a while now and seems like the cleanest
solution to me ATM.

 arch/x86/Makefile                 |  6 ++++++
 arch/x86/configs/kvm_guest.config | 28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 arch/x86/configs/kvm_guest.config

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c477260294f..91ee171f1cff 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,6 +220,11 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+kvmconfig:
+	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
+	$(Q)yes "" | $(MAKE) oldconfig
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
@@ -233,4 +238,5 @@ define archhelp
   echo  '                  bzdisk/fdimage*/isoimage also accept:'
   echo  '                  FDARGS="..."  arguments for the booted kernel'
   echo  '                  FDINITRD=file initrd for the booted kernel'
+  echo  '  kvmconfig	- Enable additional options for guest kernel support'
 endef
diff --git a/arch/x86/configs/kvm_guest.config b/arch/x86/configs/kvm_guest.config
new file mode 100644
index 000000000000..f9affcc3b9f1
--- /dev/null
+++ b/arch/x86/configs/kvm_guest.config
@@ -0,0 +1,28 @@
+CONFIG_NET=y
+CONFIG_NET_CORE=y
+CONFIG_NETDEVICES=y
+CONFIG_BLOCK=y
+CONFIG_BLK_DEV=y
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_INET=y
+CONFIG_TTY=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_BINFMT_ELF=y
+CONFIG_PCI=y
+CONFIG_PCI_MSI=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_VIRTUALIZATION=y
+CONFIG_HYPERVISOR_GUEST=y
+CONFIG_PARAVIRT=y
+CONFIG_KVM_GUEST=y
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_BLK=y
+CONFIG_VIRTIO_CONSOLE=y
+CONFIG_VIRTIO_NET=y
+CONFIG_9P_FS=y
+CONFIG_NET_9P=y
+CONFIG_NET_9P_VIRTIO=y
-- 
1.8.3.rc0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
