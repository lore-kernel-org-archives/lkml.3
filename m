Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaHSMPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:15:01 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:51020 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHSMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:14:56 -0400
X-ASG-Debug-ID: 1408450494-0759e7416b4763fb0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Felipe Balbi <balbi@ti.com>
CC: Frans Klaver <frans.klaver@xsens.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Frans Klaver <fransklaver@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCHv2 0/4] omap-serial high-speed fixes/improvements
Date: Tue, 19 Aug 2014 14:14:44 +0200
X-ASG-Orig-Subj: [RFC PATCHv2 0/4] omap-serial high-speed fixes/improvements
Message-ID: <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.49]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1408450494
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.8612
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's version 2 of the patches that should improve the behavior of the omap
serial port at high baud and data rates.

Differences with regard to v1 are:
  - centralize baud_is_mode16's calculation
  - fix/unbreak an uninitialized variable in "use threaded interrupt handler"
  - read has-hw-flow-control property in of_get_uart_port_info

Frans Klaver (4):
  tty: omap-serial: pull out calculation from baud_is_mode16
  tty: omap-serial: prevent division by zero
  tty: omap-serial: use threaded interrupt handler
  tty: omap-serial: support setting of hardware flow control in dts

 .../devicetree/bindings/serial/omap_serial.txt     |  1 +
 drivers/tty/serial/omap-serial.c                   | 65 +++++++++++++++++-----
 2 files changed, 51 insertions(+), 15 deletions(-)

-- 
1.9.3

