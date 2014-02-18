Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaBRNHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:07:47 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:49773 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbaBRNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:07:44 -0500
Message-ID: <1392728861.5144.10.camel@x220>
Subject: [PATCH v2] xen: remove XEN_PRIVILEGED_GUEST
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2014 14:07:41 +0100
In-Reply-To: <1392718467.30073.12.camel@x220>
References: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
	 <1392642197.13000.20.camel@x220>
	 <20140217144307.GB28658@localhost.localdomain>
	 <1392718467.30073.12.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2014 13:07:42.0356 (UTC) FILETIME=[6855F540:01CF2CAA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the Kconfig symbol XEN_PRIVILEGED_GUEST which is
used nowhere in the tree.

We do know grub2 has a script that greps kernel configuration files for
its macro. It shouldn't do that. As Linus summarized:
    This is a grub bug. It really is that simple. Treat it as one.

Besides, grub2's grepping for that macro is actually superfluous. See,
that script currently contains this test (simplified):
    grep -x CONFIG_XEN_DOM0=y $config || grep -x CONFIG_XEN_PRIVILEGED_GUEST=y $config

But since XEN_DOM0 and XEN_PRIVILEGED_GUEST are by definition equal,
removing XEN_PRIVILEGED_GUEST cannot influence this test.

So there's no reason to not remove this symbol, like we do with all
unused Kconfig symbols.

[pebolle@tiscali.nl: rewrote commit explanation.]
Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: added a few lines to the commit explanation to show grub2's test for
this symbol is superfluous anyway. Still only git "grep tested".

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

