Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbbAZKEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:04:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16387 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbAZKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:04:44 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 0/7] AT91 pm improvements for 3.20
Date: Mon, 26 Jan 2015 18:03:37 +0800
Message-ID: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

This patch set is add pm support for ARMv7 SoCs.
 - Add WFI support for ARMv7.
 - Disable the L1 D-cache and L2 cache before suspending.
 - Get the memory type from the dts file config.
 - Disable the mpddr controller's clock and DDR clock during the suspending.

It is based on the following patch set,
	[PATCH v2 00/12] AT91 pm cleanup for 3.20

Patrice Vilchez (1):
  pm: at91: pm_suspend: MOR register KEY was missing

Wenyou Yang (6):
  pm: at91: achieve the memory controller's type from the dts file.
  pm: at91: pm_suspend: add the WFI support for ARMv7
  ARM: at91: enable the L2 Cache controller
  pm: at91: add disable/enable the L1/L2 cache while suspend/resume
  pm: at91: add achieve the mpddrc peripheral ID and the DDR clock ID
    support
  pm: at91: add disable/enable the mpddrc's clock and DDR clock support

 arch/arm/mach-at91/board-dt-sama5.c |   53 ++++++++
 arch/arm/mach-at91/generic.h        |    7 ++
 arch/arm/mach-at91/pm.c             |   22 ++--
 arch/arm/mach-at91/pm.h             |    8 ++
 arch/arm/mach-at91/pm_suspend.S     |  227 ++++++++++++++++++++++++++++++++++-
 arch/arm/mach-at91/setup.c          |   52 +++++++-
 6 files changed, 356 insertions(+), 13 deletions(-)

-- 
1.7.9.5

