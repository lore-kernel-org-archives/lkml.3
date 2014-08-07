Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaHGGv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:51:59 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64749 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaHGGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:51:56 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, matthias.bgg@gmail.com, alan@linux.intel.com,
        varkabhadram@gmail.com, heiko@sntech.de, yingjoe.chen@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v2 0/2] tty: serial: Add mediatek UART driver
Date: Thu,  7 Aug 2014 08:51:30 +0200
Message-Id: <1407394292-26317-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the UART found in Mediatek SoCs.
The chip is a changed version of a 8250 controller.
Especially it introduces a new register called highspeed. The value
in this register has to be set depending on the baudrate. The value
in the register influences the way the divisor has to be calculated.

The patch series is build against v3.16-rc1 and tested on mt6589. Should
work as well on mt6577 and mt6582.

Thanks,
Matthias

Changes for v2:
- drop 8250_core capability extension for the chip
- encapsulate set_termios in the driver method

Matthias Brugger (2):
  tty: serial: 8250: Add Mediatek UART driver
  DTS: serial: Add bindings documention for the Mediatek UARTs

 .../devicetree/bindings/serial/mtk-uart.txt        |   19 ++
 drivers/tty/serial/8250/8250_mtk.c                 |  302 ++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig                    |    7 +
 drivers/tty/serial/8250/Makefile                   |    1 +
 4 files changed, 329 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c

-- 
1.7.9.5

