Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaDTC0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:26:49 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57898 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbaDTC0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:43 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] mm: audit find_vma() callers
Date: Sat, 19 Apr 2014 19:26:25 -0700
Message-Id: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure find_vma() callers do so with the mmap_sem held. 

I'm sure there are a few more places left to fix, but 
this is a pretty good start. Following the call chain,
some users become all tangled up, but I believe these
fixes are correct. Furthermore, the bulk of the callers
of find_vma are in a lot of functions where it is well
known that the mmap_sem is taken way before, such as
get_unmapped_area() family.

Please note that none of the patches are tested.

Thanks!

  blackfin/ptrace: call find_vma with the mmap_sem held
  m68k: call find_vma with the mmap_sem held in sys_cacheflush()
  mips: call find_vma with the mmap_sem held
  arc: call find_vma with the mmap_sem held
  drivers/misc/sgi-gru/grufault.c: call find_vma with the mmap_sem held
  drm/exynos: call find_vma with the mmap_sem held

 arch/arc/kernel/troubleshoot.c          |  7 ++++---
 arch/blackfin/kernel/ptrace.c           |  8 ++++++--
 arch/m68k/kernel/sys_m68k.c             | 18 ++++++++++++------
 arch/mips/kernel/traps.c                |  2 ++
 arch/mips/mm/c-octeon.c                 |  2 ++
 drivers/gpu/drm/exynos/exynos_drm_g2d.c |  6 ++++++
 drivers/misc/sgi-gru/grufault.c         | 13 +++++++++----
 7 files changed, 41 insertions(+), 15 deletions(-)

-- 
1.8.1.4

