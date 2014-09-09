Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaIIPcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:32:00 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46747 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaIIPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:31:57 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@linaro.org, matthias.bgg@gmail.com, alan@linux.intel.com,
        varkabhadram@gmail.com, tklauser@distanz.ch, heiko@sntech.de,
        yingjoe.chen@gmail.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v5 0/2] DTS: serial: Add bindings documention for the Mediatek UARTs
Date: Tue,  9 Sep 2014 17:31:41 +0200
Message-Id: <1410276703-5274-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the UART found in Mediatek SoCs.
The chip is a changed version of a 8250 controller.
Especially it introduces a new register called highspeed. The value
in this register has to be set depending on the baudrate. The value
in the register influences the way the divisor has to be calculated.

The patch series is build against linux-next and tested on mt6589. Should
work as well on mt6577 and mt6582.

Thanks,
Matthias

Changes for v5:
- specify all SoC compatible strings in Documentation
- rename clock
- rebase against linux-next

Changes for v4:
- delete owner in platform driver instance
- pass plattform_device to mtk8250_probe_of
- reorganise probe function to error out early
- Fix DTS documentation

Changes for v3:
- use dev_warn instead of pr_warn
- use 8250_core function to update termios

Changes for v2:
- drop 8250_core capability extension for the chip
- encapsulate set_termios in the driver method

---

Matthias Brugger (2):
  tty: serial: 8250: Add Mediatek UART driver
  DTS: serial: Add bindings documention for the Mediatek UARTs

 .../devicetree/bindings/serial/mtk-uart.txt        |  22 ++
 drivers/tty/serial/8250/8250_mtk.c                 | 294 +++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig                    |   6 +
 drivers/tty/serial/8250/Makefile                   |   1 +
 4 files changed, 323 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c

-- 
1.9.1

