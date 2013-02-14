Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934811Ab3BNSMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:12:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54941 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab3BNSMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:12:18 -0500
Date: Thu, 14 Feb 2013 10:10:54 -0800
Message-Id: <201302141810.r1EIAs4u003684@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] One more x86 fix for 3.8
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sigh.  One more patch in the "please don't brick my Samsung" series.

The following changes since commit 323a72d83c9b2963bd1e46c8e6963e468d4658d7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-02-13 12:21:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 1de63d60cd5b0d33a812efa455d5933bf1564a51.

  efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter (2013-02-13 17:24:11 -0800)

----------------------------------------------------------------
Satoru Takeuchi (1):
      efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 77cf009..928bf83 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(efi_enabled);
 
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_BOOT, &x86_efi_facility);
+	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
