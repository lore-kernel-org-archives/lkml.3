Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaBMTyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:54:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47170 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbaBMTyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:54:08 -0500
Date: Thu, 13 Feb 2014 11:52:30 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ARM: mm: report both sections from PMD
Message-ID: <20140213195230.GA15275@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2-level page table systems, the PMD has 2 section entries. Report
these, otherwise ARM_PTDUMP will miss reporting permission changes on
odd section boundaries.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
 - re-reorganize, drop use of pmd_sect; suggested by Catalin Marinas.
v2:
 - reorganize, suggested by Catalin Marinas.
---
 arch/arm/mm/dump.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 2b342177f5de..61cc78ae9f21 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -264,6 +264,9 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 			note_page(st, addr, 3, pmd_val(*pmd));
 		else
 			walk_pte(st, pmd, addr);
+
+		if (SECTION_SIZE < PMD_SIZE && pmd_large(pmd[1]))
+			note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));
 	}
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
