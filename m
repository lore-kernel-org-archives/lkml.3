Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3KYIuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:50:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3KYIua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:50:30 -0500
Message-Id: <20131125084811.395808573@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:47:10 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject-Prefi: [patch @num@/@total@ v4]
Subject: reserve setup_data ranges late after parsing memmap cmdline
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=11-reserve-setup-data-late.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kdump kernel using memmap=exactmap, move e820_reserve_setup_data after
parsing early params so they can be set reserved finally. Or kdump kernel
will warn about ioremap a normal ram range.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- efi.orig/arch/x86/kernel/setup.c
+++ efi/arch/x86/kernel/setup.c
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

