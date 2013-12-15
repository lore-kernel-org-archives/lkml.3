Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3LOJwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 04:52:09 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:58306 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3LOJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 04:52:07 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TGV2ZW50ZSBLdXJ1c2E=?= <levex@linux.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gcmVnbWFwOiBpcnE6IEFsbG93IHVzaW5nIHplcm8gdmFs?=
 =?UTF-8?B?dWUgZm9yIGFja19iYXNl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sun, 15 Dec 2013 13:51:38 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1387101098.569230728@f386.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <52AD7AE7.7070301@linux.com>
References: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
 <52AD7AE7.7070301@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBF9qFMA019346

> On 12/15/2013 10:36 AM, Alexander Shiyan wrote:
> > In some cases, clear interrupt register may be at address 0.
> > This patch allows to use such configurations by adding additional
> > configuration bit to indicate this.
> > 
> > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > ---
> >  drivers/base/regmap/regmap-irq.c | 6 +++---
> >  include/linux/regmap.h           | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
...
> > diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> > index e559078..3a36f61 100644
> > --- a/include/linux/regmap.h
> > +++ b/include/linux/regmap.h
...
> > @@ -520,6 +522,7 @@ struct regmap_irq_chip {
> >  	unsigned int irq_reg_stride;
> >  	bool init_ack_masked:1;
> >  	bool mask_invert:1;
> > +	bool use_ack:1;
> I think this will break something. Better use 0 as default value.
> Reason I think so, is because in the above code you effectively add a new
> possibility for most code to run.

This is not a default value but bit-size of this field.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
