Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3GOLnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:43:43 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:34623
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635Ab3GOLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:43:42 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzd799h4015I14ffIzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h906i1155h192ch)
From: Srikanth Thokala <srikanth.thokala@xilinx.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH RFC] trafgen: xilinx: add axi traffic generator driver 
Date: Mon, 15 Jul 2013 17:13:29 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <0b2c0db9-c1b5-4404-be6d-2644b4377e09@CH1EHSMHS034.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This is the driver for Xilinx AXI Traffic Generator IP. The
AXI Traffic Generator IP is a core that stresses the AXI4 
interconnect and other AXI4 peripherals in the system.
It generates a wide variety of AXI4 transactions based on
the core programming.

For more details of this IP, please refer:
http://www.xilinx.com/support/documentation/ip_documentation/
axi_traffic_gen/v1_0/pg125-axi-traffic-gen.pdf

The architecture of the core is broadly separated into a master
and slave block, each of which contains the write block and
read block. Other support functions are provided by the
control registers and three internal RAMs - Master RAM (8KB), 
Command RAM(8KB), Parameter RAM(2KB). The initialisation sequence
includes programming Command RAM with commands, data into 
Master RAM (optional Parameter RAM programming) and then 
enable master logic using control register interface.
This sequence generates traffic to cores connected in the
h/w design. It can be interconnect or cores attached via the
interconnect.  The commands programmed selects the specific
core to stress.

The driver for this IP is designed to be a module with 
sysfs interface.  All the control registers and internal
RAMs can be accessed through sysfs interface. Internal
RAMs are designed to be sysfs files with BIN attributes.

Is sysfs the proper interface for this driver? If you 
guys feel there is an other framework where my driver
perfectly fits into, please suggest and provide your
inputs.

Thanks,
Srikanth.

Srikanth Thokala (1):
  trafgen: xilinx: add axi traffic generator driver

 .../devicetree/bindings/misc/xilinx-axitrafgen.txt |   21 +
 drivers/misc/Kconfig                               |   13 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/xilinx_trafgen.c                      | 1160 ++++++++++++++++++++
 4 files changed, 1195 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/xilinx-axitrafgen.txt
 create mode 100644 drivers/misc/xilinx_trafgen.c

-- 
1.7.4


