Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaJQI0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 04:26:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46185 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753900AbaJQI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 04:26:43 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 0/3] Remove mach/atmel-mci.h
Date: Fri, 17 Oct 2014 10:26:35 +0200
Message-Id: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes the uses of mach/atmel-mci.h and the files themselves.
The final goal is to be able to switch AT91 to multiplatform.

The first patch introduces a new platform_data file and uses it in the driver.
The two following patches remove the uses of mach/atmel-mci.h and the header
itself from avR32 and ARM/at91.

Changes in v2:
 - include back linux/atmel-mci.h and really remove mach/atmel-mci.h in at91sam9g45_devices.c

Alexandre Belloni (3):
  mmc: atmel-mci: move mache header to platform_data
  ARM: at91: remove mach/atmel-mci.h
  avr32: remove mach/atmel-mci.h

 arch/arm/mach-at91/at91sam9g45_devices.c        |  2 +-
 arch/arm/mach-at91/include/mach/atmel-mci.h     | 17 -----------------
 arch/avr32/mach-at32ap/at32ap700x.c             |  2 +-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h | 17 -----------------
 drivers/mmc/host/atmel-mci.c                    |  2 +-
 include/linux/platform_data/mmc-atmel-mci.h     | 22 ++++++++++++++++++++++
 6 files changed, 25 insertions(+), 37 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
 delete mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h
 create mode 100644 include/linux/platform_data/mmc-atmel-mci.h

-- 
1.9.1

