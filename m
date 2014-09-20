Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaITNbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 09:31:39 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:54328 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaITNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 09:31:36 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: netdev@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Carlo Caione <carlo@caione.org>,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: net: stmmac glue layer for Amlogic Meson SoCs
Date: Sat, 20 Sep 2014 15:29:15 +0200
Message-Id: <1411219757-9201-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the Ethernet controller available in Amlogic Meson6 and Meson8 SoCs is
a Synopsys DesignWare MAC IP core, already supported by the stmmac
driver.

These patches add a glue layer to the driver for the platform-specific
settings required by the Amlogic variant.

This has been tested on a Amlogic S802 device with the initial Meson
support submitted by Carlo Caione [1].

[1] http://lwn.net/Articles/612000/

Beniamino Galvani (2):
  net: stmmac: add Amlogic Meson glue layer
  net: stmmac: meson: document device tree bindings

 .../devicetree/bindings/net/meson-dwmac.txt        | 25 ++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig        | 10 ++++
 drivers/net/ethernet/stmicro/stmmac/Makefile       |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c  | 67 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  3 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  3 +
 6 files changed, 109 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c

-- 
1.9.1

