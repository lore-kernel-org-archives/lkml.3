Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaEZV5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:57:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39342 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:57:50 -0400
Date: Mon, 26 May 2014 22:57:44 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, dwalter@google.com
Subject: [PATCH 00/12] Remove obsolete strict_strto calls
Message-ID: <20140526215744.GB25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>

Replace all calls to strict_strto* functions with appropriate
calls to kstrto*.
Remove definition of strict_strto* functions

All patches apply against current linux git tree

Daniel Walter (12):
  [arch/tile] replace strict_strto* call with kstrto*
  [arch/arm/omap2] replace strict_strto* with kstrto*
  [arch/arm/mach-pxa] replace strict_strto call with kstrto
  [arch/arm/mach-s3c24xx] replace strict_strto* with kstrto*
  [arch/arm/mach-w90x900] replace obsolete strict_strto
  [arch/mips/alchemy] replace obsolete strict_strto
  [arch/mips] replace obsolete strict_strto calls
  [arch/powerpc] replace obsolete strict_strto* calls
  [arch/x86] replace strict_strto calls
  [drivers/scsi] replace strict_strto calls
  [net/sunrpc] replace strict_strto calls
  [include/linux] remove strict_strto* definitions

 arch/arm/mach-omap2/board-omap3touchbook.c |  2 +-
 arch/arm/mach-omap2/mux.c                  | 22 ++++++----------------
 arch/arm/mach-pxa/balloon3.c               |  2 +-
 arch/arm/mach-pxa/viper.c                  |  2 +-
 arch/arm/mach-s3c24xx/mach-jive.c          |  2 +-
 arch/arm/mach-w90x900/cpu.c                |  3 ++-
 arch/mips/alchemy/board-xxs1500.c          |  2 +-
 arch/mips/alchemy/devboards/pm.c           |  4 ++--
 arch/mips/pci/ops-tx4927.c                 |  9 ++++++---
 arch/mips/txx9/generic/setup.c             |  4 ++--
 arch/powerpc/kernel/setup_64.c             |  6 +++---
 arch/powerpc/kernel/vio.c                  |  2 +-
 arch/powerpc/platforms/pseries/dlpar.c     |  4 ++--
 arch/powerpc/platforms/pseries/mobility.c  |  2 +-
 arch/tile/kernel/setup.c                   |  7 ++-----
 arch/tile/kernel/signal.c                  |  7 +++----
 arch/tile/kernel/traps.c                   |  5 ++---
 arch/tile/mm/init.c                        |  2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c      |  4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c           |  6 +++---
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |  4 ++--
 arch/x86/kvm/mmu_audit.c                   |  2 +-
 arch/x86/platform/uv/tlb_uv.c              |  2 +-
 drivers/scsi/pmcraid.c                     |  4 ++--
 drivers/scsi/scsi_sysfs.c                  |  4 ++--
 include/linux/kernel.h                     |  4 ----
 net/sunrpc/addr.c                          | 16 ++++++----------
 net/sunrpc/auth.c                          |  2 +-
 net/sunrpc/xprtsock.c                      |  4 ++--
 29 files changed, 60 insertions(+), 79 deletions(-)

-- 
1.9.3

