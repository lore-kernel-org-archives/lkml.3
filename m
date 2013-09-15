Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3IOHQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 03:16:20 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:35527 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3IOHQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 03:16:19 -0400
MIME-Version: 1.0
Date: Sun, 15 Sep 2013 10:16:17 +0300
X-Google-Sender-Auth: 5iCc9KXVh1niBTTIkmlk4aLDks0
Message-ID: <CAOJsxLFyo8daz1zVnoPBR000nwS94pq-=9q_WFxD0Uv-kB+xVQ@mail.gmail.com>
Subject: [GIT PULL] SLAB changes for v3.12
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

Nothing terribly exciting here apart from Christoph's kmalloc
unification patches that brings sl[aou]b implementations closer to
each other.

                       Pekka

------------------>
The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/next

for you to fetch changes up to 23774a2f6fee0848503bfb8004eeeb5adef94f5c:

  slab: Use correct GFP_DMA constant (2013-09-04 23:11:42 +0300)

----------------------------------------------------------------
Chen Gang (3):
      mm/slub: remove 'per_cpu' which is useless variable
      mm/slub: beautify code for 80 column limitation and tab alignment
      mm/slub.c: beautify code for removing redundancy 'break' statement.

Christoph Lameter (3):
      mm/sl[aou]b: Move kmallocXXX functions to common code
      slub: remove verify_mem_not_deleted()
      slab: Use correct GFP_DMA constant

Joonsoo Kim (1):
      mm, slab_common: add 'unlikely' to size check of kmalloc_slab()

Libin (1):
      slub: Remove unnecessary page NULL check

Uwe Kleine-König (1):
      slub: don't use cpu partial pages on UP

 include/linux/slab.h     | 156 +++++++++++++++++++++++++++++++++++++----------
 include/linux/slab_def.h | 106 --------------------------------
 include/linux/slob_def.h |  31 ----------
 include/linux/slub_def.h | 110 ---------------------------------
 init/Kconfig             |   2 +-
 mm/slab_common.c         |  12 +++-
 mm/slob.c                |  28 +++++++--
 mm/slub.c                | 142 +++++++++++++++++-------------------------
 8 files changed, 216 insertions(+), 371 deletions(-)
 delete mode 100644 include/linux/slob_def.h
