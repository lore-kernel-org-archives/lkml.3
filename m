Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaD3PQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:16:42 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:36447 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbaD3PQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:16:36 -0400
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v5 0/3] ARM: sunxi: Add support for consumer infrared devices
Date: Wed, 30 Apr 2014 21:16:47 +0600
Message-Id: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces Consumer IR(CIR) support for sunxi boards.

This is based on Alexsey Shestacov's work based on the original driver 
supplied by Allwinner.

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>

---
Changes since version 1: 
 - Fix timer memory leaks 
 - Fix race condition when driver unloads while interrupt handler is active
 - Support Cubieboard 2(need testing)

Changes since version 2:
- More reliable keydown events
- Documentation fixes
- Rename registers accurding to A20 user manual
- Remove some includes, order includes alphabetically
- Use BIT macro
- Typo fixes

Changes since version 3:
- Split the patch on smaller parts
- More documentation fixes
- Add clock-names in DT
- Use devm_clk_get function to get the clocks
- Removed gpios property from ir's DT
- Changed compatible from allwinner,sunxi-ir to allwinner,sun7i-a20-ir in DT
- Use spin_lock_irq instead spin_lock_irqsave in interrupt handler
- Add myself in the copyright ;)
- Coding style and indentation fixes

Changes since version 4:
- Try to fix indentation errors by sending patches with git send-mail

Alexander Bersenev (3):
  ARM: sunxi: Add documentation for sunxi consumer infrared devices
  ARM: sunxi: Add driver for sunxi IR controller
  ARM: sunxi: Add IR controller support in DT on A20

 .../devicetree/bindings/media/sunxi-ir.txt         |  23 ++
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |   6 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   6 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  31 +++
 drivers/media/rc/Kconfig                           |  10 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/sunxi-ir.c                        | 303 +++++++++++++++++++++
 7 files changed, 380 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
 create mode 100644 drivers/media/rc/sunxi-ir.c

-- 
1.9.2

