Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3E1Nkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:40:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3E1Nky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:40:54 -0400
Date: Tue, 28 May 2013 06:39:58 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-46ff53874bd935ab9955dee56d60212857e89bf3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penberg@kernel.org, rdunlap@infradead.org, mmarek@suse.cz,
        bp@alien8.de, tglx@linutronix.de, bp@suse.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, rdunlap@infradead.org, mmarek@suse.cz,
        bp@alien8.de, tglx@linutronix.de, rientjes@google.com, bp@suse.de
In-Reply-To: <20130522144638.GB15085@pd.tnic>
References: <20130522144638.GB15085@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, platform, kvm, kconfig:
  Turn existing .config's into KVM-capable configs
Git-Commit-ID: 46ff53874bd935ab9955dee56d60212857e89bf3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ff53874bd935ab9955dee56d60212857e89bf3
Gitweb:     http://git.kernel.org/tip/46ff53874bd935ab9955dee56d60212857e89bf3
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Wed, 22 May 2013 16:46:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 12:11:32 +0200

x86, platform, kvm, kconfig: Turn existing .config's into KVM-capable configs

Add an config file snippet which enables additional options
useful for running the kernel in a kvm guest. When you execute
'make kvmconfig' it merges those options with an already
existing user config before you build the kernel.

Based on an patch from the external lkvm tree.

Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: penberg@kernel.org
Cc: levinsasha928@gmail.com
Cc: mtosatti@redhat.com
Cc: fengguang.wu@intel.com
Link: http://lkml.kernel.org/r/20130522144638.GB15085@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Makefile                 |  6 ++++++
 arch/x86/configs/kvm_guest.config | 28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c47726..91ee171 100644
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
index 0000000..f9affcc
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
