Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761919Ab3EBUFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:05:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35664 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923Ab3EBUFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:05:09 -0400
Date: Thu, 2 May 2013 22:07:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130502200703.GE16684@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org>
 <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
 <5182AB66.6020307@linux.intel.com>
 <20130502194556.GB3553@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130502194556.GB3553@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:45:56PM +0200, Ingo Molnar wrote:
> Boris, mind posting a working version?

Yeah, let's delay it for the next merge window - it looks like it needs
more experimenting and since it is not urgent enough...

FWIW, I did play a bit with it today and I ended up with the diff below
just to satisfy the CONFIG_PCI/MSI deps. However, if I want to shut them
all up, I need to pull in SMP, MODULE_UNLOAD, MODULE... and so on.

Which is kind of an overkill and I really don't want to do it.

I wonder if one can exclude options from randconfig until 'select' has
been taught to resolve dependencies...

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9dae342fa6f6..4c826ea8dd29 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -390,9 +390,10 @@ config X86_VSMP
        bool "ScaleMP vSMP"
        select HYPERVISOR_GUEST
        select PARAVIRT
-       depends on X86_64 && PCI
+       select PCI
+       select SMP
+       depends on X86_64
        depends on X86_EXTENDED_PLATFORM
-       depends on SMP
        ---help---
          Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
          supposed to run on these EM64T-based machines.  Only choose this option
@@ -685,6 +686,7 @@ config KVM_GUEST_COMMON_OPTIONS
        bool "Enable commodity options for a standalone KVM guest"
        depends on KVM_GUEST
        select NET
+       select NET_CORE
        select NETDEVICES
        select BLOCK
        select BLK_DEV
@@ -697,6 +699,12 @@ config KVM_GUEST_COMMON_OPTIONS
        select IP_PNP
        select IP_PNP_DHCP
        select BINFMT_ELF
+#      select SMP
+#      select MODULE_UNLOAD
+       select X86_LOCAL_APIC
+       select X86_IO_APIC
+       select ARCH_SUPPORTS_MSI
+       select PCI
        select PCI_MSI
        select HAVE_ARCH_KGDB
        select DEBUG_KERNEL



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
