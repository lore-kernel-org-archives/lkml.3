Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaIOOBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:01:08 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:51132 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaIOOBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:01:05 -0400
X-ASG-Debug-ID: 1410789652-0759e746c032090002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Tony Lindgren <tony@atomide.com>
CC: Frans Klaver <frans.klaver@xsens.com>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/4] omap-serial high-speed fixes/improvements
Date: Mon, 15 Sep 2014 16:00:06 +0200
X-ASG-Orig-Subj: [PATCH v3 0/4] omap-serial high-speed fixes/improvements
Message-ID: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1410789652
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9505
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's version 3 of my fixes for high speed usage of the omap serial driver.
Sebastian's 8250 based implementation doesn't seem to be quite there yet. As
long as that's the case, I'd like to go ahead with improving this series.

v2..v3
  - fix an undefined variable in "prevent division by zero"
  - use IRQ_ONESHOT for the threaded irq in "use threaded interrupt handler"

v1..v2
  - centralize baud_is_mode16's calculation
  - fix/unbreak an uninitialized variable in "use threaded interrupt handler"
  - read has-hw-flow-control property in of_get_uart_port_info

Frans Klaver (4):
  tty: omap-serial: pull out calculation from baud_is_mode16
  tty: omap-serial: prevent division by zero
  tty: omap-serial: use threaded interrupt handler
  tty: omap-serial: support setting of hardware flow control in dts

 .../devicetree/bindings/serial/omap_serial.txt     |  1 +
 drivers/tty/serial/omap-serial.c                   | 64 +++++++++++++++++-----
 2 files changed, 50 insertions(+), 15 deletions(-)

-- 
2.1.0

