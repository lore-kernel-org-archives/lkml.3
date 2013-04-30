Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222Ab3D3Qte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:49:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969Ab3D3Qtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:49:32 -0400
Date: Tue, 30 Apr 2013 09:49:05 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        penberg@kernel.org, bp@alien8.de, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, fengguang.wu@intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, bp@alien8.de, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com
In-Reply-To: <20130426095140.GA15361@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/kconfig:
  Add a Kconfig shortcut for building working KVM guest kernels
Git-Commit-ID: 83aee67833071c7b73a83f7803388f7a9e481908
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

Commit-ID:  83aee67833071c7b73a83f7803388f7a9e481908
Gitweb:     http://git.kernel.org/tip/83aee67833071c7b73a83f7803388f7a9e481908
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Fri, 26 Apr 2013 11:51:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 11:00:11 +0200

x86/kconfig: Add a Kconfig shortcut for building working KVM guest kernels

This is pretty useful for the case where people want to boot the
resulting kernel in qemu/kvm or lkvm. Instead of going and
searching for each required option through the Kconfig maze,
this single option should simply enable everything required/good
to have to boot the resulting kernel in the guest.

Patch has been adapted from a version in the external lkvm tree.

Originally-by: Pekka Enberg <penberg@kernel.org>
Originally-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/20130426095140.GA15361@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15b5cef..1d053dc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -633,6 +633,45 @@ config KVM_GUEST
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
 
 config PARAVIRT
