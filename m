Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbbAPAKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:10:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57729 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbbAPAKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:10:12 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <davem@davemloft.net>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet driver support
Date: Thu, 15 Jan 2015 19:10:03 -0500
Message-ID: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Network Coprocessor (NetCP) is a hardware accelerator that processes
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

version history
---------------
v7->v8

 - Reworked comments against v7, related to checker warning.
 - Patch 2/4 that has all of the driver code in v7 is now split into 3
   patches based on functionality so that we have 3 smaller patches
   review instead of a big patch.
 - Patch for MAINTAINER is merged to 2/4 along with netcp core driver
 - Separate patch (3/4) for 1G and  (4/4) for 10G
 - Removed big endian support for initial version (will add it later)

v6->v7
 - Fixed some minor documentation error and also modified the netcp driver
   to fix the set* functions to include correct le/be macros.

v5->v6
 - updated version after incorporating comments [6] from David Miller,
   David Laight & Geert Uytterhoeven on v5. I would like get this in
   for v3.19 merge window if the latest version is acceptable.

v4->v5
 - Sorry to spin v5 quickly but I missed few check-patch warnings which
   were pointed by Joe Perches(thanks). I folded his changes [5] along with
   few more check-patch warning fixes. I would like get this in for v3.18
   merge window if David is happy with this version.

v3->v4
 - Couple of fixes in in error path as pointed [4] out by David. Rest of
   the patches are unchanged from v3. 

v2->v3
 - Update v3 after incorporating Jamal and David Miller's comment/suggestion
   from earlier versions [1] [2].  After per the discussion here [3], the
   controversial custom exports have been dropped now. And for future
   future offload support additions, we will plug into generic frameworks
   as an when they are available.

Murali Karicheri (2):
  Documentation: dt: net: Add binding doc for Keystone NetCP ethernet
    driver
  net: netcp: Add Keystone NetCP core ethernet driver

Wingman Kwok (2):
  net: netcp: Add Keystone NetCP GbE driver
  net: netcp: Enhance GBE driver to support 10G Ethernet

 Cc: David Miller <davem@davemloft.net>
 Cc: Rob Herring <robh+dt@kernel.org>
 Cc: Grant Likely <grant.likely@linaro.org>
 Cc: Santosh Shilimkar <santosh.shilimkar@kernel.org>
 Cc: Pawel Moll <pawel.moll@arm.com>
 Cc: Mark Rutland <mark.rutland@arm.com>
 Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
 Cc: Kumar Gala <galak@codeaurora.org>
    
 .../devicetree/bindings/net/keystone-netcp.txt     |  197 ++
 MAINTAINERS                                        |    7 +
 drivers/net/ethernet/ti/Kconfig                    |   11 +
 drivers/net/ethernet/ti/Makefile                   |    4 +
 drivers/net/ethernet/ti/netcp.h                    |  229 +++
 drivers/net/ethernet/ti/netcp_core.c               | 2141 +++++++++++++++++++
 drivers/net/ethernet/ti/netcp_ethss.c              | 2156 ++++++++++++++++++++
 drivers/net/ethernet/ti/netcp_sgmii.c              |  131 ++
 drivers/net/ethernet/ti/netcp_xgbepcsr.c           |  501 +++++
 9 files changed, 5377 insertions(+)
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

