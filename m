Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3CIWDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 17:03:42 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41568 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3CIWDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 17:03:41 -0500
Date: Sat, 9 Mar 2013 13:59:48 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Message-ID: <20130309215946.GA8386@lizard>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu>
 <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
 <20130228013514.GA7556@lizard.fhda.edu>
 <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
 <20130228025931.GA13764@lizard.gateway.2wire.net>
 <513A1411.7060403@windriver.com>
 <20130309011809.GA4028@lizard.sbx05280.losalca.wayport.net>
 <CAP=VYLpxZzi6OFpDjJaR2EVcgmS4EcoAAk5wSzjrbi+QSfaEWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP=VYLpxZzi6OFpDjJaR2EVcgmS4EcoAAk5wSzjrbi+QSfaEWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:49:08AM -0500, Paul Gortmaker wrote:
[...]
> >> I didn't send the patch to akpm, but I did have a chance to ask akpm how
> >> dependencies should be used, and you can see his answer here:
> >>
> >>       https://lkml.org/lkml/2013/3/7/456
> >
> > Thanks for asking! FWIW, I won't be against CONFIG_AKPM. ;-) Something
> > like that will work:
> >
> >         depends on GENERIC_HARDIRQS
> >         depends on RESTRICT_PLATFORM && GOLDFISH
> >
> > But not that I think we really need this option, though. Whoever wants to
> 
> Of course, it was only meant sarcastically, but the CONFIG_AKPM
> joke wasn't the important part of the email discussion though.
> 
> Above,  you asked "If Andrew agrees [that dependencies should describe
> the hardware/platform] ... I will start applying such patches in future."
> 
> The important bit is Andrew's answer to your question:
> 
>   "...offering useless stuff to non-kernel-developers has downsides
>   with no balancing benefit, and we really should optimise things
>   for our users because there are so many more of them than there
>   are of us."

To me, the important bit was "drives me bats when I merge a patch but have
to jump through a series of hoops ..."

And "we really should optimise things" does not mean that your patch is an
ideal solution. You make users' life a bit easier (maybe), but miserable
for me. As I read Andrew, a better solution have to be implemented (e.g.
CONFIG_AKPM, which I didn't find being too sarcastic :-), which would suit
both users and maintainers.

Btw, I am a Linux user too. And the amount of Kconfig symbols never ever
bothered me personally. Why? Look:

	~$ grep CONFIG /boot/config-3.8.0-28-desktop  | wc -l
	5274

Do you think that even if you divide this by two it would make any
difference? Not to me. When dealing with these large sets of options, my
strategy of making configs is different (as I explained previous emails it
is either '{old,allmod}config'+tuning or 'allnoconfig'+deliberately
enabling options for specific hardware/needs.

Don't take it personally, but for me the patch does not do anything good
at all. And again, feel free to send it to akpm with my nack and a link,
since I might be still wrong.

Cheers,

Anton
