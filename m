Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaCDRyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:54:17 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:35621 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaCDRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:54:15 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?VGhvbWFzIEdsZWl4bmVy?= <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>,
        =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gaXJxOiBFeHBvcnQgc3ltYm9sIG5vX2FjdGlvbigp?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Tue, 04 Mar 2014 21:53:59 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1393955639.661016045@f378.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <alpine.DEB.2.02.1403041645060.18573@ionos.tec.linutronix.de>
References: <1393656316-26757-1-git-send-email-shc_work@mail.ru>
 <1393931733.877810306@f371.i.mail.ru>
 <alpine.DEB.2.02.1403041645060.18573@ionos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24HsLcG005736

+ÑÑ Arnd Bergmann

Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº,  4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 16:46 +01:00 Ğ¾Ñ‚ Thomas Gleixner <tglx@linutronix.de>:
> On Tue, 4 Mar 2014, Alexander Shiyan wrote:
> 
> > Ğ’Ñ‚Ğ¾Ñ€Ğ½Ğ¸Ğº,  4 Ğ¼Ğ°Ñ€Ñ‚Ğ° 2014, 12:05 +01:00 Ğ¾Ñ‚ Thomas Gleixner <tglx@linutronix.de>:
> > > On Sat, 1 Mar 2014, Alexander Shiyan wrote:
> > > 
> > > > This will allow to use dummy IRQ handler no_action() from
> > > > drivers compiled as module. For example, dummy handler is could
> > > > be used for drivers that use ARM FIQ interrupts.
> > > 
> > > And why exactly requires a driver which uses ARM FIQ interrupts the
> > > no_action implementation?
> >
>  
> > FIQ Interrupt handler is not used in this function. In FIQ case this
> > is just a dummy declaration. Real handler is assigned by using the
> > set_fiq_handler().
> 
> Why do you need a dummy declaration at all?
> 
> set_fiq_handler() is completely detached from the generic interrupt
> subsystem.

Some limitations of hardware, such as bit interleaving for normal and
FIQ interrupts for mask/status registers, led to the implement single
driver for interrupt handling.
As a result, all interrupts can be described equally, and single mechanism
is used for the request/free and enable/disable.
Correct me if I'm wrong. Driver that implements it, resent several times
and expect comments within 3 months [1], you are the only one person,
Thomas, specified as maintainer for this subsystem.
I repeat, if I'm wrong in the implementation, let's fix this.

[1]: http://marc.info/?l=linux-arm-kernel&m=139132855024699

Thanks.
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
