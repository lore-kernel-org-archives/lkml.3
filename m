Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbaFZLZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:25:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbaFZLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:25:07 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-99-53ac030e6c43
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Daniel Drake <drake@endlessm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 0/3] Deterministic UART numbering on Samsung SoCs
Date: Thu, 26 Jun 2014 13:24:32 +0200
Message-id: <1403781875-5425-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xy7p8zGuCDZ7uMLKYf+Qcq8Wj+Y+Z
	LZoXr2ez+Px7F6tF74KrbBabHl9jtbi8aw6bxYzz+5gszizuZbe4fZnXYu2Ru+wWS69fZLJo
	3XuE3WL9jNcsFqt2/WF04PdYM28No0dLcw+bx6LvWR47Z91l99i0qpPNY//cNewem5fUe/Rt
	WcXocWbBEXaPz5vkAriiuGxSUnMyy1KL9O0SuDJOne1jK5jNU9Hz4T5zA+NLji5GTg4JAROJ
	3gm7WCFsMYkL99azdTFycQgJLGWUOPH7LCOE08ck8e3DfLAqNgE1ic8Nj9hAbBEBVYnPbQvY
	QYqYBSazSOzq/MMOkhAWcJTY8qsNrIgFqOjYd4gVvEDxSYd+Qq2Tk+jd9oZ5AiP3AkaGVYyi
	qaXJBcVJ6bmGesWJucWleel6yfm5mxghQfplB+PiY1aHGAU4GJV4eCXmrg4WYk0sK67MPcQo
	wcGsJMIr8hsoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbFKQf/mpOgt5/aYbUrP/umaLr9L85zh
	oqDoU7fC2bMl/695qX5yc4rS89gTOd+zSz/zLHt56sauOEH5b7Y+Mx7kzZ3XeTbe+AR7wMF1
	zql6O2xnc9eVrf76ZveLST9mtj7cbyJ0SMDB6e+FQ4F89/0Pv/i/j/PQjtXKbJHXrIL3P7Xv
	3GQ2/RW3EktxRqKhFnNRcSIArdWTPjACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current Samsung UART driver relies on probe order of particular
samsung-uart instances, which makes it impossible to get proper
initialization of ports when not all ports are available on board,
not even saying of deterministic device naming.

This series intends to fix this situation by adding support to parse
aliases from device tree and use them to assign instance IDs to
particular port instances.

Tested on Exynos4412-based Trats2 board:
 1) without patch 3/3 adding aliases,
 2) with patch 3/3 with all UART ports enabled,
 3) with patch 3/3 with selected UART ports disabled.

Tomasz Figa (3):
  Documentation: devicetree: Update samsung UART bindings
  serial: samsung: Consider DT alias when probing ports
  ARM: dts: SAMSUNG: Add aliases of UART nodes

 .../devicetree/bindings/serial/samsung_uart.txt    | 52 +++++++++++++++++++---
 arch/arm/boot/dts/exynos3250.dtsi                  |  2 +
 arch/arm/boot/dts/exynos4.dtsi                     | 12 +++--
 arch/arm/boot/dts/exynos5.dtsi                     | 15 +++++--
 arch/arm/boot/dts/exynos5260.dtsi                  |  4 ++
 arch/arm/boot/dts/exynos5410.dtsi                  |  6 +++
 arch/arm/boot/dts/exynos5440.dtsi                  |  6 ++-
 arch/arm/boot/dts/s3c2416.dtsi                     |  6 ++-
 arch/arm/boot/dts/s3c24xx.dtsi                     |  9 ++--
 arch/arm/boot/dts/s3c64xx.dtsi                     |  4 ++
 drivers/tty/serial/samsung.c                       | 13 ++++--
 11 files changed, 106 insertions(+), 23 deletions(-)

-- 
1.9.3

