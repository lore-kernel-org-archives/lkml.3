Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaF3Ry7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:54:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17253 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbaF3Ryl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:54:41 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, fenghua.yu@intel.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: [PATCH v7 09/10] arch/x86: Replace plain strings with constants
Date: Mon, 30 Jun 2014 19:53:03 +0200
Message-Id: <1404150784-27921-10-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've got constants, so let's use them instead of hard-coded values.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
v6 - suggestions/fixes:
   - improve commit message
     (suggested by Matt Fleming).
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 78a0e62..41ead8d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -924,10 +924,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4)) {
+		     EFI32_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4)) {
+		     EFI64_LOADER_SIGNATURE, 4)) {
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
-- 
1.7.10.4

