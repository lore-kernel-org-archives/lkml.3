Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbbAFNrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:47:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43702 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753079AbbAFNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:47:07 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/5] usb: atmel_usba_udc: Rework errata handling
Date: Tue,  6 Jan 2015 14:46:57 +0100
Message-Id: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a set of patches porting existing at91sam9rl erratum handling to
DT and adding new code to handle at91sam9g45/9x5 erratum.
It also adds several compatible strings to differentiate those errata.

These patches should be backported to 3.17 and 3.18 stable releases but
they do not apply cleanly on those stable branches.
I'll send a backport of this series once it is merged in mainline.

Regards,

Boris

Changes since v1:
- cache INT_ENB value to speedup INT_ENB read operations

Boris Brezillon (5):
  usb: atmel_usba_udc: Rework at91sam9rl errata handling
  usb: atmel_usba_udc: Add at91sam9g45 and at91sam9x5 errata handling
  ARM: at91/dt: update udc compatible strings
  usb: atmel_usba_udc: Mask status with enabled irqs
  usb: gadget: atmel_usba: Cache INT_ENB register value

 .../devicetree/bindings/usb/atmel-usb.txt          |   5 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   2 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
 arch/arm/boot/dts/sama5d4.dtsi                     |   2 +-
 drivers/usb/gadget/udc/atmel_usba_udc.c            | 146 +++++++++++++--------
 drivers/usb/gadget/udc/atmel_usba_udc.h            |   9 ++
 7 files changed, 111 insertions(+), 57 deletions(-)

-- 
1.9.1

