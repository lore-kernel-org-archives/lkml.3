Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaBPUHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:07:44 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55187 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbaBPUHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:07:43 -0500
Message-ID: <1392581262.28866.66.camel@x220>
Subject: [PATCH] xen: remove XEN_PRIVILEGED_GUEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 21:07:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 20:07:42.0913 (UTC) FILETIME=[C0364B10:01CF2B52]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Kconfig symbol XEN_PRIVILEGED_GUEST which is
used nowhere in the tree. We do know grub2 has a script that greps
kernel configuration files for this symbol. It shouldn't do that. As
Linus summarized:
    This is a grub bug. It really is that simple. Treat it as one.

So there's no reason to not remove it, like we do with all unused
Kconfig symbols.

[pebolle@tiscali.nl: rewrote commit explanation.]
Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

Michael's version can be found at https://lkml.org/lkml/2013/7/8/34 .
(This is the same patch, with a rewritten explanation, and my S-o-b
line.) The question whether this symbol can be removed was further
discussed in https://lkml.org/lkml/2013/7/15/308 .

I don't think a bug was ever filed against grub2 regarding its way to
check for Xen support. Should that be done first?

 arch/x86/xen/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 01b9026..512219d 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -19,11 +19,6 @@ config XEN_DOM0
 	depends on XEN && PCI_XEN && SWIOTLB_XEN
 	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
 
-# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
-# name in tools.
-config XEN_PRIVILEGED_GUEST
-	def_bool XEN_DOM0
-
 config XEN_PVHVM
 	def_bool y
 	depends on XEN && PCI && X86_LOCAL_APIC
-- 
1.8.5.3

