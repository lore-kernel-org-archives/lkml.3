Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaAILGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:06:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61892 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAILGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:06:39 -0500
Date: Thu, 9 Jan 2014 11:06:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: MAX6650/6651 support
Message-ID: <20140109110635.GB20699@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
 <1387814889-16670-2-git-send-email-lpapp@kde.org>
 <20140108223933.GD18611@lee--X1>
 <CAOMwXhN5JStJgG5Q9cjuJByhyhz-XPb4ThkA45B+fA724Ucqog@mail.gmail.com>
 <20140109094147.GA20699@lee--X1>
 <CAOMwXhO=0K+SL2rNo_7JvKVET2DYZnTSr_=wzFedz2e2z_3u1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhO=0K+SL2rNo_7JvKVET2DYZnTSr_=wzFedz2e2z_3u1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Styling i.e nice, neat, easily readable/maintainable code should be
> > your bread and butter. If styling tires you, perhaps a new career
> > might be in order. ;)
> 
> or a new tool to be more professional ...

Patches accepted.

> >> >> +#include <linux/i2c.h>
> >> >> +#include <linux/export.h>
> >> >
> >> > Why is this in here?
> >>
> >> Because this series was meant for a design review and overall
> >> direction as opposed to a completely fine tuned patch set. Naturally,
> >> I agree with the feedback of removing unnecessary header inclusion.
> >
> > Don't do that.
> 
> I will guess that you mean "unnecessary header inclusion is OK"...

No, I mean don't send sub-standard patches which crap you don't need
or a copy and pasted mess contained within them.

> >> >> +struct max6651_dev {
> >> >> +    struct device *dev;
> >> >> +    struct mutex iolock;
> >> >> +
> >> >> +    struct i2c_client *i2c;
> >> >
> >> > Is this used?
> >>
> >> Yes, heavily, for reading and writing the registers in the subdevice drivers.
> >
> > Can you show me where?
> 
> Check the gpio driver or even the hwmon in this series. Look at the
> places where it is using the read/write_reg functions, or you can just
> check their signature in this patch. I am in the process of
> refactoring it into regmap as we speak, but it is not painless because
> I need to get it working for 3.2, too ...

Can you show me the line where you initialise it?

> >> >> +     int type;
> >> >
> >> > Or this?
> >>
> >> Absolutely, this identifies the type, which is necessary for
> >> initializing some corresponding data.
> >
> > Can you show me where?
> 
> Well, you have different number of GPIO pins for starter ...

Can you show me the line where this variable is used?

> >> >> +};
> >> >> +
> >> >> +enum max6651_types {
> >> >> +     TYPE_MAX6650,
> >> >> +     TYPE_MAX6651,
> >> >> +};
> >> >
> >> > What are you using these for?
> >>
> >> See above.
> >
> > Can you show me where you are using them?
> 
> Perhaps, I was not while submitting this change, but the upcoming
> changes should.

Again, this adds confusion. Send your best, cleanest, most up-to-date
code, or all you're doing is wasting people's time.
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
