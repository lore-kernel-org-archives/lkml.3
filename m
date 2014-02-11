Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaBKRWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:22:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41523 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:22:13 -0500
From: Pawel Moll <Pawel.Moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 11 Feb 2014 17:20:56 +0000
Subject: Re: [PATCH 05/12] GPIO: gpio-generic: Add label to platform data
Thread-Topic: [PATCH 05/12] GPIO: gpio-generic: Add label to platform data
Thread-Index: Ac8nTZ911wFmVfqdSsCmid6Fk8Wtew==
Message-ID: <1392139256.3380.45.camel@hornet>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-6-git-send-email-pawel.moll@arm.com>
	 <20140211171721.GE15081@lee--X1>
In-Reply-To: <20140211171721.GE15081@lee--X1>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
MIME-Version: 1.0
X-MC-Unique: 114021117205705002
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1BHMI8F008904

On Tue, 2014-02-11 at 17:17 +0000, Lee Jones wrote:
> > When registering more than one platform device, it is
> > useful to set the gpio chip label in the platform data.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > ---
> > This patch has been already merged by Linux; it has been included
> > for completeness only.
> >
> >  drivers/gpio/gpio-generic.c     | 2 ++
> >  include/linux/basic_mmio_gpio.h | 1 +
> >  2 files changed, 3 insertions(+)
> >
> > diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> > index d2196bf..8c778af 100644
> > --- a/drivers/gpio/gpio-generic.c
> > +++ b/drivers/gpio/gpio-generic.c
> > @@ -531,6 +531,8 @@ static int bgpio_pdev_probe(struct platform_device *pdev)
> >             return err;
> >
> >     if (pdata) {
> > +           if (pdata->label)
>
> Why is this check necessary?
>
> > +                   bgc->gc.label = pdata->label;

Because bgc->gc.label is initialized to a default value in bgpio_init()
and I don't want to override it with NULL if there is no label passed in
the platform data.

Pawel

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

ARM Limited, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2557590
ARM Holdings plc, Registered office 110 Fulbourn Road, Cambridge CB1 9NJ, Registered in England & Wales, Company No:  2548782
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
