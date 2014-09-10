Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaIJPfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:35:05 -0400
Received: from fallback2.mail.ru ([94.100.179.22]:33354 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaIJPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:35:03 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?VG9iaWFzIEtsYXVzZXI=?= <tklauser@distanz.ch>
Cc: =?UTF-8?B?SmltIERhdmlz?= <jim.epost@gmail.com>,
        =?UTF-8?B?U3RlcGhlbiBSb3Rod2VsbA==?= <sfr@canb.auug.org.au>,
        =?UTF-8?B?bGludXgtbmV4dA==?= <linux-next@vger.kernel.org>,
        =?UTF-8?B?bGludXgta2VybmVs?= <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz, linux-serial@vger.kernel.org,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gdHR5OiBzZXJpYWw6IHNlcmlhbF9tY3RybF9ncGlvOiBG?=
 =?UTF-8?B?aXggYnVpbGQgZXJyb3IgZm9yICFHUElPTElC?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Wed, 10 Sep 2014 18:36:09 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1410359769.646202267@f334.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20140910141621.GA4636@distanz.ch>
References: <CA+r1ZhjCZBWjkxjoJz=PO-YZg6LbghQV75tGnpiSOrHM9CaygA@mail.gmail.com>
 <20140910135716.GA23074@kroah.com>
 <20140910141621.GA4636@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8AFZBiJ016707

Wed, 10 Sep 2014 16:16:21 +0200 Ğ¾Ñ‚ Tobias Klauser <tklauser@distanz.ch>:
> On 2014-09-10 at 15:57:16 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Wed, Sep 10, 2014 at 10:06:58AM +0200, Tobias Klauser wrote:
> > > If SERIAL_MCTRL_GPIO is selected but GPIOLIB is not, the noop functions
> > > from serial_mctrl_gpio.h are pulled in. However, serial_mctrl_gpio.c is
> > > still compiled, leading to function redefinition build errors. Since all
> > > drivers that include serial_mctrl_gpio.h also depend on
> > > SERIAL_MCTRL_GPIO, let it depend on GPIOLIB as well remove the noop
> > > functions alltogether.
> > > 
> > > Reported-by: Jim Davis <jim.epost@gmail.com>
> > > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > > ---
> > >  drivers/tty/serial/Kconfig             |  1 +
> > >  drivers/tty/serial/serial_mctrl_gpio.h | 35 ----------------------------------
> > >  2 files changed, 1 insertion(+), 35 deletions(-)
> > 
> > I fixed this yesterday with commit below from Alexander, which does
> > things a bit differently than you.  Any objections to it?
> 
> This is nicer in terms of being able to compile the driver without
> GPIOLIB. However, it wont fix it for the other user of
> SERIAL_MCTRL_GPIO, namely SERIAL_ATMEL. And for any future users of
> SERIAL_MCTRL_GPIO, we need to make sure to use the same select
> directive. To fix it for atmel_serial, I'd suggest the patch below.

Atmel serial driver is already protected by ARCH_REQUIRE_GPIOLIB
in the architecture configuration. The error is happen only for COMPILE_TEST,
but for Atmel driver this option is disabled.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
