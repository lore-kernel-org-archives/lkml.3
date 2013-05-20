Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3ETJGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:06:15 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:15767
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab3ETJGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:06:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <grant.likely@linaro.org>
CC: <rob.herring@calxeda.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 0/6] ARM: imx6q{dl}: add the WEIM driver
Date: Mon, 20 May 2013 16:48:56 +0800
Message-ID: <1369039742-10893-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a new driver for WEIM in the imx6q{dl}-sabreauto boards.

The WEIM(Wireless External Interface Module) works like a bus.
You can attach many different devices on it, such as NOR, onenand.

In the case of i.MX6q-sabreauto, only the NOR is connected to WEIM.

Huang Shijie (6):
  drivers: bus: add a new driver for WEIM
  ARM: dts: imx6q{dl}: fix the pin conflict between SPI and WEIM
  ARM: dts: imx6qdl: add more information for WEIM
  ARM: dts: imx6q: add pinctrl for WEIM NOR
  ARM: dts: imx6ql: add a pinctrl for WEIM NOR
  ARM: dts: imx6qdl: enable the WEIM NOR

 Documentation/devicetree/bindings/bus/imx-weim.txt |   69 +++++++++
 arch/arm/boot/dts/imx6dl-sabreauto.dts             |    9 +-
 arch/arm/boot/dts/imx6dl.dtsi                      |   57 ++++++++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |    9 +-
 arch/arm/boot/dts/imx6q.dtsi                       |   58 ++++++++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |   23 +++-
 arch/arm/boot/dts/imx6qdl.dtsi                     |    4 +-
 drivers/bus/Kconfig                                |    9 ++
 drivers/bus/Makefile                               |    1 +
 drivers/bus/imx-weim.c                             |  145 ++++++++++++++++++++
 10 files changed, 380 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/imx-weim.txt
 create mode 100644 drivers/bus/imx-weim.c


