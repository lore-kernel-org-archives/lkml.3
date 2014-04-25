Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaDYOfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:35:14 -0400
Received: from fallback8.mail.ru ([94.100.176.136]:38639 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaDYOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:35:07 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Q2hhcmxlcyBDb2xkd2VsbA==?= <coldwell@gmail.com>
Cc: =?UTF-8?B?bGludXgtc2VyaWFsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-serial@vger.kernel.org>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        =?UTF-8?B?R3JlZyBLSA==?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jon@ringle.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NyAxLzJdIHNlcmlhbDogc2MxNmlzN3h4?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Fri, 25 Apr 2014 18:33:29 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1398436409.315304910@f193.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <alpine.LRH.2.03.1404251019300.2893@frank.harvard.edu>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
 <CAMwGMjyqiC1DLKfz0LUFg-iN8mDKc54w+8AYKFHOydiwtXHrFQ@mail.gmail.com>
 <alpine.LRH.2.03.1404251019300.2893@frank.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PEZtTu007847

Fri, 25 Apr 2014 10:24:30 -0400 (EDT) Ğ¾Ñ‚ Charles Coldwell <coldwell@gmail.com>:
> On Fri, 25 Apr 2014, Jon Ringle wrote:
> 
> > On Fri, Apr 25, 2014 at 9:44 AM, Charles Coldwell <coldwell@gmail.com> wrote:
> > > On Fri, 25 Apr 2014, Charles Coldwell wrote:
> > >
> > >> On Thu, 24 Apr 2014, jon@ringle.org wrote:
> > >>
> > >> > diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> > >>
> > >> Isn't this a lot of duplication?
> > >
> > > Actually, the whole thing seems like duplication to me.
> > 
> > The fact that we need to reach over the SPI/I2C bus makes a big
> > difference in the way access is handled.
> > 
> > To achieve acceptable throughput, it is necessary to use threaded irq
> > and also bulk i2c transfers for RX and TX using
> > regmap_raw_{read,write}() to optimize the use of the i2c bus.
> 
> Fair enough, but the 8250 framework does allow you to insert your own
> irq service routine. "serial8250_default_handle_irq" is the default
> (unsurprisingly), but if the uart_port has a non-NULL "handle_irq"
> method it will be faithfully copied into the uart_8250_port
> "handle_irq" method in 8250_core.c:early_serial_setup.
> 
> > This is not a good fit for 8250.
> 
> If that's really true, then I would say it argues in favor of a
> revision of the 8250 code.  Certainly, this is not the last time that
> a 16550-compatible UART will appear on a non-PCI, non-ISA bus.

At this stage, I would suggest just move the driver code into serial/8250
to indicate the compatibility and then apply this patch and look for ways
to optimize similar functions.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
