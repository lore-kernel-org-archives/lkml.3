Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaFLKcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:32:39 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:51833 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005AbaFLKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:32:34 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/9] Generic earlyconsole for ARC UART Driver
Date: Thu, 12 Jun 2014 16:01:30 +0530
Message-ID: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series switches ARC UART from custom earlyprintk support to generic
earlycon (many thanks to Rob for doing that).

The motivation is to get rid of the early platform code, which in turn
would help consolidate the init code across several ARC platforms.

First 3 patches are general cleanup/refactoring, not necesarily related to
earlycon.

Also the ARC platform change (8/9) is bundled in to keep series bisectable
w/o timing hassles. However it can be dropped if tty maintainers deem so.

Please review.

Thx,
-Vineet

Vineet Gupta (9):
  serial/arc: use uart_console_write() helper
  serial/arc: Refactor by referencing to uart_port where possible
  serial/arc: Remove the workaround for legacy ISS
  serial/arc: Use generic earlycon infrastructure
  serial/arc: remove earlyprintk support and switch to earlycon
  serial/arc: remove last remanants of platform data
  serial/arc: inline the probe helper
  ARC: [arcfpga] RIP early uart platform device stuff
  serial/arc: Add DT based earlycon support

 arch/arc/boot/dts/angel4.dts     |   3 +-
 arch/arc/plat-arcfpga/Kconfig    |   7 -
 arch/arc/plat-arcfpga/platform.c |  97 +-----------
 drivers/tty/serial/Kconfig       |   1 +
 drivers/tty/serial/arc_uart.c    | 329 ++++++++++++++-------------------------
 5 files changed, 123 insertions(+), 314 deletions(-)

-- 
1.8.3.2

