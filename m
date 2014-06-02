Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaFBJVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:21:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38020 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753006AbaFBJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:21:09 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: Berlin: SMP support
Date: Mon,  2 Jun 2014 11:21:01 +0200
Message-Id: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the SMP support for Marvell Berlin BG2 and BG2Q.

This implementation takes advantage of the reset exception register and
the software reset address register to make the CPUs execute the Berlin
secondary startup when being being reseted. This has the advantage of
not using the pen lock mechanism.

Antoine Ténart (5):
  ARM: berlin: add SMP support
  Documentation: bindings: document the Marvell Berlin enable-method
  Documentation: bindings: add the Berlin CPU control doc
  ARM: dts: berlin: add SMP related nodes and properties for BG2
  ARM: dts: berlin: add SMP related nodes and properties for BG2Q

 Documentation/devicetree/bindings/arm/cpus.txt     |  1 +
 .../devicetree/bindings/arm/marvell,berlin.txt     | 16 ++++
 arch/arm/boot/dts/berlin2.dtsi                     | 11 +++
 arch/arm/boot/dts/berlin2q.dtsi                    | 11 +++
 arch/arm/mach-berlin/Kconfig                       |  3 +
 arch/arm/mach-berlin/Makefile                      |  3 +-
 arch/arm/mach-berlin/headsmp.S                     | 30 +++++++
 arch/arm/mach-berlin/platsmp.c                     | 99 ++++++++++++++++++++++
 8 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-berlin/headsmp.S
 create mode 100644 arch/arm/mach-berlin/platsmp.c

-- 
1.9.1

