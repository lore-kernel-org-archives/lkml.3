Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaCDSNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:13:51 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60386 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaCDSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:13:49 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 0/6] tty: xuartps renaming
Date: Tue,  4 Mar 2014 09:17:23 -0800
Message-Id: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series appears a little messy.
The UART controller in Zynq is Cadence vendor IP. Hence, naming and
identifying this properly would facilitate usage of this driver by other
implementers of this IP. Though, this might sound nice, there are some
details about this series, I am not sure whether they are acceptable:

 - the device node name: It currently is 'ttyPS'. I don't know if there
   are any rules regarding this and whether this should be changed or
   not.
 - the UART port #define in include/uapi/linux/serial_core.h is changed
 - the series does not cleanly migrate Zynq (which is the only user of
   this driver) to the new driver. There is broken UART between the
   patches 'tty: Rename xilinx_uart -> cadence_uart' and 'ARM: zynq: DT:
   Migrate UART to Cadence binding'. This is mostly due to a change of
   the clock names which are used in the DT binding. It might be
   possible to make the new and legacy names work, but it would look
   rather ugly and since this should affect Zynq only, I hope to get
   away with this.

I keep the CC list for the RFC a little reduced, in particular I leave
out the OF people. I think the fundamental questions are in the tty
field and probably ARM. The binding should not be a major problem since
it is essentially used already - it's just missing documentation.

   	Thanks,
	Sören

Soren Brinkmann (6):
  tty: xemacps: Clean up
  tty: xemacps: Print warning in clock notifier
  tty: Rename xilinx_uart -> cadence_uart
  tty: cadence: Document DT binding
  ARM: zynq: DT: Migrate UART to Cadence binding
  ARM: multi_v7_defconfig: Adopt to UART driver renaming

 .../devicetree/bindings/serial/cadence_uart.txt    |   20 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |    8 +-
 arch/arm/configs/multi_v7_defconfig                |    4 +-
 drivers/tty/serial/Kconfig                         |   15 +-
 drivers/tty/serial/Makefile                        |    2 +-
 drivers/tty/serial/cadence_uart.c                  | 1457 +++++++++++++++++++
 drivers/tty/serial/xilinx_uartps.c                 | 1524 --------------------
 include/uapi/linux/serial_core.h                   |    4 +-
 8 files changed, 1494 insertions(+), 1540 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/cadence_uart.txt
 create mode 100644 drivers/tty/serial/cadence_uart.c
 delete mode 100644 drivers/tty/serial/xilinx_uartps.c

-- 
1.9.0.1.g4196000

