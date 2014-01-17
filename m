Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaAQRAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:00:23 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:48642 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaAQRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:00:21 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?RmVuZyBLYW4=?= <fkan@apm.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBWMyAzLzNdIHBvd2VyOiByZXNldDogdXNlIHN5c2NvbiBk?=
 =?UTF-8?B?cml2ZXIgdG8gcGFyc2UgcmVib290IHJlZ2lzdGVyIGZyb20gc2N1?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Fri, 17 Jan 2014 20:59:43 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1389977983.940533034@f47.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <201401171752.47393.arnd@arndb.de>
References: <1389748055-23534-1-git-send-email-fkan@apm.com>
 <1389748055-23534-4-git-send-email-fkan@apm.com>
 <201401171752.47393.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HH0RRR026231

ĞŸÑÑ‚Ğ½Ğ¸Ñ†Ğ°, 17 ÑĞ½Ğ²Ğ°Ñ€Ñ 2014, 17:52 +01:00 Ğ¾Ñ‚ Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 15 January 2014, Feng Kan wrote:
> > +static int __init xgene_reboot_init(void)
> >  {
> >         arm_pm_restart = xgene_restart;
> >         return 0;
> >  }
> >  device_initcall(xgene_reboot_init);
> 
> This won't work on a generic kernel, since you unconditionally set the
> pm_restart function to your own, which is broken for everything else.
> 
> Please keep the platform_driver to attach to the reboot device
> as you had before. It might be good to turn this into a generic
> "syscon-reset" driver that gets both the register number and
> the contents to write from the device node.

I am not sure but think the new driver for SYSCON GPIOs can be
reused for such purpose:
http://www.spinics.net/lists/devicetree/msg18221.html

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
