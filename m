Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3LRVM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:12:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3LRVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.10 47/78] x86, efi: Dont use (U)EFI time services on 32 bit
Date: Wed, 18 Dec 2013 13:11:15 -0800
Message-Id: <20131218211113.229070425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -766,13 +766,6 @@ void __init efi_init(void)
 
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


