Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaDTQXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 12:23:46 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:19471
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbaDTQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 12:23:42 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z551bizzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz17326ah8275bh1de097h186068h5eeeKz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <leoli@freescale.com>, <balbi@ti.com>, <michal.simek@xilinx.c>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [RFC PATCH 0/2] usb: Reuse fsl driver code for synopsys usb controller
Date: Sun, 20 Apr 2014 21:53:27 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <cd97cc6f-7944-4aac-963a-0dedc7bed938@CH1EHSMHS032.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq soc contains a dual role usb controller and this IP is from synopsys. We
observed that there is driver available for this controller from freescale and
decided to reuse this driver for zynq use.

Here is the link for zynq soc TRM. Please refer chapter 15 for usb controller
related information.
http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf

The following series of patches add initial support for zynq soc in fsl gadget controller
driver and fsl host controller driver.

Based on these patches, I have the following concerns and sugesstions

Since the freescale usb driver is for synopsys IP, Please consider rebranding
this driver name and config options to reflect that it is a sysnopsys IP. So
that other vendors who using this IP can reuse thie driver.

Also the ehci-fsl.c is for powerpc based soc's, and zynq is ARM based, i have
protected the code which is specifc to freescale with CONFIG_FSL_SOC. Please
suggest if there is a better way of doing this?

Punnaiah Choudary Kalluri (2):
  usb: gadget: fsl_udc: Add support for zynq usb device controller
  usb: ehci-fsl: Add support for zynq usb host controller

 drivers/usb/gadget/Kconfig        |    2 +-
 drivers/usb/gadget/Makefile       |    1 +
 drivers/usb/gadget/fsl_mxc_udc.c  |   21 ++++++++++++
 drivers/usb/gadget/fsl_udc_core.c |    5 +++
 drivers/usb/gadget/fsl_usb2_udc.h |    2 +-
 drivers/usb/host/Kconfig          |    2 +-
 drivers/usb/host/ehci-fsl.c       |   63 ++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/fsl-mph-dr-of.c  |    9 +++++
 8 files changed, 101 insertions(+), 4 deletions(-)

-- 
1.7.4


