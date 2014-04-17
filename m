Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaDQT67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:58:59 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:16880
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaDQT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:58:50 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(z551bizzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdch5ck70kz1de098h8275bh1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
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
Subject: [PATCH RFC v2 4/4] mtd: nand: Add a devicetree binding for onfi timing parameters
Date: Fri, 18 Apr 2014 01:28:40 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1397764720-29846-1-git-send-email-punnaia@xilinx.com>
References: <1397764720-29846-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <3ce233c6-0549-41bb-a417-3f66cc707cfa@CH1EHSMHS043.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added binding information for onfi timing parameters as per the
onfi 1.0 specification. So, nand controllers that have support for
configuring any of these timing parameters can use this binding
information.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 Documentation/devicetree/bindings/mtd/nand.txt |   46 ++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
index b53f92e..4901091 100644
--- a/Documentation/devicetree/bindings/mtd/nand.txt
+++ b/Documentation/devicetree/bindings/mtd/nand.txt
@@ -19,3 +19,49 @@ errors per {size} bytes".
 The interpretation of these parameters is implementation-defined, so not all
 implementations must support all possible combinations. However, implementations
 are encouraged to further specify the value(s) they support.
+
+Timing parameters:
+  Based on onfi specification 1.0, following are defined parameters.Each
+controller should add supported parameters to IP node.
+All the timing parameters are in nano second time units.
+
+- nand-tADL-ns   : ALE to data loading time
+- nand-tALH-ns   : ALE hold time
+- nand-tALS-ns   : ALE setup time
+- nand-tAR-ns    : ALE to RE# delay
+- nand-tBERS-ns  : Block erase time
+- nand-tCEA-ns   : CE# access time
+- nand-tCCS-ns   : Change column setup time
+- nand-tCH-ns    : CE# hold time
+- nand-tCHZ-ns   : CE# high to output hi-Z
+- nand-tCLH-ns   : CLE hold time
+- nand-tCLR-ns   : CLE to RE# delay
+- nand-tCLS-ns   : CLE setup time
+- nand-tCOH-ns   : CE# high to output hold
+- nand-tCS-ns    : CE# setup time
+- nand-tDH-ns    : Data hold time
+- nand-tDS-ns    : Data setup time
+- nand-tFEAT-ns  : Busy time for Set Features and Get Features
+- nand-tIEBSY-ns : Busy time for interleaved erase operation
+- nand-tIPBSY-ns : Busy time for interleaved program operation
+- nand-tIR-ns    : Output hi-Z to RE# low
+- nand-tPCBSY-ns : Program cache busy time
+- nand-tPROG-ns  : Page program time
+- nand-tR-ns     : Page read time
+- nand-tRC-ns    : RE# cycle time
+- nand-tRCBSY-ns : Read cache busy time
+- nand-tREA-ns   : RE# access time
+- nand-tREH-ns   : RE# high hold time
+- nand-tRHOH-ns  : RE# high to output hold
+- nand-tRHW-ns   : RE# high to WE# low
+- nand-tRHZ-ns   : RE# high to output hi-z
+- nand-tRLOH-ns  : RE# low to output hold
+- nand-tRP-ns    : RE# pulse width
+- nand-tRR-ns    : Ready to RE# low
+- nand-tRST-ns   : Device reset time
+- nand-tWB-ns    : WE# high to R/B# low
+- nand-tWC-ns    : WE# cycle time
+- nand-tWH-ns    : WE# high hold time
+- nand-tWHR-ns   : WE# high to RE# low
+- nand-tWP-ns    : WE# pulse width
+- nand-tWW-ns    : WP# transition to WE# low
-- 
1.7.4


