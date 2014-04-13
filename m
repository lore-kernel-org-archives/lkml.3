Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaDMJ20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 05:28:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60252 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaDMJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 05:28:23 -0400
From: Pekka Enberg <penberg@iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.15-rc1
Date: Sun, 13 Apr 2014 12:28:16 +0300
Message-Id: <1397381296-13961-1-git-send-email-penberg@iki.fi>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

The biggest change is byte-sized freelist indices which reduces slab freelist
memory usage:

  https://lkml.org/lkml/2013/12/2/64

			Pekka

------------------>
The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

for you to fetch changes up to 34bf6ef94a835a8f1d8abd3e7d38c6c08d205867:

  mm: slab/slub: use page->list consistently instead of page->lru (2014-04-11 10:06:06 +0300)

----------------------------------------------------------------
Dave Hansen (1):
      mm: slab/slub: use page->list consistently instead of page->lru

Jianyu Zhan (1):
      mm/slab.c: cleanup outdated comments and unify variables naming

Joe Perches (1):
      slab: Make allocations with GFP_ZERO slightly more efficient

Joonsoo Kim (7):
      slab: factor out calculate nr objects in cache_estimate
      slab: introduce helper functions to get/set free object
      slab: restrict the number of objects in a slab
      slab: introduce byte sized index for the freelist of a slab
      slab: make more slab management structure off the slab
      slub: fix high order page allocation problem with __GFP_NOFAIL
      slab: fix wrongly used macro

 include/linux/mm_types.h |   3 +-
 include/linux/slab.h     |  11 +++
 mm/slab.c                | 183 +++++++++++++++++++++++++++--------------------
 mm/slob.c                |  10 +--
 mm/slub.c                |   5 +-
 5 files changed, 128 insertions(+), 84 deletions(-)
