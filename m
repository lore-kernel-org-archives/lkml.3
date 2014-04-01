Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaDAF3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:29:43 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:42446
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbaDAF3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:29:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz8275dh1de097h186068hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux@roeck-us.net>, <wim@iguana.be>, <shawn.guo@linaro.org>,
        <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 0/2] imx2-wdt: Add regmap-mmio support
Date: Tue, 1 Apr 2014 12:46:36 +0800
Message-ID: <1396327598-28535-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patches are preparing for Vybird, LS1 and LS2. And on LS1 the IP will
in BE mode.

And this has been test on Vybird.

This patch series is based the following regmap patches:

1, https://patchwork.kernel.org/patch/3896321/   ===> <applied>
   regmap: mmio: add regmap_mmio_{regsize, count}_check. 
   https://patchwork.kernel.org/patch/3896331/   ===> <applied>
   regmap: mmio: Add support for 1/2/8 bytes wide register address.
   https://patchwork.kernel.org/patch/3901021/   ===> <applied>
   regmap: mmio: Add regmap_mmio_regbits_check.


2, The above three and this one are a must.
   https://patchwork.kernel.org/patch/3912671/   ===> <pending>
   regmap: mmio: Fix the bug of 'offset' value parsing.


3, The following ones are not a must, but will make the IMX2
   watchdog driver much simplifier and easy to use.
   https://patchwork.kernel.org/patch/3912401/   ===> <pending>
   regmap: implement LE formatting/parsing for 16/32-bit values.
   https://patchwork.kernel.org/patch/3912751/   ===> <pending>
   regmap: add DT endianness binding support.
   https://patchwork.kernel.org/patch/3912741/   ===> <pending>
   regmap: Add the DT binding documentation for endianness


The above all regmap patches have been test using SAI(32-bit
regmap-mmio), SGTL5000(codec 16-bit regmap-i2c) and IMX2 Watchdog
(16-bit regmap-mmio).


Changes in V3:
- convert to use regmap-mmio API.

Changes in V2:
- Add the detail information in the commit comment.
- 'big-endians' --> 'big-endian'.



Xiubo Li (2):
  watchdog: imx2_wdt: Sort the header files alphabetically
  watchdog: imx2_wdt: convert to use regmap API.

 drivers/watchdog/imx2_wdt.c | 62 +++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

-- 
1.8.4


