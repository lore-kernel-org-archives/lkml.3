Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaIMUHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:07:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49091 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaIMUHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:07:52 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <sandeep_n@ti.com>, <jhs@mojatatu.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 0/3] net: Add Keystone NetCP ethernet driver support
Date: Sat, 13 Sep 2014 16:07:16 -0400
Message-ID: <1410638839-14792-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update v3 after incorporating Jamal and David Miller's comment/suggestion
from earlier versions [1] [2]. I would like to get these merged for upcoming
3.18 merge window if there are no concerns on this version.

After per the discussion here [3], the controversial custom exports have
been dropped now. And for future future offload support additions, we will
plug into generic frameworks as an when they are available.

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
 MAINTAINERS                                        |    6 +
 drivers/net/ethernet/ti/Kconfig                    |   16 +-
 drivers/net/ethernet/ti/Makefile                   |    4 +
 drivers/net/ethernet/ti/netcp.h                    |  227 ++
 drivers/net/ethernet/ti/netcp_core.c               | 2266 ++++++++++++++++++++
 drivers/net/ethernet/ti/netcp_ethss.c              | 2178 +++++++++++++++++++
 drivers/net/ethernet/ti/netcp_sgmii.c              |  130 ++
 drivers/net/ethernet/ti/netcp_xgbepcsr.c           |  502 +++++
 9 files changed, 5523 insertions(+), 3 deletions(-)
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
-- 
1.7.9.5

