Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaFZWnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:43:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38379 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750974AbaFZWnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:43:46 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] ARM: Centralize the access to the SCU register
Date: Fri, 27 Jun 2014 00:43:23 +0200
Message-Id: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Following the feedback I go on the patch "ARM: mvebu: Enable SCU
Speculative linefills to L2 for Armada 375/38x" :
http://thread.gmane.org/gmane.linux.ports.arm.kernel/335961/focus=335993

I take the opportunity of adding new functions in smp_scu.c to
centralize the other access done on the SCU register from C file in
this file.

The first patch is a preliminary clean-up in smp_scu.c.

The second and the third patches add functions to manipulate the SCU
control register.

The forth patch use the new scu_spec_linefills_enable()
function. Enabling SCU Speculative linefills to L2 for Armada 375/38x
was the reason of this series.

The last patch removed a direct access to the SCU register by an
access through the new scu_standby_enable() function. For this one I
have just checked that the kernel can be built using the
imx_v6_v7_defconfig config, but I didn't test it on an imx6 hardware.

Thanks,

Gregory CLEMENT (4):
  ARM: smp_scu: Used defined value instead of literal constant
  ARM: smp_scu: Add the enable speculative linefills operation
  ARM: smp_scu: Add the enable standby operation
  ARM: imx6q: Use the new function scu_standby_enable()

Nadav Haklai (1):
  ARM: mvebu: Enable SCU Speculative linefills to L2 for Armada 375/38x

 arch/arm/include/asm/smp_scu.h |  5 ++++
 arch/arm/kernel/smp_scu.c      | 52 ++++++++++++++++++++++++++++++++++++++----
 arch/arm/mach-imx/platsmp.c    |  7 +-----
 arch/arm/mach-mvebu/board-v7.c |  1 +
 4 files changed, 55 insertions(+), 10 deletions(-)

-- 
1.8.1.2

