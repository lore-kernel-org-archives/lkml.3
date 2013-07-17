Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab3GQQtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:49:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40598 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab3GQQqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:46:14 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/9] ARM: dts: omap5-uevm: fixup wrong regulator configuration
Date: Wed, 17 Jul 2013 11:45:29 -0500
Message-ID: <1374079538-19548-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to wrong older revision of documentation used as reference, we
seem to have a bunch of LDOs wrongly configured on OMAP5 uEVM. This
series is based power tree on production board 750-2628-XXX platform.
Unfortunately, the wrong voltages may be detrimental to OMAP5 as they
supply hardware blocks at voltages that are out of specification.

Also available at:
based on v3.11-rc1 tag
http link: https://github.com/nmenon/linux-2.6-playground/commits/push/omap5-palmas-fixes
git link: git://github.com/nmenon/linux-2.6-playground.git
branch: push/omap5-palmas-fixes

Tested with https://patchwork.kernel.org/patch/2545061/
 + https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux.git/log/?h=for_3.11/out_of_tree/omap5_clk_data
Test result: http://pastebin.com/YqASYkXG

Relevant documentation:
- OMAP5 uEVM documentation: https://www.svtronics.com/omap/omap54xx?product_id=33
- OMAP5432 Data Manual: http://www.ti.com/product/OMAP5432
- TWL6037 / OTP information: Currently available only under NDA

Nishanth Menon (9):
  ARM: dts: omap5-uevm: document regulator signals used on the actual
    board
  ARM: dts: omap5-uevm: update SMPS9 settings
  ARM: dts: omap5-uevm: update and disable unused regulators LDO[28]
  ARM: dts: omap5-uevm: update LDO1 voltage to 1.5V and settings
  ARM: dts: omap5-uevm: update LDO3 voltage to 1.5V and settings
  ARM: dts: omap5-uevm: update LDO4 voltage to 1.5V and settings
  ARM: dts: omap5-uevm: update LDO6 voltage to 1.2V
  ARM: dts: omap5-uevm: update LDO7 voltage to 2V and settings
  ARM: dts: omap5-uevm: update SDCARD LDO9 and resource REGEN3

 arch/arm/boot/dts/omap5-uevm.dts |   78 ++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 29 deletions(-)

-- 
1.7.9.5

Regards,
Nishanth Menon
