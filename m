Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaIYRtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:49:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35642 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIYRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:49:08 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <sandeep_n@ti.com>, <joe@perches.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v5 0/3] net: Add Keystone NetCP ethernet driver support
Date: Thu, 25 Sep 2014 13:48:34 -0400
Message-ID: <1411667317-1163-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Sandeep Nair <sandeep_n@ti.com>

Sandeep Nair (3):
  Documentation: dt: net: Add binding doc for Keystone NetCP ethernet
    driver
  net: Add Keystone NetCP ethernet driver
  MAINTAINER: net: Add TI NETCP Ethernet driver entry

 .../devicetree/bindings/net/keystone-netcp.txt     |  197 ++
 MAINTAINERS                                        |    7 +
 drivers/net/ethernet/ti/Kconfig                    |   12 +-
 drivers/net/ethernet/ti/Makefile                   |    4 +
 drivers/net/ethernet/ti/netcp.h                    |  227 ++
 drivers/net/ethernet/ti/netcp_core.c               | 2262 ++++++++++++++++++++
 drivers/net/ethernet/ti/netcp_ethss.c              | 2173 +++++++++++++++++++
 drivers/net/ethernet/ti/netcp_sgmii.c              |  130 ++
 drivers/net/ethernet/ti/netcp_xgbepcsr.c           |  502 +++++
 9 files changed, 5513 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/keystone-netcp.txt
 create mode 100644 drivers/net/ethernet/ti/netcp.h
 create mode 100644 drivers/net/ethernet/ti/netcp_core.c
 create mode 100644 drivers/net/ethernet/ti/netcp_ethss.c
 create mode 100644 drivers/net/ethernet/ti/netcp_sgmii.c
 create mode 100644 drivers/net/ethernet/ti/netcp_xgbepcsr.c

Regards,
Santosh
[1] https://lkml.org/lkml/2014/4/22/805
[2] https://lkml.org/lkml/2014/8/15/218
[3] https://lkml.org/lkml/2014/9/11/691
[4] https://lkml.org/lkml/2014/9/15/403
[5] https://lkml.org/lkml/2014/9/25/332
-- 
1.7.9.5

