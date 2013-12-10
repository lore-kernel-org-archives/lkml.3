Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3LJXWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3LJXWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:22:18 -0500
Date: Tue, 10 Dec 2013 15:22:01 -0800
From: tip-bot for Matthew Garrett <tipbot@zytor.com>
Message-ID: <tip-04bf9ba720fcc4fa313fa122b799ae0989b6cd50@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matthew.garrett@nebula.com, stable@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, stable@vger.kernel.org,
        matt.fleming@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Don't use (U)
 EFI time services on 32 bit
Git-Commit-ID: 04bf9ba720fcc4fa313fa122b799ae0989b6cd50
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 15:22:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04bf9ba720fcc4fa313fa122b799ae0989b6cd50
Gitweb:     http://git.kernel.org/tip/04bf9ba720fcc4fa313fa122b799ae0989b6cd50
Author:     Matthew Garrett <matthew.garrett@nebula.com>
AuthorDate: Fri, 29 Nov 2013 14:44:43 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 10 Dec 2013 15:02:34 -0800

x86, efi: Don't use (U)EFI time services on 32 bit

UEFI time services are often broken once we're in virtual mode. We were
already refusing to use them on 64-bit systems, but it turns out that
they're also broken on some 32-bit firmware, including the Dell Venue.
Disable them for now, we can revisit once we have the 1:1 mappings code
incorporated.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Link: http://lkml.kernel.org/r/1385754283-2464-1-git-send-email-matthew.garrett@nebula.com
Cc: <stable@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92c0234..cceb813 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -690,13 +690,6 @@ void __init efi_init(void)
 
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
