Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaFHSJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 14:09:08 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48544 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaFHSJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 14:09:05 -0400
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
Subject: [PATCH v9 0/5] ARM: sunxi: Add support for consumer infrared devices
Date: Mon,  9 Jun 2014 00:08:08 +0600
Message-Id: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
X-Mailer: git-send-email 1.9.3
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

Changes since version 5:
- More indentation fixes
- Make patches pass checkpatch with --strict option
- Replaced magic numbers with defines(patch by Priit Laes)
- Fixed oops on loading(patch by Hans de Goede)

Changes since version 6:
- Removed constants from code
- Better errrors handling on loading
- Renamed sunxi-ir.c to sunxi-cir.c
- Changed description of second commit
- Order entries in dts and dtsi by register address
- Code style fixes

Changes since version 7:
- Removed a couple of blank lines in code
- Delay interrupts init until we are ready to handle them
- Increased the reported duration of each pulse by one
- Refactored defines

Changes since version 8:
- Split the DT patch to three
- Code style fixes

Alexander Bersenev (5):
  ARM: sunxi: Add documentation for sunxi consumer infrared devices
  [media] rc: add sunxi-ir driver
  ARM: sunxi: Add pins for IR controller on A20 to dtsi
  ARM: sunxi: Add IR controllers on A20 to dtsi
  ARM: sunxi: Enable IR controller on cubieboard 2 and cubietruck in dts

 .../devicetree/bindings/media/sunxi-ir.txt         |  23 ++
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |   6 +
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   6 +
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  32 +++
 drivers/media/rc/Kconfig                           |  10 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/sunxi-cir.c                       | 318 +++++++++++++++++++++
 7 files changed, 396 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
 create mode 100644 drivers/media/rc/sunxi-cir.c

-- 
1.9.3

