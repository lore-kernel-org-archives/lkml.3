Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3BFD7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:59:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42046 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3BFD7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:59:41 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <hs@denx.de>, <mporter@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <mchehab@redhat.com>, <vaibhav.bedia@ti.com>, <b-cousson@ti.com>,
        <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <anilkumar.v@ti.com>
Subject: [PATCH V2 0/2] ARM: davinci: da850: add wdt DT node
Date: Wed, 6 Feb 2013 09:30:02 +0530
Message-ID: <1360123204-9978-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add wdt DT node and OF_DEV_AUXDATA for wdt driver in
da850 board dt file to use wdt clock.

This is tested on da850 EVM.

Test Procedure:

$watchdog -F /dev/watchdog (Device should not reboot)
 After wdt heartbeat timeout(DEFAULT_HEARTBEAT is 60 sec)
$ctr + c   (Device should reboot after heartbeat timeout)

Changes since V1:

 - Rebase changes on top of v3.8-rc6.
 - Make single patch for wdt DT node and its OF_DEV_AUXDATA entry changes.
 - Fix wdt to machine restart with DT.

Kumar, Anil (2):
  ARM: davinci: da850: add wdt DT node
  ARM: davinci: restart: fix wdt to machine restart with DT

 arch/arm/boot/dts/da850-evm.dts            |    3 +++
 arch/arm/boot/dts/da850.dtsi               |    5 +++++
 arch/arm/mach-davinci/da8xx-dt.c           |    8 +++++++-
 arch/arm/mach-davinci/devices-da8xx.c      |   14 ++++++++++++--
 arch/arm/mach-davinci/include/mach/da8xx.h |    1 -
 5 files changed, 27 insertions(+), 4 deletions(-)

-- 
1.7.4.1

