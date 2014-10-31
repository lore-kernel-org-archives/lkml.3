Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbaJaUo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:44:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43561 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaJaUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:44:24 -0400
Date: Fri, 31 Oct 2014 16:44:20 -0400 (EDT)
Message-Id: <20141031.164420.347853554417112227.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 13:44:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two changes:

1) It makes no sense to execute a VTOC partition table request
   in the Sun virtual block device driver and fail to load if it
   doesn't succeed because a) we don't use the result at all and
   b) it won't succeed if there is an EFI partition on the disk,
   for example.

   We read the partition table via the normal means in the block
   layer anyways, so this is really completely useless, so just
   remove it.

   From Dwight Engen.

2) Hook up new bpf system call.

Please pull, thanks a lot!

The following changes since commit f7e87a44ef60ad379e39b45437604141453bf0ec:

  Merge tag 'media/v3.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-10-27 15:05:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 85b0c6e62c48bb9179fd5b3e954f362fb346cbd5:

  sunvdc: don't call VD_OP_GET_VTOC (2014-10-31 15:49:45 -0400)

----------------------------------------------------------------
David S. Miller (1):
      sparc: Hook up bpf system call.

Dwight Engen (1):
      sunvdc: don't call VD_OP_GET_VTOC

 arch/sparc/include/uapi/asm/unistd.h | 3 ++-
 arch/sparc/kernel/systbls_32.S       | 2 +-
 arch/sparc/kernel/systbls_64.S       | 4 ++--
 drivers/block/sunvdc.c               | 9 ---------
 4 files changed, 5 insertions(+), 13 deletions(-)
