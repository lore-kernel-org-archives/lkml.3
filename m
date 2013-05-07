Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3EGGhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:37:14 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:53098 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3EGGhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:37:12 -0400
Date: Tue, 7 May 2013 09:37:05 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.10
Message-ID: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Bulk of the changes are more slab unification from Christoph. There's
also few fixes from Aaron, Glauber, and Joonsoo thrown into the mix.

			Pekka

------------------>
The following changes since commit 51a26ae7a14b85c99c9be470c2d28eeeba0f26a3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-05-06 15:51:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Aaron Tomlin (1):
      mm: slab: Verify the nodeid passed to ____cache_alloc_node

Christoph Lameter (19):
      slab: Use proper formatting specs for unsigned size_t
      slab: Move kmalloc related function defs
      slab: Common kmalloc slab index determination
      slab: Use common kmalloc_index/kmalloc_size functions
      slab: Common name for the per node structures
      slab: Rename nodelists to node
      slab: Common constants for kmalloc boundaries
      slab: Common definition for the array of kmalloc caches
      slab: Common function to create the kmalloc array
      stat: Use size_t for sizes instead of unsigned
      slab: Common Kmalloc cache determination
      slab: Rename list3/l3 to node
      slab: Common definition for kmem_cache_node
      slab: Handle ARCH_DMA_MINALIGN correctly
      slab: Fixup CONFIG_PAGE_ALLOC/DEBUG_SLAB_LEAK sections
      slub: Do not dereference NULL pointer in node_match
      slub: tid must be retrieved from the percpu area of the current processor
      slab: Return NULL for oversized allocations
      mm, slab_common: Fix bootstrap creation of kmalloc caches

Glauber Costa (1):
      slub: correctly bootstrap boot caches

Joonsoo Kim (3):
      mm/sl[au]b: correct allocation type check in kmalloc_slab()
      slub: correct to calculate num of acquired objects in get_partial_node()
      slub: add 'likely' macro to inc_slabs_node()

Pekka Enberg (1):
      Merge branch 'slab/next' into slab/for-linus

 fs/proc/stat.c                |    2 +-
 include/linux/kmalloc_sizes.h |   45 ---
 include/linux/slab.h          |  231 +++++++++----
 include/linux/slab_def.h      |   54 +--
 include/linux/slub_def.h      |  136 +-------
 mm/slab.c                     |  790 +++++++++++++++++------------------------
 mm/slab.h                     |   43 +++-
 mm/slab_common.c              |  174 +++++++++-
 mm/slub.c                     |  221 ++----------
 9 files changed, 781 insertions(+), 915 deletions(-)
 delete mode 100644 include/linux/kmalloc_sizes.h
