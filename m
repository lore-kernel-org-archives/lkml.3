Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIYURQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:17:16 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39215 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaIYURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <201409252117.19754.arnd@arndb.de>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
	<4240583.SJ4jiIW6Zy@wuerfel>
	<54243395.902@linaro.org>
	<201409252117.19754.arnd@arndb.de>
Date: Thu, 25 Sep 2014 22:17:10 +0200
X-Google-Sender-Auth: eFUaCsMFKN1gRnJXlTzdKOuOG0o
Message-ID: <CAMuHMdWwOVjnhhqkdDUpfzrNTreNMds_k7svmUFaLPBbWL4BMQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Sep 25, 2014 at 9:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 25 September 2014, Daniel Thompson wrote:
>> > +
>> > +#ifndef readq_relaxed
>> > +#define readq_relaxed readq
>> > +#endif
>>
>> Not really sure if it matters but this gives a rather surprising
>> behaviour to #ifdef readq_relaxed given that readq may not be defined.
>
> It was intentional. I could have written this as
>
> #if !defined(readq_relaxed) && defined(readq)
>
> but the effect would be almost the same, and the version I picked looks
> simpler.

However, as soon as a driver has code like

#ifdef readq_relaxed
        do something using readq_relaxed
#else
...
#endif

this will fail if readq is not defined.

Currently no code has such an #ifdef, though.
There are #ifdefs for checking for the presence of readq.

The same is true for writeq_relaxed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
