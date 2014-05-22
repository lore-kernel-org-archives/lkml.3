Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaEVVx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:53:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43256 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaEVVx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:53:58 -0400
Date: Thu, 22 May 2014 17:53:56 -0400 (EDT)
Message-Id: <20140522.175356.544649352706511585.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 14:53:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A small bunch of bug fixes, in particular:

1) On older cpus we need a different chunk of virtual address
   space to map the huge page TSB.

2) Missing memory barrier in Niagara2 memcpy.

3) trinity showed some places where fault validation was unnecessarily
   loud on sparc64

4) Some sysfs printf's need a type adjustment, from Toralf Förster

Please pull, thanks a lot.

The following changes since commit 256cf4c438e60116785a83b060614c63c7477e84:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse (2014-05-06 09:09:35 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to 8ecc1bad4c9b485ceb47182d282980d0b0fe20ac:

  sparc64: fix format string mismatch in arch/sparc/kernel/sysfs.c (2014-05-21 12:54:42 -0700)

----------------------------------------------------------------
David S. Miller (3):
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.

Toralf Förster (1):
      sparc64: fix format string mismatch in arch/sparc/kernel/sysfs.c

 arch/sparc/include/asm/pgtable_64.h |  6 ++++--
 arch/sparc/kernel/sysfs.c           |  2 +-
 arch/sparc/lib/NG2memcpy.S          |  1 +
 arch/sparc/mm/fault_64.c            | 16 +---------------
 arch/sparc/mm/tsb.c                 | 14 +++++++++++++-
 5 files changed, 20 insertions(+), 19 deletions(-)
