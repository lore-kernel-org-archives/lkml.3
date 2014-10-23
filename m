Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaJWOXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:23:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36063 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbaJWOXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:23:46 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: <linux-pm@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v3 0/5] ARM: keystone: pm: switch to use generic pm domains
Date: Thu, 23 Oct 2014 17:22:57 +0300
Message-ID: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
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

RFC version of patches can be found at [2].

Changes in v3:
 - handling of the case when !CONFIG_PM_RUNTIME has been
   moved in PM clock framework.

Changes in v2:
- minor comments applied and rebased on top of Linux 3.18-rc1.

Links on previous versions:
v2:  https://lkml.org/lkml/2014/10/20/248
v1:  https://lkml.org/lkml/2014/9/29/382

[1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
  https://lkml.org/lkml/2014/4/24/1118

[2] "[RFC PATCH 0/4] ARM: keystone: pm: switch to use generic pm domains"
  https://lkml.org/lkml/2014/9/25/364

CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Kevin Hilman <khilman@linaro.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Geert Uytterhoeven (1):
  PM / clock_ops: Add pm_clk_add_clk()

Grygorii Strashko (4):
  PM / clock_ops: make __pm_clk_enable more generic
  PM / clock_ops: add and enable clocks always if !CONFIG_PM_RUNTIME
  ARM: keystone: pm: switch to use generic pm domains
  ARM: dts: keystone: add generic pm controller node

 .../bindings/power/ti,keystone-powerdomain.txt     |  31 ++++++
 arch/arm/boot/dts/keystone.dtsi                    |   6 ++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 105 +++++++++++++--------
 drivers/base/power/clock_ops.c                     |  83 +++++++++-------
 include/linux/pm_clock.h                           |   8 ++
 6 files changed, 165 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt

-- 
1.9.1

