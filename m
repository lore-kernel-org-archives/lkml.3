Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3D2SPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:15:42 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48476 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3D2SPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:15:39 -0400
Date: Mon, 29 Apr 2013 20:15:36 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.10
Message-ID: <alpine.DEB.2.00.1304292008580.20845@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:
  Linus Torvalds (1):
        Linux 3.9

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Add missing cmpxchg64() if CONFIG_RMW_INSNS=y

Michael Schmitz (7):
      m68k/atari: ROM port ISA adapter support
      m68k/atari: use dedicated irq_chip for timer D interrupts
      m68k/atari: EtherNAT - platform device and IRQ support code
      m68k/atari: EtherNEC - add platform device support
      m68k/atari: EtherNAT - add interrupt chip definition for CPLD interrupts
      m68k: Implement ndelay() based on the existing udelay() logic
      m68k/atari: USB - add platform devices for EtherNAT/NetUSBee ISP1160 HCD

Michal Marek (1):
      m68k: Remove inline strlen() implementation

Summarized:
  - The m68k-specific parts for Atari EtherNAT (smc91x), EtherNEC (ne), and
    EtherNAT/NetUSBee (ISP1160 HCD) support,
  - Two build fixes for build-breakage in linux-next.

Thanks for pulling!

 arch/m68k/Kconfig.bus             |   10 ++
 arch/m68k/Kconfig.devices         |   24 ++++
 arch/m68k/atari/ataints.c         |  152 +++++++++++++++++++++++
 arch/m68k/atari/config.c          |  239 +++++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/atarihw.h   |    6 +
 arch/m68k/include/asm/atariints.h |   11 ++-
 arch/m68k/include/asm/cmpxchg.h   |    3 +
 arch/m68k/include/asm/delay.h     |   23 ++++
 arch/m68k/include/asm/io_mm.h     |  136 ++++++++++++++++++++-
 arch/m68k/include/asm/irq.h       |    6 +-
 arch/m68k/include/asm/raw_io.h    |  109 +++++++++++++++++-
 arch/m68k/include/asm/string.h    |   14 --
 arch/m68k/kernel/setup_mm.c       |    6 +
 arch/m68k/lib/string.c            |    2 +-
 14 files changed, 717 insertions(+), 24 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
