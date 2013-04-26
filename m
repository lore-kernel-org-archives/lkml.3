Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3DZJvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:51:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55860 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab3DZJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:51:47 -0400
Date: Fri, 26 Apr 2013 11:51:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH -v2.1] x86: Add a Kconfig shortcut for kvm guest kernel
Message-ID: <20130426095140.GA15361@pd.tnic>
References: <20130412181956.GA13099@pd.tnic>
 <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
 <20130418133631.GA30965@amt.cnet>
 <20130419103519.GB21981@pd.tnic>
 <20130426000553.GE32607@pd.tnic>
 <20130426064250.GA31064@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130426064250.GA31064@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 08:42:50AM +0200, Ingo Molnar wrote:
>
> ... < take all review comments >

Here it is:

--
>From 56880e448600ca1504df8c68c59f31153f7b5b0f Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Tue, 16 Apr 2013 18:24:34 +0200
Subject: [PATCH -v2.1] x86: Add a Kconfig shortcut for kvm guest kernel

This is pretty useful for the case where people want to boot the
resulting kernel in qemu/kvm or lkvm. Instead of going and searching for
each required option through the Kconfig maze, this single option should
simply enable everything required/good to have to boot the resulting
kernel in the guest.

Patch has been adapted from a version in the external lkvm tree.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Originally-by: Pekka Enberg <penberg@kernel.org>
Originally-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5651374d179f..432478a7b814 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -680,6 +680,45 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_GUEST_COMMON_OPTIONS
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
+	  kernel as a guest in qemu or lkvm. This entails basic stuff like
+	  serial support, kgdb, virtio and other so that you can be able to
+	  have commodity functionality like serial output from the guest,
+	  networking, seamless host file system integration into guest context
+	  and other useful things.
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
