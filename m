Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaIYPG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:06:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42133 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaIYPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:06:23 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>, <linux-pm@vger.kernel.org>,
        <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 0/4]  ARM: keystone: pm: switch to use generic pm domains
Date: Thu, 25 Sep 2014 18:05:33 +0300
Message-ID: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh, Kevin,

This serie is just another try to enable Runtime PM for Keystone 2.
It switches Keystone 2 PM code to use Generic PM domains
instead of PM  clock domains because of the lack of DT support
for the last.


Keystone 2 PM domain should be specified per device for which
Runtime PM has to be enabled and handles the list of functional clocks
to enable/disable device.

Example:
 qmss_domain: qmss_pm_controller {
	compatible = "ti,keystone-pm-controller";
	clocks = <&chipclk13>;
	#power-domain-cells = <0>;
 };

 qmss: qmss@2a40000 {
	compatible = "ti,keystone-navigator-qmss";
	...
	power-domains = <&qmss_domain>;

Thanks for your comments!

PS: patch 1 was reused from [1].
Patch 4 is added to illustrate Keystone 2 PM doamins configuration in DT.

Based on:
- "[PATCH v5 00/11] PM / Domains: Generic OF-based support"
  http://www.spinics.net/lists/devicetree/msg49962.html

Links on related discussion:
[1] "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
  https://lkml.org/lkml/2014/4/24/1118

[2] "[RFC PATCH 0/2] use named clocks list to register clocks for PM clock domain"
  https://lkml.org/lkml/2014/6/12/436

[3] "[RFC PATCH 0/3] PM / clock_ops: allow to specify custom pm_clk_notifier callback"
  https://lkml.org/lkml/2014/7/25/630


Geert Uytterhoeven (1):
  PM / clock_ops: Add pm_clk_add_clk()

Grygorii Strashko (3):
  ARM: keystone: pm: switch to use generic pm domains
  ARM: keystone: pm: remove unused clk pm domain code
  ARM: dts: k2hk-evm: add pm domains for net, qmss and knav_dmas

 .../devicetree/bindings/power/ti,keystone-gpc.txt  |  37 ++++++
 arch/arm/boot/dts/k2hk-evm.dts                     |  31 +++++
 arch/arm/mach-keystone/Kconfig                     |   1 +
 arch/arm/mach-keystone/pm_domain.c                 | 136 +++++++++++++++------
 drivers/base/power/clock_ops.c                     |  41 +++++--
 include/linux/pm_clock.h                           |   8 ++
 6 files changed, 206 insertions(+), 48 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/ti,keystone-gpc.txt

-- 
1.9.1

