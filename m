Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaCYU7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:59:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28525 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCYU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:58:55 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, eshelton@pobox.com,
        fenghua.yu@intel.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com, Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 3/5] x86: Call efi_memblock_x86_reserve_range() on native EFI platform only
Date: Tue, 25 Mar 2014 21:57:54 +0100
Message-Id: <1395781076-12000-4-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call efi_memblock_x86_reserve_range() on native EFI platform only.
This is not needed and even it should not be called on platforms
which wraps EFI infrastructure like Xen.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ce72964..992b67a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -933,7 +933,7 @@ void __init setup_arch(char **cmdline_p)
 		set_bit(EFI_64BIT, &x86_efi_facility);
 	}
 
-	if (efi_enabled(EFI_BOOT))
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature, "EL", 2))
 		efi_memblock_x86_reserve_range();
 #endif
 
-- 
1.7.10.4

