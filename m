Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3BEWLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3BEWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 58/93] x86, efi: Set runtime_version to the EFI spec revision
Date: Tue,  5 Feb 2013 20:06:47 -0200
Message-Id: <1360102042-10732-59-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 712ba9e9afc4b3d3d6fa81565ca36fe518915c01 upstream.

efi.runtime_version is erroneously being set to the value of the
vendor's firmware revision instead of that of the implemented EFI
specification. We can't deduce which EFI functions are available based
on the revision of the vendor's firmware since the version scheme is
likely to be unique to each vendor.

What we really need to know is the revision of the implemented EFI
specification, which is available in the EFI System Table header.

Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 72d8899..6825327 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -900,7 +900,7 @@ void __init efi_enter_virtual_mode(void)
 	 *
 	 * Call EFI services through wrapper functions.
 	 */
-	efi.runtime_version = efi_systab.fw_revision;
+	efi.runtime_version = efi_systab.hdr.revision;
 	efi.get_time = virt_efi_get_time;
 	efi.set_time = virt_efi_set_time;
 	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-- 
1.7.9.5

