Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3EHOtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:49:50 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:46056 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755957Ab3EHOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:49:49 -0400
Date: Wed, 8 May 2013 15:49:19 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 patches for 3.10-rc1
Message-ID: <20130508144919.GG2703@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

That's a second round of arm64 patches for this merging window. They are
based on top of my previous pull request (commit 16c85a1fd, which was
based on 3.9-rc3). There is a 'gic' branch which I already pushed
upstream via Olof (commit c2573077) and required to enable ARM_GIC
support on arm64, hence the merge into my branch as well. The diffstat
you should get from this pull is the one shown below, without the 'gic'
changes.

Thanks.

The following changes since commit 16c85a1fd73eade2ae290d759924c09b4595f504:

  arm64: Use acquire/release semantics instead of explicit DMB (2013-04-30 15:58:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-for-linus

for you to fetch changes up to 420c158dcf96ee3a5758c9bf1586b163584c75c7:

  arm64: Treat the bitops index argument as an 'int' (2013-05-08 10:33:17 +0100)

----------------------------------------------------------------
- Since drivers/irqchip/irq-gic.c no longer has dependencies on arm32
  specifics (the 'gic' branch merged), it can be enabled on arm64.
- Enable arm64 support for poweroff/restart (for code under
  drivers/power/reset/).
- Fixes (dts file, exception handling, bitops)

----------------------------------------------------------------
Catalin Marinas (5):
      Merge branch 'gic' into HEAD
      arm64: Enable support for the ARM GIC interrupt controller
      arm64: vexpress: Add support for poweroff/restart
      arm64: Ignore the 'write' ESR flag on cache maintenance faults
      arm64: Treat the bitops index argument as an 'int'

Mark Rutland (1):
      arm64: dts: fix #address-cells for foundation-v8

 arch/arm64/Kconfig                    |  4 ++++
 arch/arm64/boot/dts/foundation-v8.dts |  2 +-
 arch/arm64/include/asm/system_misc.h  |  2 +-
 arch/arm64/kernel/process.c           |  8 ++++----
 arch/arm64/lib/bitops.S               | 10 +++++-----
 arch/arm64/mm/fault.c                 |  3 ++-
 6 files changed, 17 insertions(+), 12 deletions(-)
