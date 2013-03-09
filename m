Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3CIPtl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 10:49:41 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:45250 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab3CIPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 10:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130309011809.GA4028@lizard.sbx05280.losalca.wayport.net>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu> <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
 <20130228013514.GA7556@lizard.fhda.edu> <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
 <20130228025931.GA13764@lizard.gateway.2wire.net> <513A1411.7060403@windriver.com>
 <20130309011809.GA4028@lizard.sbx05280.losalca.wayport.net>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sat, 9 Mar 2013 10:49:08 -0500
X-Google-Sender-Auth: L40ijPO4HPPGc38kXdobYmS3nc4
Message-ID: <CAP=VYLpxZzi6OFpDjJaR2EVcgmS4EcoAAk5wSzjrbi+QSfaEWw@mail.gmail.com>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 8:18 PM, Anton Vorontsov <anton@enomsg.org> wrote:
> Hi Paul,
>
> On Fri, Mar 08, 2013 at 11:38:41AM -0500, Paul Gortmaker wrote:
>> > I see. In that case, please feel free to send the patch to akpm with my
>> > Nack and pointing to this discussion. If Andrew agrees and I was wrong
>> > (and I'm really curious whether I am right or wrong), I will start
>> > applying such patches in future.
>>
>> I didn't send the patch to akpm, but I did have a chance to ask akpm how
>> dependencies should be used, and you can see his answer here:
>>
>>       https://lkml.org/lkml/2013/3/7/456
>
> Thanks for asking! FWIW, I won't be against CONFIG_AKPM. ;-) Something
> like that will work:
>
>         depends on GENERIC_HARDIRQS
>         depends on RESTRICT_PLATFORM && GOLDFISH
>
> But not that I think we really need this option, though. Whoever wants to

Of course, it was only meant sarcastically, but the CONFIG_AKPM
joke wasn't the important part of the email discussion though.

Above,  you asked "If Andrew agrees [that dependencies should describe
the hardware/platform] ... I will start applying such patches in future."

The important bit is Andrew's answer to your question:

  "...offering useless stuff to non-kernel-developers has downsides
  with no balancing benefit, and we really should optimise things
  for our users because there are so many more of them than there
  are of us."

That seems quite clear that we should be using dependencies to
properly describe the real system layout, and not offer up
useless stuff.  It is unclear to me how anyone could  interpret
it any different way -- i.e. GOLDFISH_POWER should depend on
GOLDFISH, just like the other GOLDFISH_XYZ options do now.

> (re)build the kernel is assumed to be knowledgeable enough to figure out
> what needed/unneeded for the given HW. I, for example, use 'ARCH=foo

This is another problem though -- as mentioned at kernel summit,
more people testing newer kernels is desired, but the barrier to entry
seems too high, and one of those barriers is Kconfig complexity.
Assuming everybody is "knowledgeable enough" does not match
reality.

Paul.
--

> allnoconfig' for stripped kernels, and then enable specific options which
> I know I will need. Distros, however, they are using kind of
> 'allmodconfig' anyways:
>
>         ~$ du -sh /lib/modules/3.8.0-28-desktop/
>         148M    /lib/modules/3.8.0-28-desktop/
>
> One module less, one module more does not matter, but maintaining
> CONFIG_AKPM will cost devs' time and efforts (especially figuring out what
> is platform dep and what is not... I think it is easier to just keep
> things simple.
>
> But again, I won't be against it -- at least it doesn't make my life
> harder. :-)
>
> Cheers,
>
> Anton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
