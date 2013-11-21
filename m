Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab3KUIFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:05:17 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:37188 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3KUIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:05:16 -0500
From: Pekka Enberg <penberg@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.13
Date: Thu, 21 Nov 2013 10:04:59 +0200
Message-Id: <1385021099-3264-1-git-send-email-penberg@iki.fi>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

The patches from Joonsoo Kim switch mm/slab.c to use 'struct page' for slab
internals similar to mm/slub.c.  This reduces memory usage and improves
performance:

  https://lkml.org/lkml/2013/10/16/155

Rest of the changes are bug fixes from various people.

			Pekka

------------------>
The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

for you to fetch changes up to 721ae22ae1a51c25871b7a0b543877aa94ff2a20:

  mm, slub: fix the typo in mm/slub.c (2013-11-11 18:19:07 +0200)

----------------------------------------------------------------
Christoph Lameter (1):
      slub: Handle NULL parameter in kmem_cache_flags

Joonsoo Kim (17):
      slab: correct pfmemalloc check
      slab: change return type of kmem_getpages() to struct page
      slab: remove colouroff in struct slab
      slab: remove nodeid in struct slab
      slab: remove cachep in struct slab_rcu
      slab: overloading the RCU head over the LRU for RCU free
      slab: use well-defined macro, virt_to_slab()
      slab: use __GFP_COMP flag for allocating slab pages
      slab: change the management method of free objects of the slab
      slab: remove kmem_bufctl_t
      slab: remove SLAB_LIMIT
      slab: replace free and inuse in struct slab with newly introduced active
      slab: use struct page for slab management
      slab: remove useless statement for checking pfmemalloc
      slab: rename slab_bufctl to slab_freelist
      slab: fix to calm down kmemleak warning
      slab: replace non-existing 'struct freelist *' with 'void *'

Pekka Enberg (1):
      Merge branch 'slab/struct-page' into slab/next

Roman Bobniev (1):
      slub: proper kmemleak tracking if CONFIG_SLUB_DEBUG disabled

Zhi Yong Wu (2):
      mm, slub: fix the typo in include/linux/slub_def.h
      mm, slub: fix the typo in mm/slub.c

 include/linux/mm_types.h |  24 +-
 include/linux/slab.h     |   9 +-
 include/linux/slab_def.h |   4 +-
 include/linux/slub_def.h |   2 +-
 mm/slab.c                | 571 ++++++++++++++++++-----------------------------
 mm/slub.c                |  45 +++-
 6 files changed, 280 insertions(+), 375 deletions(-)
