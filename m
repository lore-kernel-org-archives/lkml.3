Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3A2Qwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:52:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3A2Qwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:52:34 -0500
Message-ID: <5107FE48.7080402@canonical.com>
Date: Tue, 29 Jan 2013 17:52:24 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH] x86, efi: remove attribute check from setup_efi_pci
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the original commit that copied the rom contents from efi always copied
the rom, and the fixup in setup_efi_pci from commit 886d751a2ea99a160
("x86, efi: correct precedence of operators in setup_efi_pci") broke that.

This resulted in macbook pro's no longer finding the rom images, and thus not being able to use the radeon card any more.

The solution is to just remove the check for now, and always copy the rom if available.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 18e329c..ce06324 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -302,9 +302,6 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
-			continue;
-
 		if (!pci->romimage || !pci->romsize)
 			continue;
 

