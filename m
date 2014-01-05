Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867AbaAECFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 21:05:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAECE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 21:04:59 -0500
Date: Sat, 04 Jan 2014 21:04:55 -0500 (EST)
Message-Id: <20140104.210455.997293877557315254.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 Jan 2014 18:04:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these Sparc bug fixes:

1) Missing include can lead to build failure, from Kirill Tkhai.

2) Use dev_is_pci() where applicable, from Yijing Wang.

3) Enable irqs after we enable preemption in cpu startup path,
   from Kirill Tkhai.

4) Revert a __copy_{to,from}_user_inatomic change that broke
   iov_iter_copy_from_user_atomic() and thus several tests in
   xfstests and LTP.  From Dave Kleikamp.

Please pull, thanks a lot!

The following changes since commit dea4f48a0a301b23c65af8e4fe8ccf360c272fbf:

  Merge branch 'leds-fixes-for-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds (2013-12-02 12:08:01 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 16932237f2978a2265662f8de4af743b1f55a209:

  Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines." (2014-01-04 17:55:19 -0800)

----------------------------------------------------------------
Dave Kleikamp (1):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."

Kirill Tkhai (2):
      sparc64: Fix build regression
      sparc64: smp_callin: Enable irqs after preemption is disabled

Yijing Wang (1):
      sparc/PCI: Use dev_is_pci() to identify PCI devices

 arch/sparc/include/asm/uaccess_64.h | 4 ++--
 arch/sparc/kernel/iommu.c           | 2 +-
 arch/sparc/kernel/ioport.c          | 5 ++---
 arch/sparc/kernel/kgdb_64.c         | 1 +
 arch/sparc/kernel/smp_64.c          | 3 ++-
 5 files changed, 8 insertions(+), 7 deletions(-)
