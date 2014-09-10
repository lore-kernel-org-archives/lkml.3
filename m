Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaIJMwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:52:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:59245 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIJMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:52:07 -0400
Message-ID: <54104971.1080501@atmel.com>
Date: Wed, 10 Sep 2014 14:52:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        ARM kernel <arm@kernel.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Wu, Josh" <Josh.wu@atmel.com>, voice <voice.shen@atmel.com>,
        "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Subject: [ANNOUNCE] ARM: at91: removal of board files
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The Atmel ARM-based SoC community (aka AT91) has been working on Device
Tree since early August 2011. I only come back on this long process just
for saying a big thank you to all people involved in this effort which
in the end gives to the AT91 community a cleaner, stronger and more
generic code base.

With the work about to being completed on the LCD controller we have now
a comprehensive support for all AT91 SoC in DT. Some drivers were
converted to DT several years ago, some have just been converted but we
can rely on this technology and stop having to maintain useless code.

So today, it's time for making one of the latest steps of this work: the
*removal* of old-style "board-*.c" and "at91*_devices.c" files in
mach-at91 directory.

A work has been started several months ago (Cf. ARM: at91: DT: switch C
board to DT, on Nov. 2013) but we didn't have much feedback from board
maintainers.
This time, we will simply remove the support for the boards that have
not migrated to the Device Tree by the 3.18-3.19 time frame. To ensure
this does not happen to your board, make sure to:
- rework the patches sent by Jean-Christophe back then
- or send your own .dts file for your board.
All in all it will be easy to build these .dts files both from existing
boards with the same SoC or convert the old board files that could
easily be found in git history.

BTW: Let me recall some simple rules while submitting an AT91 board DT file:
- prefix .dts file name with "at91-"
  (at91-foxg20.dts or at91-sama5d3_xplained.dts for instance)
- DT nodes in address ascending order
- command line without "mem" parameter and as short and generic
  as possible
- sorted inclusion of the .dts file in arch/arm/boot/dts/Makefile
- a vendor used in a DT file must be added in
  Documentation/devicetree/bindings/vendor-prefixes.txt as well
- consider using the dual license approach for your board .dts file:
  GPLv2+ and X11:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/283767.html

Please do not hesitate to contact the AT91 community for any question: I
know that you may have difficulties to switch to this method if you are
not used to kernel development, definitively, we can help.

Best regards,
-- 
Nicolas Ferre
