Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3FMQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:40:30 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40592 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FMQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:40:28 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>,
        =?utf-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts before unmasking
Date: Thu, 13 Jun 2013 18:40:24 +0200
Message-ID: <21437214.t3ykTcfRY8@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <CAD=FV=XzAGoVDic5L8Zub6MMBf_sb6-4aOuq5orT5ska84XiOA@mail.gmail.com>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org> <24084769.VqIFUPHnqh@flatron> <CAD=FV=XzAGoVDic5L8Zub6MMBf_sb6-4aOuq5orT5ska84XiOA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 of June 2013 09:34:43 Doug Anderson wrote:
> Tomasz,
> 
> On Thu, Jun 13, 2013 at 3:54 AM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > Hi Doug,
> > 
> > On Wednesday 12 of June 2013 10:33:19 Doug Anderson wrote:
> >> A level-triggered interrupt should be acked after the interrupt line
> >> becomes inactive and before it is unmasked, or else another interrupt
> >> will be immediately triggered.  Acking before or after calling the
> >> handler is not enough.
> > 
> > Nice catch.
> > 
> > I guess that pinctrl-s3c64xx will need similar fix as well, won't it?
> 
> It needs this whole series of 3, probably.  The mask and unmask need
> the lock and as well as the acking for level interrupts.
> 
> I don't have any way to test that code but it's a pretty simple change
> to make.  Do you want to do it or do you have an idea of someone who
> should?

I'll take care of s3c64xx, probably as a part of my patches finally adding 
DT support for it, as without them the pinctrl-s3c64xx driver is just 
sitting there unused.

> > I think you can eliminate most of the code by doing this following 
way:
> >         if (irqd_get_trigger_type(irqd) & IRQ_TYPE_LEVEL_MASK)
> >         
> >                 exynos_gpio_irq_ack(irqd);
> 
> Duh, right.  OK, v2 coming shortly.

Good!

> Thank you for pointing out the
> right way to do this!  :)

You're welcome.

Best regards,
Tomasz

