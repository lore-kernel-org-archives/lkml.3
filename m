Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbbAWNJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:09:50 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:53210 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680AbbAWNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:09:48 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <gregkh@linuxfoundation.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <arnd@arndb.de>, <gnomes@lxorguk.ukuu.org.uk>,
        <peter@hurleysoftware.com>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <jslaby@suse.cz>, <heiko@sntech.de>, <jason@lakedaemon.net>,
        <florian.vaussard@epfl.ch>, <andrew@lunn.ch>, <hytszk@gmail.com>,
        <antonynpavlov@gmail.com>, <shawn.guo@linaro.org>,
        <orsonzhai@gmail.com>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>, <lanqing.liu@spreadtrum.com>,
        <zhang.lyra@gmail.com>, <wei.qiao@spreadtrum.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v7 0/2] Add Spreadtrum SoC bindings and serial driver support
Date: Fri, 23 Jan 2015 21:01:04 +0800
Message-ID: <1422018066-24997-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <sprd-serial-v7>
References: <sprd-serial-v7>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com t0ND1PIP052355
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set split the last version, and addressed the review comments from
last version on serial driver code.

Changes from v6:
	- Setted SPRD_TIMEOUT with 256 rather than 2048
	- Used u32 instead of uint32_t
	- Removed inline of handle_lsr_errors which is a single call site function
	- Removed unused parameter of sprd_tx & sprd_rx
	- Used spin_lock_irqsave in sprd_startup() instead of spin_lock
	- Added a check for port->sysrq in sprd_console_write()
	- Used a global counter as a condition of calling uart_{un}register_driver
	- Added pdev->id assignment in probe()
	- Setted port->flags with UPF_BOOT_AUTOCONF instead of ASYNC_BOOT_AUTOCONF

Changes from v5:
	- Used Spreadtrum instead of SPRD in menus
	- Changed TTY name to 'ttyS'
	- Moved uart_register_driver() to probe()
	- Added spinlock as needed
	- Removed register states saving and restoring in suspend() and resume()

Chunyan Zhang (2):
  Documentation: DT: Add bindings for Spreadtrum SoC Platform
  tty/serial: Add Spreadtrum sc9836-uart driver support

 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  799 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 7 files changed, 840 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5

