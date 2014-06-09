Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbaFINcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:32:31 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:53533 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933AbaFINc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:32:28 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>,
        Terence Eden <github.com@shkspr.mobi>
Subject: [GIT PULL] ARC updates for 3.16 rc1
Thread-Topic: [GIT PULL] ARC updates for 3.16 rc1
Thread-Index: Ac+D5z4Z1t6Edbn5Q1yuyo3bhKCcZg==
Date: Mon, 9 Jun 2014 13:32:22 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B6CF1@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC changes for 3.16 merge window.

Thx,
-Vineet

----------------->
The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.16-rc1

for you to fetch changes up to ef680cdc24376f394841a3f19b3a7ef6d57a009d:

  ARC: Disable caches in early boot if so configured (2014-06-03 15:14:48 +0530)

----------------------------------------------------------------
Nothing too exciting here, just minor fixes/cleanup. Only noteworthy ones are:

* Moving cache disabling to early boot
* ARC UART enabled only if earlyprintk setup in cmdline

----------------------------------------------------------------
Terence Eden (1):
      ARC: Fixed spelling errors within comments

Vineet Gupta (8):
      ARC: [SMP] ISS SMP extension bitrot
      ARC: fix mmuv2 warning
      ARC: make start_thread() out-of-line
      ARC: arc_local_timer_setup() need not pass own cpu id
      ARC: remove duplicate header exports
      ARC: [arcfpga] Get rid of legacy BVCI latency unit support
      ARC: [arcfpga] Early ARC UART to be only activated by cmdline
      ARC: Disable caches in early boot if so configured

 arch/arc/boot/dts/angel4.dts     |   2 +-
 arch/arc/include/asm/cache.h     |  27 ++++++++++
 arch/arc/include/asm/irq.h       |   4 +-
 arch/arc/include/asm/processor.h |  29 ++---------
 arch/arc/include/uapi/asm/Kbuild |   7 ---
 arch/arc/kernel/entry.S          |  12 ++---
 arch/arc/kernel/head.S           |  38 ++++++++++++--
 arch/arc/kernel/irq.c            |  18 -------
 arch/arc/kernel/process.c        |  23 ++++++++
 arch/arc/kernel/smp.c            |   2 +-
 arch/arc/kernel/time.c           |  11 ++--
 arch/arc/mm/cache_arc700.c       | 110 +++++++++++----------------------------
 arch/arc/plat-arcfpga/Kconfig    |  32 ------------
 arch/arc/plat-arcfpga/Makefile   |   2 +-
 arch/arc/plat-arcfpga/platform.c |  72 +++----------------------
 arch/arc/plat-arcfpga/smp.c      |  18 +++++++
 16 files changed, 158 insertions(+), 249 deletions(-)
