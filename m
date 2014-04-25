Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaDYS2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:28:31 -0400
Received: from fallback1.mail.ru ([94.100.176.18]:60716 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDYS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:28:28 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jon@ringle.org>
Cc: =?UTF-8?B?R3JlZyBLSA==?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?bGludXgtc2VyaWFsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-serial@vger.kernel.org>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Sm9uIFJpbmdsZQ==?= <jringle@gridpoint.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NyAxLzJdIHNlcmlhbDogc2MxNmlzN3h4?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Fri, 25 Apr 2014 22:28:10 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1398450490.22421425@f292.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <CAMwGMjz+=rvYBVPpkC9f1bpW46_1srmokH8-PzDS+2Z2OqCOtQ@mail.gmail.com>
References: <1398387367-4047-1-git-send-email-jon@ringle.org>
 <1398447618.26477952@f179.i.mail.ru>
 <CAMwGMjz+=rvYBVPpkC9f1bpW46_1srmokH8-PzDS+2Z2OqCOtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PISdQr009573

Fri, 25 Apr 2014 14:24:23 -0400 Ğ¾Ñ‚ Jon Ringle <jon@ringle.org>:
> On Fri, Apr 25, 2014 at 1:40 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> > Fri, 25 Apr 2014 10:26:40 -0700 Ğ¾Ñ‚ Greg KH <gregkh@linuxfoundation.org>:
> >> On Thu, Apr 24, 2014 at 08:56:06PM -0400, jon@ringle.org wrote:
> >> > From: Jon Ringle <jringle@gridpoint.com>
> >> >
> >> > The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> >> > high performance UART. The SC16IS7xx's internal register set is
> >> > backward-compatible with the widely used and widely popular 16C450.
> >> >
> >> > The SC16IS7xx also provides additional advanced features such as
> >> > auto hardware and software flow control, automatic RS-485 support, and
> >> > software reset.
> >> >
> >> > Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> >> > ---
> >> >  drivers/tty/serial/Kconfig       |    9 +
> >> >  drivers/tty/serial/Makefile      |    1 +
> >> >  drivers/tty/serial/sc16is7xx.c   | 1279 ++++++++++++++++++++++++++++++++++++++
> >> >  include/uapi/linux/serial_core.h |    3 +
> >> >  4 files changed, 1292 insertions(+)
> >> >  create mode 100644 drivers/tty/serial/sc16is7xx.c
> >>
> >> I get a few build warnings with this patch applied:
> >>
> >> drivers/tty/serial/sc16is7xx.c:1059:12: warning: â€˜sc16is7xx_probeâ€™ defined but not used [-Wunused-function]
> >>  static int sc16is7xx_probe(struct device *dev,
> >>             ^
> >> drivers/tty/serial/sc16is7xx.c:1175:12: warning: â€˜sc16is7xx_removeâ€™ defined but not used [-Wunused-function]
> >>  static int sc16is7xx_remove(struct device *dev)
> >>             ^
> >> drivers/tty/serial/sc16is7xx.c:1214:29: warning: â€˜regcfgâ€™ defined but not used [-Wunused-variable]
> >>  static struct regmap_config regcfg = {
> >>                              ^
> >>
> >> Can you send a follow-on patch to fix them?
> >
> > Seems this just should contain: "depends on I2C" in the Kconfig.
> 
> I can add "depends on I2C" in Kconfig for now, but I'm just wondering
> how would this be dealt with when sometime in the future this driver
> supports either I2C or SPI? Can the "depends on" be conditional
> somehow?

If anyone adds SPI support later, this can be represented as:
depends on I2C || SPI_MASTER
select REGMAP_I2C if I2C
select REGMAP_SPI if SPI_MASTER

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
