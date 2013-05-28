Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab3E1JCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:02:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41522 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab3E1JCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:02:18 -0400
Date: Tue, 28 May 2013 10:02:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Leon Romanovsky <leon@leon.nu>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
Message-ID: <20130528090213.GB22683@gmail.com>
References: <1368609586-20905-1-git-send-email-leon@leon.nu>
 <20130523083751.GC22683@gmail.com>
 <CALq1K=Las2mwV9x6ajEUDYg6nLbcK2KVLK8TH2B1f=9fQ7JfTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALq1K=Las2mwV9x6ajEUDYg6nLbcK2KVLK8TH2B1f=9fQ7JfTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Leon Romanovsky wrote:

> On May 23, 2013 11:37 AM, "Lee Jones" <lee.jones@linaro.org> wrote:
> >
> > On Wed, 15 May 2013, Leon Romanovsky wrote:
> >
> > > There is no need to call kfree while using devm_kzalloc,
> > > remove it from *_device_init function.
> > >
> > > Signed-off-by: Leon Romanovsky <leon@leon.nu>
> > > ---
> > >  drivers/mfd/tps65912-core.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
> > > index aeb8e40..f25e552 100644
> > > --- a/drivers/mfd/tps65912-core.c
> > > +++ b/drivers/mfd/tps65912-core.c
> > > @@ -127,7 +127,8 @@ int tps65912_device_init(struct tps65912 *tps65912)
> > >       struct tps65912_platform_data *init_data;
> > >       int ret, dcdc_avs, value;
> > >
> > > -     init_data = kzalloc(sizeof(struct tps65912_platform_data),
> GFP_KERNEL);
> > > +     init_data = devm_kzalloc(&tps65912->dev,
> > > +                     sizeof(struct tps65912_platform_data),
> GFP_KERNEL);
> >
> > On second thoughts, have you actually built this?
>
> Sure,  I hope,  that I didn't miss anything.
 
Can you make absolutely sure that you did please?

I mention it because I would expect lots of warnings if you did.

Something like:

drivers/mfd/tps65912-core.c: In function ‘tps65912_reg_write’:
drivers/mfd/tps65912-core.c:117:3: warning: passing argument 1 of ‘dev_err’ from incompatible pointer type [enabled by default]
In file included from include/linux/platform_device.h:14:0,
                 from include/linux/mfd/core.h:17,
                 from drivers/mfd/tps65912-core.c:21:
include/linux/device.h:954:5: note: expected ‘const struct device *’ but argument is of type ‘struct device **’
drivers/mfd/tps65912-core.c: In function ‘tps65912_device_init’:
drivers/mfd/tps65912-core.c:131:18: warning: passing argument 1 of ‘devm_kzalloc’ from incompatible pointer type [enabled by default]
In file included from include/linux/platform_device.h:14:0,
                 from include/linux/mfd/core.h:17,
                 from drivers/mfd/tps65912-core.c:21:
include/linux/device.h:574:14: note: expected ‘struct device *’ but argument is of type ‘struct device **’

Can you check and make sure, because there's some disparity
somewhere.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
