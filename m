Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaFBWOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57257 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFBWOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:14:33 -0400
Date: Mon, 2 Jun 2014 15:14:03 -0700
Message-Id: <201406022214.s52ME3ht019703@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mingo@kernel.org, stefani@seibold.net,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A single quite small patch that managed to get overlooked earlier, to
prevent a user space triggerable oops on systems without HPET.

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 368b69a5b010cb00fc9ea04d588cff69af1a1359:

  x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET (2014-05-21 16:14:04 -0700)

----------------------------------------------------------------
Andy Lutomirski (1):
      x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET

 arch/x86/vdso/vdso32-setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e1f220e..310c5f0 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -155,6 +155,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	struct vm_area_struct *vma;
+	static struct page *no_pages[] = {NULL};
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -193,7 +194,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
 			VDSO_OFFSET(VDSO_PREV_PAGES),
 			VM_READ,
-			NULL);
+			no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
