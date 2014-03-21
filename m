Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaCUWvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:51:08 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:43347 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaCUWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:51:01 -0400
From: Yu Zhao <yuzhao@google.com>
To: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        jamieliu@google.com, suleiman@google.com, Yu Zhao <yuzhao@google.com>
Subject: [PATCH 0/3] Per cgroup swap file support
Date: Fri, 21 Mar 2014 15:50:31 -0700
Message-Id: <1395442234-7493-1-git-send-email-yuzhao@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches adds support to configure a cgroup to swap to a
particular file by using control file memory.swapfile.

A value of "default" in memory.swapfile indicates that this cgroup should
use the default, system-wide, swap files. A value of "none" indicates that
this cgroup should never swap. Other values are interpreted as the path
to a private swap file that can only be used by the owner (and its children).

The swap file has to be created and swapon() has to be done on it with
SWAP_FLAG_PRIVATE, before it can be used. This flag ensures that the swap
file is private and does not get used by others.

Jamie Liu (1):
  swap: do not store private swap files on swap_list

Suleiman Souhlal (2):
  mm/swap: support per memory cgroup swapfiles
  swap: Increase the maximum number of swap files to 8192.

 Documentation/cgroups/memory.txt  |  15 ++
 arch/x86/include/asm/pgtable_64.h |  63 ++++++--
 include/linux/memcontrol.h        |   2 +
 include/linux/swap.h              |  45 +++---
 mm/memcontrol.c                   |  76 ++++++++++
 mm/memory.c                       |   3 +-
 mm/shmem.c                        |   2 +-
 mm/swap_state.c                   |   2 +-
 mm/swapfile.c                     | 307 +++++++++++++++++++++++++++++++-------
 mm/vmscan.c                       |   2 +-
 10 files changed, 423 insertions(+), 94 deletions(-)

-- 
1.9.1.423.g4596e3a

