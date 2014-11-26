Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaKZVPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:15:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44055 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaKZVO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:14:59 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Russ Dill <russ.dill@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, Tony Lindgren <tony@atomide.com>,
        <Anson.Huang@freescale.com>, Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 0/2] Add ioremap_exec enhancements
Date: Wed, 26 Nov 2014 15:13:59 -0600
Message-ID: <cover.1417029918.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some platforms need the ability to ioremap memory for use with small
chunks of code, like in certain PM applications that run from sram.

This series provides a common way to call an arch's ioremap_exec, which
currently only exists for ARM, so that we can use it in the generic
sram driver in a forthcoming patch.

This patch is part of a patch series split into several smaller sets
for introducing suspend on AM335x. I plan to use it to copy several
pieces of ASM code from an EMIF driver and the SoC PM code to run from
SRAM on the SoC. I have pushed a branch here [1] based on v3.18-rc6
with all required patches so that the higher level plan for these
patches can be seen.

Regards,
Dave

[1] https://github.com/dgerlach/linux-pm/tree/rfc-pm-am335x-v3.18-rc6

Russ Dill (2):
  asm-generic: io: Add exec versions of ioremap
  lib: devres: Add exec versions of devm_ioremap_resource and friends

 arch/arm/include/asm/io.h   |   2 +
 include/asm-generic/iomap.h |   5 ++
 include/linux/device.h      |  19 ++++++-
 include/linux/io.h          |   9 +++-
 lib/devres.c                | 125 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 154 insertions(+), 6 deletions(-)

-- 
2.1.0

