Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3DWVxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:53:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3DWVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: [ 42/42] Revert "MIPS: page.h: Provide more readable definition for PAGE_MASK."
Date: Tue, 23 Apr 2013 14:52:40 -0700
Message-Id: <20130423215209.749528209@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 3b5e50edaf500f392f4a372296afc0b99ffa7e70 upstream.

This reverts commit c17a6554782ad531f4713b33fd6339ba67ef6391.

Manuel Lauss writes:

lmo commit c17a6554 (MIPS: page.h: Provide more readable definition for
PAGE_MASK) apparently breaks ioremap of 36-bit addresses on my Alchemy
systems (PCI and PCMCIA) The reason is that in arch/mips/mm/ioremap.c
line 157  (phys_addr &= PAGE_MASK) bits 32-35 are cut off.  Seems the
new PAGE_MASK is explicitly 32bit, or one could make it signed instead
of unsigned long.

From: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -31,7 +31,7 @@
 #define PAGE_SHIFT	16
 #endif
 #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
-#define PAGE_MASK       (~(PAGE_SIZE - 1))
+#define PAGE_MASK	(~((1 << PAGE_SHIFT) - 1))
 
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 #define HPAGE_SHIFT	(PAGE_SHIFT + PAGE_SHIFT - 3)


