Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3DLSUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:20:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39294 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3DLSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:20:04 -0400
Date: Fri, 12 Apr 2013 20:19:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
Message-ID: <20130412181956.GA13099@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right,

so I'm currently experimenting with my randconfig build scripts and
thought that maybe it would be a cool thing to not only do the random
builds only but also boot-test them in kvm. Which reminded me that we
have that KVMTOOL_TEST_ENABLE config option in the kvmtool with which we
can select all the stuff needed to boot the kernel in kvm.

So I copied it. I now have an all.config in the repo with
CONFIG_KVM_TEST_ENABLE=y in it so that the random builds can have the
required support.

So what do people think?

It is pretty helpful for such testing; AFAICT Fengguang is doing his
testing with kvm so he probably could use it too. And regardless, there
are more and more reasons to boot the kernel in kvm so having a single
option which selects the needed support makes more sense with time.

And I haven't picked up the 'make kvmconfig' functionality because it
is not strictly needed (yet) but it wouldn't hurt if we took it because
someone has a good reason for needing it.

Thanks.

--
>From efa9a7f7a460bc46d1dd37b691afa88070a34059 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Fri, 12 Apr 2013 20:01:47 +0200
Subject: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel

This is pretty useful for the case where people want to boot the
resulting kernel in qemu/kvm. Instead of going and searching for each
required option through the Kconfig maze, this single option should
simply enable all stuff which is required to boot the resulting kernel
in the guest.

Originally-by: Pekka Enberg <penberg@kernel.org>
Originally-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 arch/x86/Kconfig | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 70c0f3da0476..3ca241172812 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -596,6 +596,43 @@ config SCHED_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
+config KVM_TEST_ENABLE
+	bool "Enable options for a kernel suitable for testing in kvm"
+	select NET
+	select NETDEVICES
+	select PCI
+	select BLOCK
+	select BLK_DEV
+	select NETWORK_FILESYSTEMS
+	select INET
+	select EXPERIMENTAL
+	select TTY
+	select SERIAL_8250
+	select SERIAL_8250_CONSOLE
+	select IP_PNP
+	select IP_PNP_DHCP
+	select BINFMT_ELF
+	select PCI_MSI
+	select HAVE_ARCH_KGDB
+	select DEBUG_KERNEL
+	select KGDB
+	select KGDB_SERIAL_CONSOLE
+	select VIRTUALIZATION
+	select VIRTIO
+	select VIRTIO_RING
+	select VIRTIO_PCI
+	select VIRTIO_BLK
+	select VIRTIO_CONSOLE
+	select VIRTIO_NET
+	select 9P_FS
+	select NET_9P
+	select NET_9P_VIRTIO
+	---help---
+	  Select stuff which is required for booting the kernel as a guest
+	  in qemu/kvm. This entails basic stuff like serial support, kgdb
+	  9p virtio and other basic functionality so that you can be able
+	  to have serial output from the guest, networking, etc.
+
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
 	---help---
-- 
1.8.2.135.g7b592fa

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
