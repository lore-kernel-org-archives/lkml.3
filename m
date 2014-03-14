Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaCNCwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:52:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaCNCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:52:18 -0400
Date: Thu, 13 Mar 2014 19:51:44 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-1f2cbcf648962cdcf511d234cb39745baa9f5d07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        luto@amacapital.net, david.vrabel@citrix.com, tglx@linutronix.de,
        hpa@linux.intel.com, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        luto@amacapital.net, david.vrabel@citrix.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
In-Reply-To: <4bb4690899106eb11430b1186d5cc66ca9d1660c.1394751608.git.luto@amacapital.net>
References: <4bb4690899106eb11430b1186d5cc66ca9d1660c.1394751608.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso, xen: Remove stray reference to FIX_VDSO
Git-Commit-ID: 1f2cbcf648962cdcf511d234cb39745baa9f5d07
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

Commit-ID:  1f2cbcf648962cdcf511d234cb39745baa9f5d07
Gitweb:     http://git.kernel.org/tip/1f2cbcf648962cdcf511d234cb39745baa9f5d07
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 13 Mar 2014 19:44:47 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 19:44:47 -0700

x86, vdso, xen: Remove stray reference to FIX_VDSO

Checkin

    b0b49f2673f0 x86, vdso: Remove compat vdso support

... removed the VDSO from the fixmap, and thus FIX_VDSO; remove a
stray reference in Xen.

Found by Fengguang Wu's test robot.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Link: http://lkml.kernel.org/r/4bb4690899106eb11430b1186d5cc66ca9d1660c.1394751608.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 256282e..21c6a42 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2058,7 +2058,6 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 	case FIX_RO_IDT:
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
-	case FIX_VDSO:
 # ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
