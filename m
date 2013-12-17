Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3LQSP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab3LQSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 089/103] x86, efi: Don't use (U)EFI time services on 32 bit
Date: Tue, 17 Dec 2013 18:13:18 +0000
Message-Id: <1387304012-23805-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <matthew.garrett@nebula.com>

commit 04bf9ba720fcc4fa313fa122b799ae0989b6cd50 upstream.

UEFI time services are often broken once we're in virtual mode. We were
already refusing to use them on 64-bit systems, but it turns out that
they're also broken on some 32-bit firmware, including the Dell Venue.
Disable them for now, we can revisit once we have the 1:1 mappings code
incorporated.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Link: http://lkml.kernel.org/r/1385754283-2464-1-git-send-email-matthew.garrett@nebula.com
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cfe8b9c..46e5387 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -760,13 +760,6 @@ void __init efi_init(void)
 
 	set_bit(EFI_MEMMAP, &x86_efi_facility);
 
-#ifdef CONFIG_X86_32
-	if (efi_is_native()) {
-		x86_platform.get_wallclock = efi_get_time;
-		x86_platform.set_wallclock = efi_set_rtc_mmss;
-	}
-#endif
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
-- 
1.8.3.2

