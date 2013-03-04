Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3CDKfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:35:45 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:47469 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CDKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:35:44 -0500
Date: Mon, 4 Mar 2013 12:35:37 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.9-rc1
Message-ID: <alpine.LFD.2.02.1303041234550.3981@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I managed to miss the merge window. Sorry about that!

Please consider pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

It contains more of Christoph's SLAB unification work that reduce the
differences between different slab allocators. The code has been sitting
in linux-next without problems.

If you feel this is inappropriate for -rc2, just skip the pull and I'll
requeue it for 3.10.

			Pekka

------------------>
The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Christoph Lameter (15):
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

Glauber Costa (1):
      slub: correctly bootstrap boot caches

Joonsoo Kim (1):
      mm/sl[au]b: correct allocation type check in kmalloc_slab()

Pekka Enberg (1):
      Merge branch 'slab/next' into slab/for-linus

 fs/proc/stat.c                |    2 +-
 include/linux/kmalloc_sizes.h |   45 ---
 include/linux/slab.h          |  231 +++++++++----
 include/linux/slab_def.h      |   48 +--
 include/linux/slub_def.h      |  136 +-------
 mm/slab.c                     |  789 +++++++++++++++++------------------------
 mm/slab.h                     |   43 +++-
 mm/slab_common.c              |  165 +++++++++-
 mm/slub.c                     |  188 +---------
 9 files changed, 745 insertions(+), 902 deletions(-)
 delete mode 100644 include/linux/kmalloc_sizes.h
