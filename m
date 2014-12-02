Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbaLBVmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:42:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47249 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbaLBVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:42:11 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Sandeep Nair <sandeepn02@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@kernel.org>
Subject: [PATCH v7 0/3] net: Add Keystone NetCP ethernet driver support
Date: Tue, 2 Dec 2014 16:41:40 -0500
Message-ID: <1417556503-22290-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v6->v7
Fixed some minor documentation error and also modified the netcp driver
to fix the set* functions to include correct le/be macros.

v5->v6
updated version after incorporating comments [6] from David Miller,
David Laight & Geert Uytterhoeven on v5. I would like get this in
for v3.19 merge window if the latest version is acceptable.

v4->v5
Sorry to spin v5 quickly but I missed few check-patch warnings which
were pointed by Joe Perches(thanks). I folded his changes [5] along with
few more check-patch warning fixes. I would like get this in for v3.18
merge window if David is happy with this version.

v3->v4
Couple of fixes in in error path as pointed [4] out by David. Rest of
the patches are unchanged from v3. 

v2->v3
Update v3 after incorporating Jamal and David Miller's comment/suggestion
from earlier versions [1] [2].  After per the discussion here [3], the
controversial custom exports have been dropped now. And for future
future offload support additions, we will plug into generic frameworks
as an when they are available.

The network coprocessor (NetCP) is a hardware accelerator that processes
Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
switch sub-module to send and receive packets. NetCP also includes a packet
accelerator (PA) module to perform packet classification operations such as
header matching, and packet modification operations such as checksum
generation. NetCP can also optionally include a Security Accelerator(SA)
capable of performing IPSec operations on ingress/egress packets.
    
Keystone SoC's also have a 10 Gigabit Ethernet Subsystem (XGbE) which
includes a 3-port Ethernet switch sub-module capable of 10Gb/s and
1Gb/s rates per Ethernet port.
    
Both GBE and XGBE network processors supported using common driver. It
is also designed to handle future variants of NetCP.

Cc: David Miller <davem@davemloft.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Sandeep Nair <sandeepn02@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@kernel.org>

Murali Karicheri (1):
  MAINTAINER: net: Add TI NETCP Ethernet driver entry

Sandeep Nair (2):
  Documentation: dt: net: Add binding doc for Keystone NetCP ethernet
    driver
  net: Add Keystone NetCP ethernet driver

 .../devicetree/bindings/net/keystone-netcp.txt     |  197 ++
 MAINTAINERS                                        |    8 +
 drivers/net/ethernet/ti/Kconfig                    |   12 +-
 drivers/net/ethernet/ti/Makefile                   |    4 +
 drivers/net/ethernet/ti/netcp.h                    |  227 ++
 drivers/net/ethernet/ti/netcp_core.c               | 2262 ++++++++++++++++++++
 drivers/net/ethernet/ti/netcp_ethss.c              | 2159 +++++++++++++++++++
 drivers/net/ethernet/ti/netcp_sgmii.c              |  130 ++
 drivers/net/ethernet/ti/netcp_xgbepcsr.c           |  501 +++++
 9 files changed, 5499 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/keystone-netcp.txt
 create mode 100644 drivers/net/ethernet/ti/netcp.h
 create mode 100644 drivers/net/ethernet/ti/netcp_core.c
 create mode 100644 drivers/net/ethernet/ti/netcp_ethss.c
 create mode 100644 drivers/net/ethernet/ti/netcp_sgmii.c
 create mode 100644 drivers/net/ethernet/ti/netcp_xgbepcsr.c

[1] https://lkml.org/lkml/2014/4/22/805
[2] https://lkml.org/lkml/2014/8/15/218
[3] https://lkml.org/lkml/2014/9/11/691
[4] https://lkml.org/lkml/2014/9/15/403
[5] https://lkml.org/lkml/2014/9/25/332
[6] https://lkml.org/lkml/2014/9/29/639

-- 
1.7.9.5

