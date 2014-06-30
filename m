Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaF3Ry0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:54:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17024 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbaF3RyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:54:22 -0400
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
Subject: [PATCH v7 05/10] arch/x86: Remove redundant set_bit(EFI_SYSTEM_TABLES) call
Date: Mon, 30 Jun 2014 19:52:59 +0200
Message-Id: <1404150784-27921-6-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant set_bit(EFI_SYSTEM_TABLES, &efi.flags) call.
It is executed earlier in efi_systab_init().

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/platform/efi/efi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b9c23d7..ae3d398 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -744,8 +744,6 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
 	efi.config_table = (unsigned long)efi.systab->tables;
 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
 	efi.runtime	 = (unsigned long)efi.systab->runtime;
-- 
1.7.10.4

