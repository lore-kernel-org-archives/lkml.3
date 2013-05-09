Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3EIH5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:57:45 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:47780 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3EIH5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:57:44 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Denis Efremov <yefremov.denis@gmail.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, mingo@redhat.com, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 00/21] Exported funtions that are marked inline
Date: Thu,  9 May 2013 11:57:21 +0400
Message-Id: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
this is a patchset to remove inline marking of exported functions.
Patchset is motivated by
https://lkml.org/lkml/2012/5/10/545 (af3b56289)

I run some tests and inspect the binaries. (You can find the tests
here: https://bitbucket.org/evdenis/tests/src) And it seems (at least
on my configuration) that EXPORT_SYMBOL completely revokes inline
directive. GCC can handle this, but other compilers may be confused
by these two directives. Anyway, you can't inline function that you
expect not to be available for modules with incompatible license and
to be available for the rest.

The tool I use to check the sources:
https://bitbucket.org/evdenis/export_checking.git

arch/arm/mach-sa1100/jornada720_ssp.c  |  2 +-
arch/arm64/lib/delay.c                 |  2 +-
arch/cris/arch-v32/kernel/cache.c      |  2 +-
arch/m68k/sun3/sun3dvma.c              |  2 +-
arch/metag/lib/delay.c                 |  2 +-
arch/mips/pmcs-msp71xx/msp_prom.c      |  2 +-
arch/openrisc/lib/delay.c              |  2 +-
arch/powerpc/platforms/ps3/spu.c       |  2 +-
arch/sparc/prom/tree_64.c              | 14 +++++++-------
arch/tile/lib/spinlock_32.c            |  2 +-
arch/x86/lib/delay.c                   |  2 +-
arch/x86/um/delay.c                    |  2 +-
drivers/dma/dw_dmac.c                  |  4 ++--
drivers/net/wireless/iwlegacy/common.c |  2 +-
drivers/scsi/libiscsi.c                |  2 +-
drivers/scsi/libiscsi_tcp.c            |  8 ++++----
drivers/staging/nvec/nvec.c            |  2 +-
fs/bio.c                               |  2 +-
fs/block_dev.c                         |  2 +-
fs/buffer.c                            |  2 +-
mm/filemap.c                           |  2 +-
net/9p/client.c                        |  4 ++--
net/ipv4/ip_output.c                   |  2 +-
net/netfilter/nf_nat_core.c            |  2 +-
net/nfc/core.c                         |  2 +-
25 files changed, 36 insertions(+), 36 deletions(-)
