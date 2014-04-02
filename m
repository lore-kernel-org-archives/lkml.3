Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaDBUfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:35:34 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:56674 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763AbaDBUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:35:30 -0400
From: Yu Zhao <yuzhao@google.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jamieliu@google.com, suleiman@google.com, hannes@cmpxchg.org,
        Yu Zhao <yuzhao@google.com>
Subject: [PATCH v2 0/3] Per-cgroup swap file support
Date: Wed,  2 Apr 2014 13:34:06 -0700
Message-Id: <1396470849-26154-1-git-send-email-yuzhao@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support to configure a cgroup to swap to a
particular file by using control file memory.swapfile.

Originally, cgroups share system-wide swap space and limiting cgroup swapping
is not possible. This patchset solves the problem by adding mechanism that
isolates cgroup swap spaces (i.e. per-cgroup swap file) so users can safely
enable swap for particular cgroups without worrying about one cgroup uses up
all swap space.

A value of "default" in memory.swapfile indicates that this cgroup should
use the default, system-wide, swap files. A value of "none" indicates that
this cgroup should never swap. Other values are interpreted as the path
to a private swap file that can only be used by the owner (and its children).

The swap file has to be created and swapon() has to be done on it with
SWAP_FLAG_PRIVATE, before it can be used. This flag ensures that the swap
file is private and does not get used by others.

Changelog since v1:
  - Fixed typos in comment and commit message
  - Added rationale to this cover letter (Johannes Weiner)

Jamie Liu (1):
  swap: do not store private swap files on swap_list

Suleiman Souhlal (2):
  mm/swap: support per memory cgroup swapfiles
  swap: Increase the max swap files to 8192 on x86_64

 Documentation/cgroups/memory.txt  |  15 ++
 arch/x86/include/asm/pgtable_64.h |  62 ++++++--
 include/linux/memcontrol.h        |   2 +
 include/linux/swap.h              |  45 +++---
 mm/memcontrol.c                   |  76 ++++++++++
 mm/memory.c                       |   3 +-
 mm/shmem.c                        |   2 +-
 mm/swap_state.c                   |   2 +-
 mm/swapfile.c                     | 307 +++++++++++++++++++++++++++++++-------
 mm/vmscan.c                       |   2 +-
 10 files changed, 422 insertions(+), 94 deletions(-)

-- 
1.9.1.423.g4596e3a

