Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303AbaDQCjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 22:39:20 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:47982 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161041AbaDQCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 22:39:17 -0400
From: Iyappan Subramanian <isubramanian@apm.com>
To: davem@davemloft.net, netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Iyappan Subramanian <isubramanian@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH v3 0/4] net: Add APM X-Gene SoC Ethernet driver support
Date: Wed, 16 Apr 2014 19:39:24 -0700
Message-Id: <1397702368-4846-1-git-send-email-isubramanian@apm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding APM X-Gene SoC Ethernet driver.

v3: Address comments from v2 review
* cleaned up set_desc and get_desc functions
* added dtb mdio node and phy-handle subnode
* renamed dtb phy-mode to phy-connection-type
* added of_phy_connect call to connec to PHY
* added empty line after last local variable declaration
* removed type casting when not required
* removed inline keyword from source files
* removed CONFIG_CPU_BIG_ENDIAN ifdef

v2
* Completely redesigned ethernet driver
* Added support to work with big endian kernel
* Renamed dtb phyid entry to phy_addr
* Changed dtb local-mac-address entry to byte string format
* Renamed dtb eth8clk entry to menetclk

v1
* Initial version

Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
Iyappan Subramanian (4):
  MAINTAINERS: Add entry for APM X-Gene SoC ethernet driver
  Documentation: dts: Add bindings for APM X-Gene SoC ethernet driver
  dts: Add bindings for APM X-Gene SoC ethernet driver
  drivers: net: Add APM X-Gene SoC ethernet driver support.

 .../devicetree/bindings/net/apm-xgene-enet.txt     |   66 ++
 MAINTAINERS                                        |    8 +
 arch/arm64/boot/dts/apm-mustang.dts                |    4 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   27 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/apm/Kconfig                   |    1 +
 drivers/net/ethernet/apm/Makefile                  |    5 +
 drivers/net/ethernet/apm/xgene/Kconfig             |   10 +
 drivers/net/ethernet/apm/xgene/Makefile            |    6 +
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c     |  846 +++++++++++++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.h     |  380 ++++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |  952 ++++++++++++++++++++
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h   |  136 +++
 14 files changed, 2440 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/apm-xgene-enet.txt
 create mode 100644 drivers/net/ethernet/apm/Kconfig
 create mode 100644 drivers/net/ethernet/apm/Makefile
 create mode 100644 drivers/net/ethernet/apm/xgene/Kconfig
 create mode 100644 drivers/net/ethernet/apm/xgene/Makefile
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_hw.h
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_main.c
 create mode 100644 drivers/net/ethernet/apm/xgene/xgene_enet_main.h

-- 
1.7.9.5

