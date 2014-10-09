Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbaJIVrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:47:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389AbaJIVrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:47:36 -0400
Date: Thu, 9 Oct 2014 14:47:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.21
Message-ID: <20141009214735.GA8638@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.21 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/unicore32/include/asm/mmu_context.h |    4=20
 drivers/block/drbd/drbd_nl.c             |    6=20
 drivers/cpufreq/integrator-cpufreq.c     |    4=20
 drivers/gpu/drm/i915/i915_gem_gtt.c      |   14 +
 drivers/md/raid5.c                       |   18 ++
 drivers/media/v4l2-core/videobuf2-core.c |   15 +-
 fs/cifs/cifsglob.h                       |    2=20
 fs/cifs/file.c                           |    2=20
 fs/cifs/readdir.c                        |    2=20
 fs/cifs/smb1ops.c                        |    9 +
 fs/cifs/smb2maperror.c                   |    4=20
 fs/cifs/smb2ops.c                        |    9 +
 fs/cifs/smb2pdu.c                        |    9 -
 fs/exec.c                                |    5=20
 fs/hugetlbfs/inode.c                     |    5=20
 fs/proc/task_mmu.c                       |    3=20
 fs/udf/inode.c                           |   35 ++--
 include/linux/cpuset.h                   |   27 +--
 include/linux/hugetlb.h                  |   10 +
 include/linux/jiffies.h                  |   12 -
 include/linux/mm_types.h                 |    4=20
 include/linux/plist.h                    |   45 ++++++
 include/linux/sched.h                    |    7=20
 include/linux/swap.h                     |    8 -
 include/linux/swapfile.h                 |    2=20
 include/linux/vmacache.h                 |   38 +++++
 include/media/videobuf2-core.h           |    4=20
 init/Kconfig                             |    1=20
 kernel/cpuset.c                          |    2=20
 kernel/debug/debug_core.c                |   14 +
 kernel/events/core.c                     |    4=20
 kernel/fork.c                            |   12 +
 kernel/time.c                            |   54 ++++---
 kernel/trace/ring_buffer.c               |    2=20
 lib/plist.c                              |   52 +++++++
 mm/Makefile                              |    2=20
 mm/compaction.c                          |   94 ++++++-------
 mm/filemap.c                             |   10 -
 mm/frontswap.c                           |   13 -
 mm/huge_memory.c                         |   11 -
 mm/hugetlb.c                             |   17 ++
 mm/mempolicy.c                           |   12 -
 mm/migrate.c                             |    5=20
 mm/mmap.c                                |   55 ++++---
 mm/nommu.c                               |   24 ++-
 mm/page_alloc.c                          |   13 -
 mm/readahead.c                           |    4=20
 mm/slab.c                                |    4=20
 mm/slub.c                                |   16 --
 mm/swapfile.c                            |  224 ++++++++++++++++----------=
-----
 mm/vmacache.c                            |  114 +++++++++++++++
 mm/vmscan.c                              |   32 ++--
 53 files changed, 749 insertions(+), 347 deletions(-)

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Arnd Bergmann (1):
      cpufreq: integrator: fix integrator_cpufreq_remove return type

Chris Wilson (1):
      drm/i915: Flush the PTEs after updating them before suspend

Christoph Lameter (1):
      vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()

Dan Streetman (4):
      swap: change swap_info singly-linked list to list_head
      lib/plist: add helper functions
      lib/plist: add plist_requeue
      swap: change swap_list_head to plist, add swap_avail_head

David Rientjes (3):
      mm, compaction: avoid isolating pinned pages
      mm, compaction: determine isolation mode only once
      mm, compaction: ignore pageblock skip when manually invoking compacti=
on

Davidlohr Bueso (1):
      mm: per-thread vma caching

Greg Kroah-Hartman (1):
      Linux 3.14.21

Hans Verkuil (1):
      media: vb2: fix VBI/poll regression

Jan Kara (1):
      udf: Avoid infinite loop when processing indirect ICBs

Jens Axboe (1):
      mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT

Joonsoo Kim (5):
      mm/compaction: disallow high-order page for migration target
      mm/compaction: do not call suitable_migration_target() on every page
      mm/compaction: change the timing to check to drop the spinlock
      mm/compaction: check pageblock suitability once per pageblock
      mm/compaction: clean-up code on success of ballon isolation

Josh Triplett (1):
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Lars Ellenberg (1):
      drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Linus Torvalds (1):
      mm: don't pointlessly use BUG_ON() for sanity check

Mel Gorman (3):
      mm: migrate: Close race between migration completion and mprotect
      mm: numa: Do not mark PTEs pte_numa when splitting huge pages
      mm: optimize put_mems_allowed() usage

Michal Hocko (1):
      mm: exclude memoryless nodes from zone_reclaim

NeilBrown (1):
      md/raid5: disable 'DISCARD' by default due to safety concerns.

Nishanth Aravamudan (1):
      hugetlb: ensure hugepage access is denied if hugepages are not suppor=
ted

Pavel Shilovsky (1):
      CIFS: Fix SMB2 readdir error handling

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Raghavendra K T (1):
      mm/readahead.c: fix readahead failure for memoryless NUMA nodes and l=
imit readahead pages

Steve French (1):
      Fix problem recognizing symlinks

Steven Rostedt (Red Hat) (1):
      ring-buffer: Fix infinite spin in reading buffer

Vladimir Davydov (2):
      mm: vmscan: respect NUMA policy mask when shrinking slab on direct re=
claim
      mm: vmscan: shrink_slab: rename max_pass -> freeable

Waiman Long (1):
      mm, thp: move invariant bug check out of loop in __split_huge_page_map


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNwJ3AAoJEDjbvchgkmk+BnwP/0D+Lh6XZwXjR0OXzss8Xa+d
pFlt2AGX6RCvcPZ4D+5HQ1yWUboFTlEzmnDMySv+CFDyuT7veTlt4frQODYTf5NY
4tEfSFq7W3kABlsOpGLERCK/DEZUjgblw4Ki2+pnNpPNndxyiZ1gptYwAKpvN0VU
dC1OK7eB19ylZapMOMKtAq+JFslVipZiVTOs2GHWLlVhaK7NU5LxpoR6dGxT6UuD
mhSGoXatwrWsoct9FS8KYQRe0WnHKzzoKJsncQv2jYh4c/Bf4wB7xTRIWO1d8I0K
WvAbfrmPbzQOnYcxLuDeYp7WWQTwOTEg2bDfPX8FF5dfNQhtOdi6EcijsJw6tNUQ
qqeRHBY9hLaS8OIIgeUgcyL0DxPverGgfHHMLUIIgvv9NDxgPA2y3K0WaswWDV1W
JrgNrV5KY+21FMJppqZDni7ZEngEftfS+Zarc2uqWtU3GN2AitTnJpWHwOrv7lm5
0PEeK3h4hthzsygHFtgEjmDzec6se0Z5yZjFLh7uGwa5JTFzpo5Hl4xgDBYQ4HSY
KqyMjA6HovUqjsZUGsQ84Ocan/u4E23z9CzGrStB7lS5LeW+u6s2uOdr/76EeGrz
qrLXT/zwWhVei0IK9IW+qyWWGcSLthOlxRBBYZqLpgbD9PuKwfFg18bSnmB9T0TD
oNS6iUIsModug27yIQZk
=PpRT
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
