Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaFXPSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:18:32 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54324 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaFXPSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:18:31 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v6 0/4] arm: KGDB NMI/FIQ support
Date: Tue, 24 Jun 2014 16:18:13 +0100
Message-Id: <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org>
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes it possible to use kgdb's NMI infrastructure on ARM
platforms.

The patches have been previously circulated as part of a large patchset
mixing together ARM architecture code and driver changes
(http://thread.gmane.org/gmane.linux.ports.arm.kernel/333901 ). This
patchset is dramatically cut down to include only the arch/arm code. The
driver code (irqchip and tty/serial) will follow when/if the arch code
is accepted.

The first two patches modify the FIQ infrastructure to allow interrupt
controller drivers to register callbacks (the fiq_chip structure) to
manage FIQ routings and to signal FIQ EOI. This makes it possible to
use FIQ in multi-platform kernels and with recent ARM interrupt
controllers.

The remaining two patches provide architecture support for KGDB's NMI
feature (and rely upon the preceding changes to the FIQ code).

Tested on qemu (versatile), STiH416 (B2020 board) and Freescale i.MX6
quad (wandboard).

Changes since v5:

- Separated anything not strictly impacting arch/arm.
- Fixed a spurious add/remove of code within the series (there was
  broken code in intermediate patches)

For previous changes see:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/333901


Anton Vorontsov (2):
  ARM: Move some macros from entry-armv to entry-header
  ARM: Add KGDB/KDB FIQ debugger generic code

Daniel Thompson (2):
  arm: fiq: Add callbacks to manage FIQ routings
  arm: fiq: Allow EOI to be communicated to the intc

 arch/arm/Kconfig                 |   2 +
 arch/arm/Kconfig.debug           |  18 +++++
 arch/arm/include/asm/fiq.h       |  13 ++++
 arch/arm/include/asm/kgdb.h      |   7 ++
 arch/arm/kernel/Makefile         |   1 +
 arch/arm/kernel/entry-armv.S     | 151 +----------------------------------
 arch/arm/kernel/entry-header.S   | 164 +++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/fiq.c            | 112 +++++++++++++++++++++++++-
 arch/arm/kernel/kgdb_fiq.c       | 124 +++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S |  87 +++++++++++++++++++++
 10 files changed, 527 insertions(+), 152 deletions(-)
 create mode 100644 arch/arm/kernel/kgdb_fiq.c
 create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S

--
1.9.3

