Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3BGKBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:01:33 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44018 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3BGKBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:01:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAF2Aj3iO+6j+T5C0X2Hh6TsvT4yaJ2cai6cC9DaiRAwL9n-dVw@mail.gmail.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
	<1360093715-6348-3-git-send-email-linus.walleij@stericsson.com>
	<5112F043.6040700@wwwdotorg.org>
	<CAF2Aj3iO+6j+T5C0X2Hh6TsvT4yaJ2cai6cC9DaiRAwL9n-dVw@mail.gmail.com>
Date: Thu, 7 Feb 2013 11:01:29 +0100
Message-ID: <CACRpkdb1W8HWV+ZTcA5EyjT8pEnnLUaB4rsiyCLpJiff-0=5-Q@mail.gmail.com>
Subject: Re: [PATCH 02/14] mfd: ab8500: provide a irq_set_type() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 10:08 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Great spot/idea. But then this won't work at all until I can write a fixup.
>
> Will you allow me to write a follow-up patch please?

For me a sequel is OK, especially given that this thing doesn't make
things any worse than they are already, but actually checking supported
types will not be trivial, because...

>> > +static int ab8500_irq_set_type(struct irq_data *data, unsigned int
>> > type)
>> > +{
>> > +     return 0;
>> > +}

This applies to *ALL* AB8500 IRQs, and some of them actually support
rising/falling, apart from the GPIO ones, so it's not enough to just handle
the GPIO IRQs here.

Yours,
Linus Walleij
