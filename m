Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3L2CKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab3L2CKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:18 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Fleming" <matt.fleming@intel.com>,
        "Matthew Garrett" <matthew.garrett@nebula.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.904743543@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 134/185] x86, efi: Don't use (U)EFI time services on
 32 bit
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: deleted code is slightly different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c | 7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -614,11 +614,6 @@ void __init efi_init(void)
 
 	set_bit(EFI_MEMMAP, &x86_efi_facility);
 
-#ifdef CONFIG_X86_32
-	x86_platform.get_wallclock = efi_get_time;
-	x86_platform.set_wallclock = efi_set_rtc_mmss;
-#endif
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif

