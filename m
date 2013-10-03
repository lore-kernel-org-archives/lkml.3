Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3JCDwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 23:52:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JCDwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 23:52:07 -0400
Date: Wed, 02 Oct 2013 23:52:06 -0400 (EDT)
Message-Id: <20131002.235206.2101296729379094715.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 20:52:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Couple small bug fixes:

1) strlcpy in ldom_reboot() is still not quite right, use sprintf
   instead from Kees Cook.

2) Generic hugetlb interface pte checks should use the widest return
   type, otherwise high bits can get chopped off.

3) Fix build with PCI MSI enabled on 32-bit sparc.

Please pull, thanks a lot!

The following changes since commit c31eeaced22ce8bd61268a3c595d542bb38c0a4f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-10-01 12:58:48 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to a988fb806d72d4e3a0edbeaece3f2f1172ce44b8:

  sparc: fix MSI build failure on Sparc32 (2013-10-02 20:02:35 -0400)

----------------------------------------------------------------
David Miller (1):
      mm: Fix generic hugetlb pte check return type.

Kees Cook (1):
      sparc: fix ldom_reboot buffer overflow harder

Michael Opdenacker (1):
      sparc: remove deprecated IRQF_DISABLED

Thomas Petazzoni (1):
      sparc: fix MSI build failure on Sparc32

 arch/sparc/Kconfig                 | 7 ++++++-
 arch/sparc/include/asm/floppy_64.h | 2 +-
 arch/sparc/kernel/Makefile         | 3 ++-
 arch/sparc/kernel/ds.c             | 5 ++---
 arch/sparc/kernel/ldc.c            | 4 ++--
 include/asm-generic/hugetlb.h      | 4 ++--
 6 files changed, 15 insertions(+), 10 deletions(-)
