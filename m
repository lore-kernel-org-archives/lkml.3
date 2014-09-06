Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaIFRWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:22:03 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:34528 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFRV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:21:59 -0400
From: Alexey Charkov <alchark@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 0/4] tty: vt8500_serial: Changes for -next
Date: Sat,  6 Sep 2014 21:21:11 +0400
Message-Id: <1410024075-1354-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series introduces a bit of clean-up (reduce magic numbers) and
new features for the VT8500 serial driver.

Firstly, in a new generation of WonderMedia SoC's the UART module
changed slightly, and now requires one more bit to be set in its
line control register to function properly. This is handled in the
first patch by adding a new DT 'compatible' string for the new chips.

Secondly, a couple of ommissions from the initial driver version are
now filled, namely RTS setting (second patch) and correct calculation
of baud rate predivisors, divisors etc. for any given input clock
(third patch). Initial version implicitly assumed input clock to be
always 24MHz and predivisor to be /2 (which holds for current chips,
but doesn't need to hold in general).

Thirdly, polled console functions are now implemented (fourth patch)
to support KGDB over VT8500 UART.

These changes have been tested on a WonderMedia WM8880 netbook (all),
and on a VIA Springboard (WM8950) (all except KGDB).

Greg, could you please merge these for -next, if they look fine?

Thanks a lot,
Alexey

Alexey Charkov (4):
  tty: vt8500_serial: add support for UART in WM8880 chips
  tty: vt8500_serial: add missing support for RTS setting
  tty: vt8500_serial: explicitly calculate base baud rate
  tty: vt8500_serial: add polled console functions

 .../devicetree/bindings/serial/via,vt8500-uart.txt |  17 ---
 .../devicetree/bindings/serial/vt8500-uart.txt     |   3 +-
 drivers/tty/serial/vt8500_serial.c                 | 136 ++++++++++++++++++---
 3 files changed, 118 insertions(+), 38 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/serial/via,vt8500-uart.txt

-- 
2.0.0

