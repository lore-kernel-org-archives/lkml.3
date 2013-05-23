Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3EWIXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:23:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43836 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3EWIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <201305221608.10759.arnd@arndb.de>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org>
	<1369226853-16978-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdYHiwbGonH80aJfHxP6F+hLb+_KdCr_g5ae1Yr-v=WcxA@mail.gmail.com>
	<201305221608.10759.arnd@arndb.de>
Date: Thu, 23 May 2013 10:23:43 +0200
Message-ID: <CACRpkdacteTbFkOQ9w3LQCwN+RDviK04j77itz7uyTiY56+nCg@mail.gmail.com>
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without
 initialisation data
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 4:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 22 May 2013, Linus Walleij wrote:
>> > diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
>> > index b4d4547..8421537 100644
>> > --- a/drivers/regulator/ab8500-ext.c
>> > +++ b/drivers/regulator/ab8500-ext.c
>> > @@ -334,6 +334,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
>> >                 return -EINVAL;
>> >         }
>> >
>> > +       /* have any external regulators been specified? */
>> > +       if (pdata->num_ext_regulator == 0) {
>> > +               dev_warn(&pdev->dev, "Not using external regulators\n");
>> > +               return 0;
>> > +       }
>>
>> dev_warn() is really when we warn about something really nasty, worse
>> than dev_err(). It seems dev_info() is more apropriate.
>
> Are you confusing it with dev_crit()?
>
> This is how the levels are defined, and "warning" is less urgent than "error":

Yeah :-/

But I still think this should be just dev_info().

No big deal though.

Yours,
Linus Walleij
