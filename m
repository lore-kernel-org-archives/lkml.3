Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaLJDyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:54:52 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64900 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaLJDyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:54:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52847348"
From: Ray Jui <rjui@broadcom.com>
To: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v3 0/3] Add I2C support to Broadcom iProc
Date: Tue, 9 Dec 2014 19:57:09 -0800
Message-ID: <1418183832-24793-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the initial I2C support for Broadcom iProc family of
SoCs.

The iProc I2C controller has separate internal TX and RX FIFOs, each has a
size of 64 bytes. The iProc I2C controller supports two bus speeds including
standard mode (100 kHz) and fast mode (400 kHz)

Changes from v2:
 - Have the I2C driver default to y so it does not need to be selected from
   ARCH_BCM_IPROC. This also helps to get rid of one patch. The driver still
   depends on ARCH_BCM_IPROC
 - Get rid of redundant check on resource returned by platform_get_resource

Changes from v1:
 - Fix function argument parenthesis
 - Get rid of redundant driver owner field

Ray Jui (3):
  i2c: iProc: define Broadcom iProc I2C binding
  i2c: iproc: Add Broadcom iProc I2C Driver
  ARM: dts: add I2C device nodes for Broadcom Cygnus

 .../devicetree/bindings/i2c/brcm,iproc-i2c.txt     |   37 ++
 arch/arm/boot/dts/bcm-cygnus.dtsi                  |   20 +
 drivers/i2c/busses/Kconfig                         |   10 +
 drivers/i2c/busses/Makefile                        |    1 +
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  500 ++++++++++++++++++++
 5 files changed, 568 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/brcm,iproc-i2c.txt
 create mode 100644 drivers/i2c/busses/i2c-bcm-iproc.c

-- 
1.7.9.5

