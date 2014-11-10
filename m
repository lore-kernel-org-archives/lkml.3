Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaKJPAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:00:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35861 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbaKJO75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:59:57 -0500
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
Subject: [PATCH v4 0/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 10 Nov 2014 16:59:15 +0200
Message-ID: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
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

This series based on top 

Changes in v4:
 - changes for Generic clock manipulation PM callbacks (clock_ops.c) 
   were separated in standalone series [3] and Keystone 2 specific
   patches were rebased on top of it.

Changes in v3:
 - handling of the case when !CONFIG_PM_RUNTIME has been
   moved in PM clock framework.

Changes in v2:
- minor comments applied and rebased on top of Linux 3.18-rc1.

Links on previous versions:
v2:  https://lkml.org/lkml/2014/10/20/248
v1:  https://lkml.org/lkml/2014/9/29/382

RFC version of patches can be found at [2].

[1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
  https://lkml.org/lkml/2014/4/24/1118

[2] "[RFC PATCH 0/4] ARM: keystone: pm: switch to use generic pm domains"
  https://lkml.org/lkml/2014/9/25/364

[3] "[PATCH v4 0/3] PM / clock_ops: add pm_clk_add_clk()"
  https://lkml.org/lkml/2014/11/6/319

CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Kevin Hilman <khilman@linaro.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Grygorii Strashko (2):
  ARM: keystone: pm: switch to use generic pm domains
  ARM: dts: keystone: add generic pm controller node

 .../bindings/power/ti,keystone-powerdomain.txt     |  31 ++++++
 arch/arm/boot/dts/keystone.dtsi                    |   6 ++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 106 ++++++++++++++-------
 4 files changed, 107 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt

-- 
1.9.1

