Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaIMSbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:31:40 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:53385 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaIMSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:31:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:988:989:1260:1345:1437:1534:1543:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3353:3867:3868:3870:3871:4605:5007:6261:7974:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12679:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: silk57_e1c8f9683e35
X-Filterd-Recvd-Size: 3828
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/8] arm: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:11 -0700
Message-Id: <cover.1410632834.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_warn is used about 3:1 over pr_warning and is mixed use
in arch/arm.  Standardize on pr_warn.

Joe Perches (8):
  arm: Convert pr_warning to pr_warn
  arm: mach-davinci: Convert pr_warning to pr_warn
  arm: mach-ep93xx: Convert pr_warning to pr_warn
  arm: mach-imx: Convert pr_warning to pr_warn
  arm: mach-omap2: Convert pr_warning to pr_warn
  arm: mach-orion5x: Convert pr_warning to pr_warn
  arm: mach-pxa: Convert pr_warning to pr_warn
  arm: mach-u300: Convert pr_warning to pr_warn

 arch/arm/include/asm/syscall.h                 |  8 +--
 arch/arm/kernel/atags_parse.c                  |  2 +-
 arch/arm/kernel/hw_breakpoint.c                | 18 +++---
 arch/arm/kernel/irq.c                          |  4 +-
 arch/arm/kernel/perf_event_cpu.c               |  4 +-
 arch/arm/kernel/smp.c                          |  2 +-
 arch/arm/kernel/unwind.c                       | 24 ++++----
 arch/arm/mach-davinci/board-da830-evm.c        | 76 +++++++++++---------------
 arch/arm/mach-davinci/board-dm644x-evm.c       |  6 +-
 arch/arm/mach-davinci/board-mityomapl138.c     | 38 ++++++-------
 arch/arm/mach-davinci/board-neuros-osd2.c      |  3 +-
 arch/arm/mach-davinci/time.c                   |  6 +-
 arch/arm/mach-ep93xx/core.c                    |  4 +-
 arch/arm/mach-imx/mach-armadillo5x0.c          |  2 +-
 arch/arm/mach-imx/mach-mx31_3ds.c              |  4 +-
 arch/arm/mach-imx/mach-mx31lite.c              |  2 +-
 arch/arm/mach-imx/mach-pcm037.c                |  4 +-
 arch/arm/mach-omap2/display.c                  |  2 +-
 arch/arm/mach-omap2/hdq1w.c                    |  4 +-
 arch/arm/mach-omap2/i2c.c                      |  2 +-
 arch/arm/mach-omap2/msdi.c                     |  4 +-
 arch/arm/mach-omap2/mux.c                      |  2 +-
 arch/arm/mach-omap2/omap_hwmod.c               | 26 ++++-----
 arch/arm/mach-omap2/pdata-quirks.c             |  4 +-
 arch/arm/mach-omap2/pm34xx.c                   |  2 +-
 arch/arm/mach-omap2/smartreflex-class3.c       |  4 +-
 arch/arm/mach-omap2/sr_device.c                |  2 +-
 arch/arm/mach-omap2/vc.c                       |  2 +-
 arch/arm/mach-omap2/voltage.c                  | 22 ++++----
 arch/arm/mach-omap2/wd_timer.c                 |  4 +-
 arch/arm/mach-orion5x/dns323-setup.c           |  8 +--
 arch/arm/mach-orion5x/terastation_pro2-setup.c |  2 +-
 arch/arm/mach-orion5x/ts209-setup.c            |  2 +-
 arch/arm/mach-orion5x/ts409-setup.c            |  2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c           |  4 +-
 arch/arm/mach-pxa/em-x270.c                    |  4 +-
 arch/arm/mach-pxa/gumstix.c                    |  3 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                 | 12 ++--
 arch/arm/mach-pxa/poodle.c                     |  2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                |  6 +-
 arch/arm/mach-pxa/raumfeld.c                   | 26 ++++-----
 arch/arm/mach-u300/dummyspichip.c              | 65 ++++++++++------------
 arch/arm/mm/idmap.c                            |  2 +-
 arch/arm/mm/mmu.c                              |  4 +-
 44 files changed, 200 insertions(+), 229 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

