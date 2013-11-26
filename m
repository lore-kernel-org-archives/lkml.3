Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3KZGCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:02:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab3KZGAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:00:44 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v4 11/12] x86: reserve setup_data ranges late after parsing memmap cmdline
Date: Tue, 26 Nov 2013 13:57:56 +0800
Message-Id: <1385445477-9665-12-git-send-email-dyoung@redhat.com>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kdump kernel using memmap=exactmap, move e820_reserve_setup_data after
parsing early params so they can be set reserved finally. Or kdump kernel
will warn about ioremap a normal ram range.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/kernel/setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ecf225e..4a18f2f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -927,8 +927,6 @@ void __init setup_arch(char **cmdline_p)
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
-	/* update the e820_saved too */
-	e820_reserve_setup_data();
 
 	copy_edd();
 
@@ -990,6 +988,8 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	/* update the e820_saved too */
+	e820_reserve_setup_data();
 	finish_e820_parsing();
 
 	if (efi_enabled(EFI_BOOT))
-- 
1.8.3.1

