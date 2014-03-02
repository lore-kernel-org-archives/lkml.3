Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaCBOdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:33:49 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:7140 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbaCBOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:33:12 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VPS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdch70kd2iz1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh906i20cfi1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <dougthompson@xmission.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <michal.simek@xilinx.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>
CC: <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <punnaia@xilinx.com>
Subject: [RFC PATCH] EDAC support for ARM PL310 cache controller
Date: Sun, 2 Mar 2014 20:02:39 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <85311a4f-219e-4f3d-ab48-81fce8ef3443@VA3EHSMHS019.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  The following patch adds EDAC support for reporting the data and tag ram
parity errors for ARM PL310 cache controller.
As part of this driver implementtaion, the following options are considered
and this patch is implemented as described in option 3 

1. Enable the parity interrupts in cache-l2x0.c(pl310 driver) and notify the
parity errors based on error interrupt.
   This implementation is straight forward and no dependency with other
modules. But it is not utilizing the edac framework which meant for error
reproting

2. Move the edac chnages to cache-l2x0.c
    With this implementation, the edac farme work may not be ready
during this driver initilaization time. so this could be potential issue.

3. Create seperate driver for parity checking
   This implementaion looks organized. The edac driver always monitor the
status and never modify the control register values except for enabling the 
parity interrupts. But still in this case the pl310 platform device bind to
both the cache-l2x0.c and edac driver and both drivers share the same region.

The current implementation in cache-l2x0.c is not using the interrupts.if this
driver is going to use interrupts then that time the edac driver need modifications
for implementing shared irq mechanism.

So, i request your commnets on this patch and please suggest if there is a
better implemenattion than above.

Punnaiah Choudary Kalluri (1):
  edac: add support for PL310 L2 cache parity

 .../devicetree/bindings/edac/pl310_edac_l2.txt     |   19 ++
 drivers/edac/Kconfig                               |    7 +
 drivers/edac/Makefile                              |    1 +
 drivers/edac/pl310_edac_l2.c                       |  236 ++++++++++++++++++++
 4 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
 create mode 100644 drivers/edac/pl310_edac_l2.c

-- 
1.7.4


