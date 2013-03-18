Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3CRKzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:55:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44781 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3CRKy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:54:58 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCH 0/2] omap serial fix.
Date: Mon, 18 Mar 2013 16:24:41 +0530
Message-ID: <1363604081-11169-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch is a rearrangement of a macro "OMAP_MAX_HSUART_PORTS"
to a header file so that it can be used in other file. 
The second patch fixes the wakeup from uart issue while using "no_console_suspend" in the
bootargs.

These patches are developed on 3.8 custom kernel containing omap5 supend/resume support.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>

Sourav Poddar (2):
  driver: serial-omap: move max uart count into generic header file.
  arm: mach-omap2: prevent UART console idle on suspend while using
    "no_console_suspend"

 arch/arm/mach-omap2/omap_device.c         |   36 ++++++++++++++++++++++++++++-
 drivers/tty/serial/omap-serial.c          |    2 -
 include/linux/platform_data/serial-omap.h |    1 +
 3 files changed, 36 insertions(+), 3 deletions(-)

