Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaI2OjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:39:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57094 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbaI2OjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:39:00 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v1 0/4] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 29 Sep 2014 17:38:15 +0300
Message-ID: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh, Kevin,

This series switches Keystone 2 PM code to use Generic PM domains
instead of PM clock domains because of the lack of DT support
for the last.
It will finally allow to enable Runtime PM for Keystone 2.

Patch 1 was reused from [1].
Patch 4 is added to illustrate Keystone 2 PM domains configuration in DT.

RFC version of patches can be found at [2].

[1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
  https://lkml.org/lkml/2014/4/24/1118

[2] "[RFC PATCH 0/4] ARM: keystone: pm: switch to use generic pm domains"
  https://lkml.org/lkml/2014/9/25/364

Geert Uytterhoeven (1):
  PM / clock_ops: Add pm_clk_add_clk()

Grygorii Strashko (3):
  ARM: keystone: pm: switch to use generic pm domains
  ARM: dts: keystone: add generic pm controller node
  ARM: dts: k2hk-evm: attach net, qmss and knav_dmas to keystone-gpc

 .../devicetree/bindings/power/ti,keystone-gpc.txt  |  31 ++++++
 arch/arm/boot/dts/k2hk-evm.dts                     |   7 ++
 arch/arm/boot/dts/keystone.dtsi                    |   6 ++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 115 ++++++++++++++-------
 drivers/base/power/clock_ops.c                     |  41 ++++++--
 include/linux/pm_clock.h                           |   8 ++
 7 files changed, 162 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-gpc.txt

-- 
1.9.1

