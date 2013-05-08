Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3EHJnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:43:37 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:37043 "HELO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751950Ab3EHJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:43:35 -0400
From: joem <joem@martindale-electric.co.uk>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
CC: David Goodenough <david.goodenough@btconnect.com>,
        "debian-arm@lists.debian.org" <debian-arm@lists.debian.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Arm-netbook] device tree not the answer in the ARM world [was:
 Re: running Debian on a Cubieboard]
Thread-Topic: [Arm-netbook] device tree not the answer in the ARM world
 [was: Re: running Debian on a Cubieboard]
Thread-Index: AQHOSYw01f0IEEHWWUOGwhgLHUMbD5j6/P+A
Date: Wed, 8 May 2013 09:43:02 +0000
Message-ID: <1368006181.5589.30.camel@jm-desktop>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
In-Reply-To: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
Reply-To: joem <joem@martindale-electric.co.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [81.149.149.147]
Content-Type: text/plain; charset="utf-8"
Content-ID: <320CB8DCD07D654EBD257463DA6D07C2@swifthost.local>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r489hgq5008022

On Sun, 2013-05-05 at 13:27 +0100, Luke Kenneth Casson Leighton wrote:

> when i say "completely and utterly different", i am not just talking
> about the processor, i am not just talking about the GPIO, or even the
> buses: i'm talking about the sensors, the power-up mechanisms, the
> startup procedures - everything.  one device uses GPIO pin 32 for
> powering up and resetting a USB hub peripheral, yet for another device
> that exact same GPIO pin is used not even as a GPIO but as an
> alternate multiplexed function e.g. as RS232 TX pin!


Wrong approach Luke.

The guys in PIC world will be laughing at all this since they have
no such difficulties.

Only one file changes between CPUs in the myriads of PICs out there.

Every register and every bit field is defined.

*Unions take care of multiplexed function*
(and #define of exact CPU model + product + wake up modes etc
 takes care of fine tuning including power-up mechanisms).


ARM realizes their mistake and introduces 'CMSIS' library.
It is available for NXP arm chips.
But the engineers who wrote it are too stupid.
They named the registers but bit fields and multiplexed pins etc
are not defined or just too stupid for words - they even change
similar register names like

 RS232-UART_Tx_REGISTER to  RS232-UART-TX-REGISTER

from one chip model to next bringing endless joy and happiness to
themselves as they aimlessly shoot themselves in both foot with one
bullet to make their library unusable from chip to chip. Doh!
(Ok just exaggerating, but its not far from the truth.)

The correct approach is to be critical of ARM lack of
a proper 'CMSIS' library and encourage them to hire just 4 open source
engineers and write some proper 'CMSIS' library, one chip at a time,
until a couple of chips get done, and then fan out and cover some
more bigger SoCs and families of chips. Its just too late to
go back and recover from all their mistakes. I'm sure once 4 engineers
publish each day their work on github, developers of SoC companies
will rapidly begin filling in the missing details for their custom
chips, because it is to their benefit to release one header file that
describe their chip completely to help port software quickly, and sell
more chips more quickly.

Who else could do this work? The SoC makers? Open source developers?
Distro makers? Not one fat chance!!

It is ARM's responsibility to make sure UART1 means UART1 in all
CPUs and not make a flat footed excuse about it.

This problem will never go away until they (ARM) do something about it.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
