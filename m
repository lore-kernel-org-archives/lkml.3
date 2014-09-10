Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaIJRC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:02:28 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:7715 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaIJRC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:02:26 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com
Subject: [PATCH v2 0/6] Support Write-Through mapping on x86
Date: Wed, 10 Sep 2014 10:51:44 -0600
Message-Id: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support of Write-Through (WT) mapping on x86.
The study below shows that using WT mapping may be useful for
non-volatile memory.

  http://www.hpl.hp.com/techreports/2012/HPL-2012-236.pdf

This patchset applies on top of the Juergen's patchset below,
which provides the basis of the PAT management.

  https://lkml.org/lkml/2014/9/8/55

All new/modified interfaces have been tested.

v2:
 - Changed WT to use slot 7 of the PAT MSR. (H. Peter Anvin,
   Andy Lutomirski)
 - Changed to have conservative checks to exclude all Pentium 2, 3,
   M, and 4 families. (Ingo Molnar, Henrique de Moraes Holschuh,
   Andy Lutomirski)
 - Updated documentation to cover WT interfaces and usages.
   (Andy Lutomirski, Yigal Korman)

---
Toshi Kani (6):
  1/6 x86, mm, pat: Set WT to PA4 slot of PAT MSR
  2/6 x86, mm, pat: Change reserve_memtype() to handle WT
  3/6 x86, mm, asm-gen: Add ioremap_wt() for WT
  4/6 x86, mm: Add set_memory_wt() for WT
  5/6 x86, mm, pat: Add pgprot_writethrough() for WT
  6/6 x86, pat: Update documentation for WT changes

---
 Documentation/x86/pat.txt            | 14 +++++--
 arch/x86/include/asm/cacheflush.h    | 10 ++++-
 arch/x86/include/asm/io.h            |  2 +
 arch/x86/include/asm/pgtable_types.h |  3 ++
 arch/x86/mm/ioremap.c                | 24 ++++++++++++
 arch/x86/mm/pageattr.c               | 73 +++++++++++++++++++++++++++++++++---
 arch/x86/mm/pat.c                    | 69 +++++++++++++++++++++++++---------
 include/asm-generic/io.h             |  4 ++
 include/asm-generic/iomap.h          |  4 ++
 include/asm-generic/pgtable.h        |  4 ++
 10 files changed, 179 insertions(+), 28 deletions(-)
