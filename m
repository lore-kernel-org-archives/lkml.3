Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaDASxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:53:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaDASxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:53:11 -0400
Date: Tue, 1 Apr 2014 11:52:43 -0700
Message-Id: <201404011852.s31Iqh12025199@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 old platform removal for v3.15
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: hpa@linux.intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mdr@sgi.com, mingo@kernel.org, paul.gortmaker@windriver.com,
        paulmck@linux.vnet.ibm.com, pazke@donpac.ru, rientjes@google.com,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset removes support for several completely obsolete
platforms, where the maintainers either have completely vanished or
acked the removal.  For some of them it is questionable if there even
exists functional specimens of the hardware.

The following changes since commit dc9788f40a769d967de3eb5a7aee8c1a70094d32:

  x86/apic: Always define nox2apic and define it as initdata (2014-02-09 15:15:11 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-nuke-platforms-for-linus

for you to fetch changes up to b5660ba76b41af69a0c09d434927bb4b4cadd4b1:

  x86, platforms: Remove NUMAQ (2014-02-27 08:07:39 -0800)

----------------------------------------------------------------
David Rientjes (2):
      x86, apic: Remove support for ia32-based Unisys ES7000
      x86, apic: Remove support for IBM Summit/EXA chipset

H. Peter Anvin (2):
      x86, platforms: Remove SGI Visual Workstation
      x86, platforms: Remove NUMAQ

 Documentation/00-INDEX                 |    2 -
 Documentation/sgi-visws.txt            |   13 -
 Documentation/sound/oss/vwsnd          |  293 ---
 MAINTAINERS                            |    7 -
 arch/x86/Kconfig                       |   82 +-
 arch/x86/Kconfig.cpu                   |    2 +-
 arch/x86/include/asm/fixmap.h          |    6 -
 arch/x86/include/asm/hw_irq.h          |    1 -
 arch/x86/include/asm/mmzone_32.h       |    3 -
 arch/x86/include/asm/mpspec.h          |    6 -
 arch/x86/include/asm/numaq.h           |  171 --
 arch/x86/include/asm/setup.h           |    6 -
 arch/x86/include/asm/visws/cobalt.h    |  127 --
 arch/x86/include/asm/visws/lithium.h   |   53 -
 arch/x86/include/asm/visws/piix4.h     |  107 -
 arch/x86/include/asm/visws/sgivw.h     |    5 -
 arch/x86/kernel/acpi/boot.c            |   12 -
 arch/x86/kernel/apic/Makefile          |    3 -
 arch/x86/kernel/apic/apic.c            |    1 -
 arch/x86/kernel/apic/es7000_32.c       |  738 -------
 arch/x86/kernel/apic/numaq_32.c        |  524 -----
 arch/x86/kernel/apic/summit_32.c       |  550 -----
 arch/x86/kernel/cpu/intel.c            |    4 -
 arch/x86/kernel/setup.c                |    1 -
 arch/x86/mm/numa.c                     |    4 -
 arch/x86/pci/Makefile                  |    3 -
 arch/x86/pci/common.c                  |    5 +-
 arch/x86/pci/numaq_32.c                |  165 --
 arch/x86/pci/visws.c                   |   87 -
 arch/x86/platform/Makefile             |    1 -
 arch/x86/platform/visws/Makefile       |    1 -
 arch/x86/platform/visws/visws_quirks.c |  608 ------
 arch/x86/xen/Kconfig                   |    2 +-
 drivers/clocksource/Makefile           |    1 -
 drivers/clocksource/cyclone.c          |  113 -
 drivers/pci/Makefile                   |    1 -
 drivers/scsi/qla1280.c                 |    7 -
 drivers/video/Kconfig                  |   11 +-
 drivers/video/Makefile                 |    1 -
 drivers/video/gbefb.c                  |    4 -
 drivers/video/logo/Kconfig             |    2 +-
 drivers/video/logo/logo.c              |    2 +-
 drivers/video/sgivwfb.c                |  889 --------
 include/video/sgivw.h                  |  681 -------
 sound/oss/Kconfig                      |    9 -
 sound/oss/Makefile                     |    1 -
 sound/oss/vwsnd.c                      | 3506 --------------------------------
 47 files changed, 15 insertions(+), 8806 deletions(-)

[Full diff not included due to length and general boringness]
