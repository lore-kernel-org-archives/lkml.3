Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3H0Anw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:43:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:54341 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3H0Anv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:43:51 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: boris brezillon <b.brezillon@overkiz.com>
CC: Wim Van Sebroeck <wim@iguana.be>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 0/4] watchdog: at91sam9_wdt: handle already
 configured wdt
Thread-Topic: [PATCH v2 0/4] watchdog: at91sam9_wdt: handle already
 configured wdt
Thread-Index: AQHOblDd0lhPPpArn0i0gCiobRbkXJmnXMUAgAFDIaA=
Date: Tue, 27 Aug 2013 00:43:45 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172E328AD@penmbx02>
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com>
 <521B5754.2070603@overkiz.com>
In-Reply-To: <521B5754.2070603@overkiz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7R0hvJY025649



> -----Original Message-----
> From: boris brezillon [mailto:b.brezillon@overkiz.com]
> Sent: 2013Äê8ÔÂ26ÈÕ 21:26
> To: Boris BREZILLON; Yang, Wenyou
> Cc: Wim Van Sebroeck; Ferre, Nicolas; Jean-Christophe PLAGNIOL-VILLARD;
> Desroches, Ludovic; linux-watchdog@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v2 0/4] watchdog: at91sam9_wdt: handle already
> configured wdt
> 
> Hello Yang,
> 
> Did you test/review this series ?
> 
> If you did, could you add your Acked, Reviewed and/or Tested-by.
> I'd really like to get this series merged to mainline.
> 
> Thanks.
> 
> Best Regards,
> Boris
> 
> On 21/06/2013 09:19, Boris BREZILLON wrote:
> > Hello,
> >
> > This patch series is a porposal to enhance the sam9 watchdog timer support.
> >
> > The at91sam9 watchdog timer can only be configured once, and the current
> > implementation tries to configure it in a static way:
> > - 2 seconds timeout
> > - wdt restart every 500ms
> >
> > If the timer has already been configured with different values, it returns an
> > error and do not create any watchdog device.
> >
> > This is not critical if the watchdog is disabled, but if it has been enabled
> > with different timeout values it will lead to a SoC reset.
> >
> > This patch series tries to address this issue by adapting the heartbeat value
> > according the WDT timer config:
> > - it first tries to configure the timer as requested.
> > - if it fails it fallbacks to the current config, adapting its heartbeat timer
> > to the needs
> >
> > This patch series also move to a dynamically allocated at91wdt device instead
> > of the static instance. I'm not sure this is the best solution, so please tell
> > me if you prefer to keep static instance of watchdog.
> >
> > It adds a new at91 wdt type: software. This new type make use of the at91
> wdt
> > interrupt to trigger a software reboot.
> >
> > Finally it adds several properties to the device tree bindings.
> >
> > Best Regards,
> > Boris
> >
> > Change since v1:
> >   - fix typo in documentaion
> >   - fix irq dt definition for sama5d3 SoC
> >
> > Boris BREZILLON (4):
> >    watchdog: at91sam9_wdt: better watchdog support
> >    watchdog: at91sam9_wdt: update device tree doc
> >    ARM: at91/dt: add sam9 watchdog default options to SoCs
> >    ARM: at91/dt: add watchdog properties to kizbox board
> >
> >   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 +-
> >   arch/arm/boot/dts/at91sam9260.dtsi                 |    5 +
> >   arch/arm/boot/dts/at91sam9263.dtsi                 |    5 +
> >   arch/arm/boot/dts/at91sam9g45.dtsi                 |    5 +
> >   arch/arm/boot/dts/at91sam9n12.dtsi                 |    5 +
> >   arch/arm/boot/dts/at91sam9x5.dtsi                  |    5 +
> >   arch/arm/boot/dts/kizbox.dts                       |    6 +
> >   arch/arm/boot/dts/sama5d3.dtsi                     |    5 +
> >   drivers/watchdog/at91sam9_wdt.c                    |  319
> +++++++++++++++-----
> >   9 files changed, 300 insertions(+), 85 deletions(-)
> >

Tested on sama5d34ek, at91sam9g25ek, linux-next_20130620

Tested-by Wenyou Yang <Wenyou.yang at atmel.com>


Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
