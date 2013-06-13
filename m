Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3FMQer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:34:47 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58473 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab3FMQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:34:45 -0400
MIME-Version: 1.0
In-Reply-To: <24084769.VqIFUPHnqh@flatron>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<1371058399-31933-3-git-send-email-dianders@chromium.org>
	<24084769.VqIFUPHnqh@flatron>
Date: Thu, 13 Jun 2013 09:34:43 -0700
X-Google-Sender-Auth: zcoEFytjiJZfi1FvAT1bn6vhd04
Message-ID: <CAD=FV=XzAGoVDic5L8Zub6MMBf_sb6-4aOuq5orT5ska84XiOA@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>,
        =?UTF-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 13, 2013 at 3:54 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Doug,
>
> On Wednesday 12 of June 2013 10:33:19 Doug Anderson wrote:
>> A level-triggered interrupt should be acked after the interrupt line
>> becomes inactive and before it is unmasked, or else another interrupt
>> will be immediately triggered.  Acking before or after calling the
>> handler is not enough.
>
> Nice catch.
>
> I guess that pinctrl-s3c64xx will need similar fix as well, won't it?

It needs this whole series of 3, probably.  The mask and unmask need
the lock and as well as the acking for level interrupts.

I don't have any way to test that code but it's a pretty simple change
to make.  Do you want to do it or do you have an idea of someone who
should?


> I think you can eliminate most of the code by doing this following way:
>
>         if (irqd_get_trigger_type(irqd) & IRQ_TYPE_LEVEL_MASK)
>                 exynos_gpio_irq_ack(irqd);

Duh, right.  OK, v2 coming shortly.  Thank you for pointing out the
right way to do this!  :)

-Doug
