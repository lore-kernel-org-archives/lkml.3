Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaIDSqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:46:20 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46059 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIDSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:46:19 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linuxfoundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Subject: [PATCH 0/5] Support Write-Through mapping on x86
Date: Thu,  4 Sep 2014 12:35:34 -0600
Message-Id: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
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

  https://lkml.org/lkml/2014/8/26/61

All new/modified interfaces have been tested.

---
Toshi Kani (5):
  1/5 x86, mm, pat: Set WT to PA4 slot of PAT MSR
  2/5 x86, mm, pat: Change reserve_memtype() to handle WT
  3/5 x86, mm, asm-gen: Add ioremap_wt() for WT
  4/5 x86, mm: Add set_memory_wt() for WT
  5/5 x86, mm, pat: Add pgprot_writethrough() for WT

---
 arch/x86/include/asm/cacheflush.h    | 10 ++++-
 arch/x86/include/asm/io.h            |  2 +
 arch/x86/include/asm/pgtable_types.h |  3 ++
 arch/x86/mm/ioremap.c                | 24 ++++++++++++
 arch/x86/mm/pageattr.c               | 73 +++++++++++++++++++++++++++++++++---
 arch/x86/mm/pat.c                    | 73 +++++++++++++++++++++++++++---------
 include/asm-generic/io.h             |  4 ++
 include/asm-generic/iomap.h          |  4 ++
 include/asm-generic/pgtable.h        |  4 ++
 9 files changed, 172 insertions(+), 25 deletions(-)
