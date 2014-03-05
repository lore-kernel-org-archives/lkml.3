Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaCECdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:33:52 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:42846 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaCECdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:33:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKwLJ5-Q1_u4e_o6tp1F-AKaVQG0ph1GdqjBqFiMCQvPQ@mail.gmail.com>
References: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
	<CACRpkdY-oBdxxWhsGraEU31qyu+RWJAiRA+KEip6QNW3jRwGUA@mail.gmail.com>
	<1393985087.3271.21.camel@joe-AO722>
	<CAAVeFuJdg-p4K1wdLpdv3byiEBUezGGUVjyScoOaZcLZxhPk7A@mail.gmail.com>
	<1393985959.3271.25.camel@joe-AO722>
	<CAAVeFuKwLJ5-Q1_u4e_o6tp1F-AKaVQG0ph1GdqjBqFiMCQvPQ@mail.gmail.com>
Date: Wed, 5 Mar 2014 10:33:48 +0800
Message-ID: <CACRpkdbaLy+uY_fsht=Fk0qPdtAnttpOK3xrpirPbwB0mA+TPQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: clamp returned values to the boolean range
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Joe Perches <joe@perches.com>, Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 10:22 AM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Mar 5, 2014 at 11:19 AM, Joe Perches <joe@perches.com> wrote:
>> On Wed, 2014-03-05 at 11:14 +0900, Alexandre Courbot wrote:
>>> On Wed, Mar 5, 2014 at 11:04 AM, Joe Perches <joe@perches.com> wrote:
>>> > On Wed, 2014-03-05 at 09:49 +0800, Linus Walleij wrote:
>>> >> On Wed, Feb 26, 2014 at 9:40 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>> >>
>>> >> > Nothing prevents GPIO drivers from returning values outside the
>>> >> > boolean range, and as it turns out a few drivers are actually doing so.
>>> >> > These values were passed as-is to unsuspecting consumers and created
>>> >> > confusion.
>>> >> >
>>> >> > This patch makes the internal _gpiod_get_raw_value() function return a
>>> >> > bool, effectively clamping the GPIO value to the boolean range no
>>> >> > matter what the driver does.
>>> >>
>>> >> No, that will not be the semantic effect of this patch, bool is just
>>> >> another name for an int, maybe some static checkers will be able
>>> >> to use it however.
>>> >
>>> > No, a bool is not an int.
>>> >
>>> > It's really different.
>>> > include/linux/types.h:typedef _Bool                     bool;
>>>
>>> It indeed seems that _Bool is an actual boolean type in C99. However I
>>> could not find in the C99 standard how ints are supposed to be
>>> converted to it.
>>
>> 6.3.1.2 Boolean type
>>
>> When any scalar value is converted to _Bool, the result is 0 if the
>> value compares equal to 0; otherwise, the result is 1.
>>
>>> So in the end it is probably safer to perform this
>>> change the way Linus suggested.
>>
>> Not really.
>
> Ok, you are obviously correct here. Linus, what do you think?

Yeah I was wrong ... too old and not keeping up with standards
development :-)

Anyway, the local "value" variable in the function should still be
converted to a bool as well right? And the assignment should still
be "false" not 0. So I would still add my hunk of code...

Yours,
Linus Walleij
