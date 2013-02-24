Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3BXWjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:39:48 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44449 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab3BXWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <1366216.NzXQfD1BG7@flatron>
References: <201302231855.47560.heiko@sntech.de>
	<31669750.ZZOiY1AEPv@flatron>
	<CACRpkdYBjZgEo6qEyBOcYuPzpQUAZ9x-kvFabz0y0pEQs35sKw@mail.gmail.com>
	<1366216.NzXQfD1BG7@flatron>
Date: Sun, 24 Feb 2013 23:39:44 +0100
Message-ID: <CACRpkdbfQOeJ3u8_UvgVMRyu_MMmOZD0tjQT+qNr9iOEpAHLWQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 6:00 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

>> > Note that we are talking here about a temporary solution. The legacy
>> > DT- based pin configuration will go away after all the DT-enabled
>> > platforms using this driver get migrated to pin control and so will
>> > the need to check if pin control is available.
>>
>> So use AUXDATA, and you get a pdata for that driver?
>
> Hmm, and then have some platform data passed statically and some parsed
> from device tree?

This is done by several in-tree drivers today. It is even necessary for things
like machine-specific callbacks.

> Not even saying that we are going towards getting rid of
> auxdata, not adding further dependencies for it.

The other option is to do the non-temporary solution you are
referring to below...

> Sorry, but this sounds more broken to me than checking the return value of
> devm_pinctrl_get_select_default for NULL in the driver.

Both are bad solution, auxdata is less bad than trying to check
struct pinctrl * handles for non-NULL, which has *never* been a
good thing to do and should never have been merged in the first
place.

(Maybe I ACKed that, then I was doing something stupid.)

> Still, all the platforms relying on the legacy DT GPIO support should have
> been already migrated to pin control, so ideally instead of "fixing" the
> drivers to continue supporting the deprecated method, such platforms
> should be fixed.

I agree.

Yours,
Linus Walleij
