Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab3DZAGC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:06:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56387 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab3DZAGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:06:00 -0400
Date: Fri, 26 Apr 2013 02:05:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH -v2] x86: Add a Kconfig shortcut for kvm guest kernel
Message-ID: <20130426000553.GE32607@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
 <20130418133631.GA30965@amt.cnet>
 <20130419103519.GB21981@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130419103519.GB21981@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>
Date: Tue, 16 Apr 2013 18:24:34 +0200
Subject: [PATCH -v2] x86: Add a Kconfig shortcut for kvm guest kernel

This is pretty useful for the case where people want to boot the
resulting kernel in qemu/kvm. Instead of going and searching for each
required option through the Kconfig maze, this single option should
simply enable everything required/good to have to boot the resulting
kernel in the guest.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Originally-by: Pekka Enberg <penberg@kernel.org>
Originally-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---


Here's v2 which should be addressing all review comments so far.


 arch/x86/Kconfig | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5651374d179f..76a95ffa959a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -680,6 +680,44 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_GUEST_COMMODITY_OPTIONS
+	bool "Enable commodity options for a standalone KVM guest"
+	depends on KVM_GUEST
+	select NET
+	select NETDEVICES
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
+	  Select guest kernel functionality which facilitates booting the
+	  kernel as a guest in qemu/kvm. This entails basic stuff like
+	  serial support, kgdb, virtio and other so that you can be able to
+	  have commodity functionality like serial output from the guest,
+	  networking, etc.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT_TIME_ACCOUNTING
-- 
1.8.2.135.g7b592fa

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
