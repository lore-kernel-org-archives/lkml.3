Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaDGLrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:47:49 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48257 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGLrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:47:46 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Noam Camus <noamc@ezchip.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: [GIT PULL] ARC updates for 3.15 rc1
Thread-Topic: [GIT PULL] ARC updates for 3.15 rc1
Thread-Index: Ac9SVxeSWZFXGu8mSmWolm9CYNrfpg==
Date: Mon, 7 Apr 2014 11:47:03 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751AB922@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC changes for 3.15 merge window.

Thx,
-Vineet

------------------->
The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.15-rc1

for you to fetch changes up to 61fb4bfc010b0d2940f7fd87acbce6a0f03217cb:

  ARC: [nsimosci] Unbork console (2014-04-05 18:36:51 +0530)

----------------------------------------------------------------
ARC changes for 3.15

* Support for external initrd from Noam
* Fix broken serial console in nsimosci Virtual Platform
* Reuse of ENTRY/END assembler macros across hand asm code
* Other minor fixes here and there

----------------------------------------------------------------
Mischa Jonker (3):
      ARC: [arcfpga] Fix __initconst data const-correctness
      ARC: add uImage to .gitignore
      ARC: [nsimosci] Change .dts to use generic 8250 UART

Noam Camus (1):
      ARC: support external initrd

Richard Weinberger (1):
      ARC: Remove ARC_HAS_COH_RTSC

Vineet Gupta (6):
      ARC: switch to generic ENTRY/END assembler annotations
      ARC: [clockevent] can't be SoC specific
      ARC: [clockevent] simplify timer ISR
      ARC: Remove unused DT template file
      ARC: [SMP] General Fixes
      ARC: [nsimosci] Unbork console

 arch/arc/boot/.gitignore            |  1 +
 arch/arc/boot/dts/nsimosci.dts      | 12 +++++----
 arch/arc/boot/dts/skeleton.dts      | 10 -------
 arch/arc/configs/nsimosci_defconfig |  1 +
 arch/arc/include/asm/linkage.h      | 14 ----------
 arch/arc/kernel/ctx_sw_asm.S        |  2 +-
 arch/arc/kernel/entry.S             | 52 ++++++++++++++++++-------------------
 arch/arc/kernel/head.S              |  7 ++---
 arch/arc/kernel/time.c              | 37 ++++++++++++--------------
 arch/arc/lib/memcmp.S               |  6 ++---
 arch/arc/lib/memcpy-700.S           |  6 ++---
 arch/arc/lib/memset.S               | 10 +++----
 arch/arc/lib/strchr-700.S           |  6 ++---
 arch/arc/lib/strcmp.S               |  6 ++---
 arch/arc/lib/strcpy-700.S           |  6 ++---
 arch/arc/lib/strlen.S               |  6 ++---
 arch/arc/mm/cache_arc700.c          |  3 +--
 arch/arc/mm/init.c                  | 27 +++++++++++++++++++
 arch/arc/mm/tlbex.S                 | 10 +++----
 arch/arc/plat-arcfpga/Kconfig       |  1 -
 arch/arc/plat-arcfpga/platform.c    |  6 ++---
 21 files changed, 114 insertions(+), 115 deletions(-)
 delete mode 100644 arch/arc/boot/dts/skeleton.dts
