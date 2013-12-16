Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3LPJIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:08:05 -0500
Received: from fallback1.mail.ru ([94.100.176.18]:45835 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LPJID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:08:03 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAzLzNdIG1mZDogbWMxM3h4eDogU2ltcGxpZnkgInByb2Jl?=
 =?UTF-8?B?IiAmICJyZW1vdmUi?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Mon, 16 Dec 2013 13:06:27 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1387184787.722913245@f178.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <20131216084313.GF18769@lee--X1>
References: <1387026192-21234-1-git-send-email-shc_work@mail.ru>
 <1387026192-21234-3-git-send-email-shc_work@mail.ru>
 <20131216084313.GF18769@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBG98DWt023504

> > This patch simplifies "probe" and "remove" functions by moving
> > some initialization code in the driver core.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/mfd/mc13xxx-core.c | 36 +++++++++++++++++-------------------
> >  drivers/mfd/mc13xxx-i2c.c  | 18 ++++--------------
> >  drivers/mfd/mc13xxx-spi.c  | 19 ++++++-------------
> >  drivers/mfd/mc13xxx.h      |  6 ++----
> >  4 files changed, 29 insertions(+), 50 deletions(-)
> > 
> > diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> > index b0c7cb0..06e64b6 100644
> > --- a/drivers/mfd/mc13xxx-core.c
> > +++ b/drivers/mfd/mc13xxx-core.c
> 
> <snip>
> 
> > -	ret = request_threaded_irq(irq, NULL, mc13xxx_irq_thread,
> > +	ret = request_threaded_irq(mc13xxx->irq, NULL, mc13xxx_irq_thread,
> >  			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
> 
> Please use devm_* managed resources, then you can remove the free_irq().

Using devm-* is not possible at this time since we need to avoid interrupts before
removing mc13xxx childs.
This could be converted to use devm-* functions once we migrate to IRQ domains.
I work on this now.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
