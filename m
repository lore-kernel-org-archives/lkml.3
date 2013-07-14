Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3GNTHJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:07:09 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44531 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3GNTHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:07:06 -0400
Date: Sun, 14 Jul 2013 22:06:59 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.11-rc0
Message-ID: <alpine.LFD.2.03.1307142205090.2124@kernel.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Highlights:

  - Fix for boot-time problems on some architectures due to
    init_lock_keys() not respecting kmalloc_caches boundaries
    (Christoph Lameter)

  - CONFIG_SLUB_CPU_PARTIAL requested by RT folks (Joonsoo Kim)

  - Fix for excessive slab freelist draining (Wanpeng Li)

  - SLUB and SLOB cleanups and fixes (various people)

The tree also contains Christoph's unification work that I merged in
too late had to revert because it broke things. We'll try again for
v3.12.

			Pekka

------------------>
The following changes since commit 21884a83b2192a00885d7244a1dda32debd2fbc7:

  Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-07-06 14:09:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Christoph Lameter (4):
      slob: Rework #ifdeffery in slab.h
      slab: fix init_lock_keys
      mm/sl[aou]b: Move kmalloc_node functions to common code
      mm/sl[aou]b: Move kmalloc definitions to slab.h

Joonsoo Kim (2):
      slub: do not put a slab to cpu partial list when cpu_partial is 0
      slub: Make cpu partial slab support configurable

Michael Opdenacker (1):
      slab: add kmalloc() to kernel API documentation

Pekka Enberg (2):
      Revert "mm/sl[aou]b: Move kmalloc definitions to slab.h"
      Revert "mm/sl[aou]b: Move kmalloc_node functions to common code"

Sasha Levin (1):
      slob: use DIV_ROUND_UP where possible

Steven Rostedt (2):
      slob: Check for NULL pointer before calling ctor()
      slub: Check for page NULL before doing the node_match check

Wanpeng Li (6):
      mm/slab: Fix drain freelist excessively
      mm/slab: Sharing s_next and s_stop between slab and slub
      mm/slab: Fix /proc/slabinfo unwriteable for slab
      mm/slub: Drop unnecessary nr_partials
      mm/slub: Use node_nr_slabs and node_nr_objs in get_slabinfo
      mm/slab: Give s_next and s_stop slab-specific names

Zhouping Liu (1):
      mm, slab: moved kmem_cache_alloc_node comment to correct place

 include/linux/slab.h     |   57 +++++++++++++++++++++++++++++++++------------
 include/linux/slob_def.h |    8 ------
 init/Kconfig             |   11 +++++++++
 mm/slab.c                |   51 ++++++++++++++++++----------------------
 mm/slab.h                |    3 ++
 mm/slab_common.c         |   18 ++++++++++----
 mm/slob.c                |    4 +-
 mm/slub.c                |   38 +++++++++++++++++++++---------
 8 files changed, 121 insertions(+), 69 deletions(-)
