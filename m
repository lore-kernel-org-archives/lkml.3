Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbaCEXpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:45:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaCEXpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:45:40 -0500
Date: Wed, 5 Mar 2014 15:45:27 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-fb3bd7b19b2b6ef779d18573c10c00c53cd8add6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mjg59@srcf.ucam.org, aubrey.li@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, tglx@linutronix.de, aubrey.li@intel.com,
        hpa@linux.intel.com
In-Reply-To: <53130A46.1010801@linux.intel.com>
References: <53130A46.1010801@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86, reboot: Only use CF9_COND automatically,
  not CF9
Git-Commit-ID: fb3bd7b19b2b6ef779d18573c10c00c53cd8add6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb3bd7b19b2b6ef779d18573c10c00c53cd8add6
Gitweb:     http://git.kernel.org/tip/fb3bd7b19b2b6ef779d18573c10c00c53cd8add6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 5 Mar 2014 15:41:15 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 15:41:15 -0800

x86, reboot: Only use CF9_COND automatically, not CF9

Only CF9_COND is appropriate for inclusion in the default chain, not
CF9; the latter will poke that register unconditionally, whereas
CF9_COND will at least look for PCI configuration method #1 or #2
first (a weak check, but better than nothing.)

CF9 should be used for explicit system configuration (command line or
DMI) only.

Cc: Aubrey Li <aubrey.li@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Link: http://lkml.kernel.org/r/53130A46.1010801@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/reboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f601295..654b465 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -535,7 +535,7 @@ static void native_machine_emergency_restart(void)
 						 EFI_RESET_WARM :
 						 EFI_RESET_COLD,
 						 EFI_SUCCESS, 0, NULL);
-			reboot_type = BOOT_CF9;
+			reboot_type = BOOT_CF9_COND;
 			break;
 
 		case BOOT_CF9:
