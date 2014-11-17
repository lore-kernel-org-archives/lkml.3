Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaKQIBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:01:40 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46723 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaKQIBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:01:38 -0500
MIME-Version: 1.0
In-Reply-To: <6465990.KKns6W8hQE@vostro.rjw.lan>
References: <1415917702-6742-1-git-send-email-khilman@kernel.org>
	<7ha93t8z1q.fsf@deeprootsystems.com>
	<CAMuHMdVrpwg2pYxUhA5oRgd1g2DmLuSb2jR3ywz8hkjms7UBcw@mail.gmail.com>
	<6465990.KKns6W8hQE@vostro.rjw.lan>
Date: Mon, 17 Nov 2014 09:01:35 +0100
X-Google-Sender-Auth: 90wkWNbqST71_of2uqhGYH5Lp9k
Message-ID: <CAMuHMdUB_ESDe7xXn_-Zd--pKfOv31wwtj=whwDF5YrvQ98yig@mail.gmail.com>
Subject: Re: [PATCH] PM / domains: Kconfig: always enable PM_RUNTIME when
 genpd enabled
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Kevin Hilman <khilman@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 2:22 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Saturday, November 15, 2014 01:32:01 PM Geert Uytterhoeven wrote:
>> On Fri, Nov 14, 2014 at 6:36 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> >> On Thu, Nov 13, 2014 at 11:28 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> >>> It makes little sense to use generic power domains without runtime PM.
>> >>
>> >> Does it?
>> >> It still powers down the PM domains on system suspend (at least on my
>> >> boards ;-)
>> >
>> > Sure, but your devices are also using runtime PM, so I'm not sure how
>> > does that change my statement above?
>>
>> I do mean with CONFIG_PM_RUNTIME turned off.
>>
>> If PM domain support is disabled, s2ram will not power down the PM domains.
>
> But if PM_RUNTIME is enabled along with it, I don't think it will make much
> of a different, will it?

That's true.

> Building the kernel with genpd and without PM_RUNTIME is possible today,
> but is it really useful?  To me, it only seems to make people try to
> reinvent the wheel "because PM_RUNTIME may be unset".
>
> I have to say I'm seriously considering to make PM_SLEEP select
> PM_RUNTIME too as that would make quite a few things a *lot* simpler.

I agree that it would simplify things, a reduce testing efforts.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
