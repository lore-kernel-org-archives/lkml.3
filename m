Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaC0SX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:23:59 -0400
Received: from [216.32.181.185] ([216.32.181.185]:32342 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756901AbaC0SWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:22:38 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(z551bizzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdch5ck70kz17326ah8275bh1de097h186068h5eeeKz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh906i2673i1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC 0/3] Add arm pl353 smc driver for xilinx zynq soc
Date: Thu, 27 Mar 2014 23:51:04 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <bb33414a-fa06-4aea-af85-143e6dca95c7@CH1EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add arm pl353 static memory controller driver for
xilinx zynq soc. The arm pl353 smc supports two interfaces i.e nand and
nor/sram memory interfaces. The current implementation supports only a
single SMC instance and nand specific configuration.

xilinx zynq TRM link:
http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf

ARM pl353 smc TRM link:
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0380g/
DDI0380G_smc_pl350_series_r2p1_trm.pdf

Punnaiah Choudary Kalluri (3):
  Devicetree: Add pl353 smc controller devicetree binding information
  memory: pl353: Add driver for arm pl353 static memory controller
  nand: pl353: Add driver for arm pl353 smc nand interface

 .../bindings/memory-controllers/pl353-smc.txt      |   53 +
 drivers/memory/Kconfig                             |    8 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/pl353-smc.c                         |  560 ++++++++++
 drivers/mtd/nand/Kconfig                           |    8 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/pl353_nand.c                      | 1122 ++++++++++++++++++++
 include/linux/memory/pl353-smc.h                   |   37 +
 8 files changed, 1790 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
 create mode 100644 drivers/memory/pl353-smc.c
 create mode 100644 drivers/mtd/nand/pl353_nand.c
 create mode 100644 include/linux/memory/pl353-smc.h

-- 
1.7.4


