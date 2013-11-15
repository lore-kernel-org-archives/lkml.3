Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3KOKug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:50:36 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:43339
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab3KOKu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:50:29 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz936eIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz17326ah8275dh1de097h186068hz2dh87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@kernel.org>
To: <torvalds@linux-foundation.org>
CC: <adi-buildroot-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.13
Date: Fri, 15 Nov 2013 18:54:37 +0800
Message-ID: <1384512877-25669-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin updates for Linux 3.13, blackfin gpio changes, add adi pinctrl
driver, and bug fixes.

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to 36855dcfc980f247909b8f63776664c6ccb6f183:

  blackfin: fix build warning for unused variable (2013-11-15 18:14:55 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.13

----------------------------------------------------------------
Scott Jiang (2):
      bf609: update default config for spi
      pm: use GFP_ATOMIC when pm core call this function

Sonic Zhang (3):
      Blackfin: bfin_gpio: Use proper mask for comparing pfunc
      blackfin: adi gpio driver and pinctrl driver support
      blackfin: serial: Add serial port_fer and port_mux early platform resources.

Steven Miao (3):
      blackfin: pinctrl-adi2: code cleanup after using pinctrl-adi2
      smp: bf561: and smb_wmb()/smp_rmb() at ipi send/receive
      blackfin: fix build warning for unused variable

 arch/blackfin/Kconfig                           |    8 +
 arch/blackfin/configs/BF609-EZKIT_defconfig     |    2 +-
 arch/blackfin/include/asm/gpio.h                |  157 +------
 arch/blackfin/include/asm/irq.h                 |    3 +-
 arch/blackfin/include/asm/irq_handler.h         |    6 +-
 arch/blackfin/include/asm/portmux.h             |   19 +-
 arch/blackfin/kernel/Makefile                   |    3 +-
 arch/blackfin/kernel/bfin_gpio.c                |  159 +------
 arch/blackfin/mach-bf548/Kconfig                |   34 --
 arch/blackfin/mach-bf548/boards/ezkit.c         |  538 ++++++++++++++++++++++-
 arch/blackfin/mach-bf548/include/mach/gpio.h    |    8 -
 arch/blackfin/mach-bf548/include/mach/irq.h     |    2 +-
 arch/blackfin/mach-bf548/include/mach/portmux.h |    2 -
 arch/blackfin/mach-bf609/Kconfig                |   42 --
 arch/blackfin/mach-bf609/boards/ezkit.c         |  472 ++++++++++++++++++--
 arch/blackfin/mach-bf609/include/mach/gpio.h    |    8 -
 arch/blackfin/mach-bf609/include/mach/irq.h     |    2 +-
 arch/blackfin/mach-bf609/include/mach/portmux.h |    6 +-
 arch/blackfin/mach-common/ints-priority.c       |  421 ++----------------
 arch/blackfin/mach-common/pm.c                  |   22 +-
 arch/blackfin/mach-common/smp.c                 |   12 +-
 21 files changed, 1072 insertions(+), 854 deletions(-)

