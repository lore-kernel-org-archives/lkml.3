Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895Ab3ECXai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 19:30:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50549 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762044Ab3ECXah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 19:30:37 -0400
Date: Sat, 4 May 2013 01:36:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, levinsasha928@gmail.com, mtosatti@redhat.com,
        tglx@linutronix.de, bp@suse.de, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130503233610.GE3433@pd.tnic>
References: <20130502200703.GE16684@pd.tnic>
 <20130503142900.GA3433@pd.tnic>
 <5183CFAC.8020005@infradead.org>
 <20130503150818.GC3433@pd.tnic>
 <5183D357.8000204@suse.cz>
 <20130503153134.GD3433@pd.tnic>
 <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
 <aea679e3-048a-4f28-b164-73191095a995@email.android.com>
 <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com>
 <51840B70.2000205@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51840B70.2000205@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:09:36PM -0700, H. Peter Anvin wrote:
> Actually it is called:
> 
> KCONFIG_ALLCONFIG=kvm_guest.config make allnoconfig

I guess we can do something like this - it is kinda noisy currently and
requires a previously present .config in $objtree to work.

---
 arch/x86/Makefile                 |  5 +++++
 arch/x86/configs/kvm_guest.config | 28 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 arch/x86/configs/kvm_guest.config

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5c477260294f..6f9c03ed999e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,6 +220,11 @@ archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
+kvmconfig:
+	$(if $(wildcard $(objtree)/.config),, $(error You need an existing .config for this target))
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m -O $(objtree) $(objtree)/.config arch/x86/configs/kvm_guest.config
+	$(Q)yes "n" | $(MAKE) oldconfig
+
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
   echo  '  install      - Install kernel using'
diff --git a/arch/x86/configs/kvm_guest.config b/arch/x86/configs/kvm_guest.config
new file mode 100644
index 000000000000..2ac38a390db3
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
+CONFIG_HAVE_ARCH_KGDB=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_KGDB=y
+CONFIG_KGDB_SERIAL_CONSOLE=y
+CONFIG_VIRTUALIZATION=y
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
