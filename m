Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3L0Gnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:43:41 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:42655 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3L0Gnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:43:39 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?R3JlZyBLSA==?= <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?VHVzaGFyIEJlaGVyYQ==?= <tushar.behera@linaro.org>,
        =?UTF-8?B?bGludXgtc2VyaWFs?= <linux-serial@vger.kernel.org>,
        =?UTF-8?B?bGttbA==?= <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?anNsYWJ5?= <jslaby@suse.cz>,
        =?UTF-8?B?UGF0Y2ggVHJhY2tpbmc=?= <patches@linaro.org>,
        =?UTF-8?B?bGludXgtc2Ftc3VuZy1zb2M=?= 
	<linux-samsung-soc@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gc2VyaWFsOiBzYW1zdW5nOiBSZW1vdmUgaGFyZC1jb2Rl?=
 =?UTF-8?B?ZCBtYWpvci9taW5vciBudW1iZXJz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Fri, 27 Dec 2013 10:43:23 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1388126603.342451910@f289.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131227063843.GA3310@kroah.com>
References: <1388120848-15879-1-git-send-email-tushar.behera@linaro.org>
 <CAHbNUh27ZZ5UxuLMPvv6weNOSG4XKV9ZRrmTB9F0RvgQxufGDQ@mail.gmail.com>
 <20131227063843.GA3310@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBR6hl9s007716

Hello.
> On Fri, Dec 27, 2013 at 12:00:20PM +0530, Tushar Behera wrote:
> > On 27 December 2013 10:48, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > On Fri, Dec 27, 2013 at 10:37:28AM +0530, Tushar Behera wrote:
> > >> The hard-coded values clash with the values set for amba-pl011 serial
> > >> driver. Because of this there is no serial output on Samsung boards
> > >> if amba-pl011 is enabled alongwith samsung-serial driver.
> > >>
> > >> Remove the hardcoded values and let the framework decide on
> > >> appropriate major/minor number. This is required for multi-platform
> > >> development work on Exynos platform.
> > >>
> > >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
...
> > >>  #define S3C24XX_SERIAL_NAME  "ttySAC"
> > >> -#define S3C24XX_SERIAL_MAJOR 204
> > >> -#define S3C24XX_SERIAL_MINOR 64
> > >>
> > >>  /* macros to change one thing to another */
> > >>
> > >> @@ -951,8 +949,6 @@ static struct uart_driver s3c24xx_uart_drv = {
> > >>       .nr             = CONFIG_SERIAL_SAMSUNG_UARTS,
> > >>       .cons           = S3C24XX_SERIAL_CONSOLE,
> > >>       .dev_name       = S3C24XX_SERIAL_NAME,
> > >> -     .major          = S3C24XX_SERIAL_MAJOR,
> > >> -     .minor          = S3C24XX_SERIAL_MINOR,
> > >
> > > Doesn't this break existing systems and configurations that are
> > > expecting 204:64 as the location of this serial port?
> > >
> > 
> > I tested this on Exynos4210-Origen, Exynos5250-Arndale board, it works
> > fine there. I haven't tested on any older boards.
> 
> How did it work?  You are relying on some userspace tools to do this
> properly, right?  What about systems without those specific tools?

Can this issue be resolved by using MODULE_ALIAS_CHARDEV()
in the driver code?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
