Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaFXIZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:25:49 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:34287 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaFXIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:25:44 -0400
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
Subject: [PATCH v2 REBASED 00/10] Generic earlyconsole for ARC UART Driver
Date: Tue, 24 Jun 2014 13:55:05 +0530
Message-ID: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is slightly modified repost of series posted last week
http://www.spinics.net/lists/linux-serial/msg12884.html

This series switches ARC UART from custom earlyprintk support to generic
earlycon (many thanks to Rob for doing that). And also build on Grant's recent
work for using DT stdout-path as default console.

The motivation is to get rid of the early platform code, which in turn
would help consolidate the init code across several ARC platforms.

First 3 patches are general cleanup/refactoring, not necesarily related to
earlycon.

v2 <- v1
--------
* Rebased on linux-next: 20140623
* Patch 9 split into 9 and 10 for driver/platform changes
* Patch 10 also uses the DT stdout-path so no need for console=


Thx,
-Vineet


Vineet Gupta (10):
  serial/arc: use uart_console_write() helper
  serial/arc: Refactor by referencing to uart_port where possible
  serial/arc: Remove the workaround for legacy ISS
  serial/arc: Use generic earlycon infrastructure
  serial/arc: remove earlyprintk support and switch to earlycon
  serial/arc: remove last remanants of platform data
  serial/arc: inline the probe helper
  ARC: [arcfpga] RIP early uart platform device stuff
  serial/arc: Enable DT based earlycon
  ARC: [arcfpga] stdout-path now suffices for earlycon/console

 arch/arc/boot/dts/angel4.dts     |   3 +-
 arch/arc/plat-arcfpga/Kconfig    |   7 -
 arch/arc/plat-arcfpga/platform.c |  97 +-----------
 drivers/tty/serial/Kconfig       |   1 +
 drivers/tty/serial/arc_uart.c    | 329 ++++++++++++++-------------------------
 5 files changed, 123 insertions(+), 314 deletions(-)

-- 
1.8.3.2

