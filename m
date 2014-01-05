Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaAEPsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 10:48:36 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:35333 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaAEPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 10:48:35 -0500
Date: Sun, 5 Jan 2014 16:48:29 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How does a newbie find work?
Message-ID: <20140105164829.5dbc2d45@neptune.home>
In-Reply-To: <CAPNrq4xKgwZjGHNJYnDVKtHRAusOpzFzk1ML-gmuNOSUovD66g@mail.gmail.com>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
	<20140104213654.0f0b34f2@neptune.home>
	<CAMuHMdXU3TGfLec3H6JqLv4yrUVzHN-POMRMBEJvi9-KvBu1mw@mail.gmail.com>
	<CAPNrq4xKgwZjGHNJYnDVKtHRAusOpzFzk1ML-gmuNOSUovD66g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 January 2014 "Gideon D'souza" wrote:
> Thanks so much Geert and Bruno for your replies:
> 
> 
> >>don't forget to subscribe to the specific mailing lists!
> Didn't know about this, this link is the right one?
> http://vger.kernel.org/vger-lists.html#cpufreq There isn't a list for
> the scheduler though?

Those are just the mailing lists running on vger, there are others,
you should find the right ones looking at MAINTAINERS at the root of kernel
sources (will tell you where to send mail regarding given source files,
alternatively feed path of source file to scripts/get_maintainer.pl).

> >A better start, and at least as useful is to read and review patches flowing
> > by that affect your areas of interest, test them and
> > provide feedback about possible bugs or improvements
> This is a really good idea, so far though all the patches to me look a
> little arcane, for things I barely understand. But I will keep
> looking. If I do find something, lets say a patch to the scheduler or
> some networking thing, how do you guys really test this out? How to
> you debug a scheduler? :/ How do I really "See" the system run? Put
> printk statements here are there?

There are better tools than printk(), e.g. perf, trace and similar but others
are better informed on those than I am!
printk() is useful when some specifics are needed and kgdb is overkill.

Testing if a patch works as expected is a fuzzy subject! On one hand you
need to understand what the patch does (or should do) before you can
check if it works. But just checking that it doesn't break things (for
your config/setup) can be a first step - if it breaks for you that's an
opportunity for further analysis and feedback (break can mean kernel
crash, OOPS, BUG/WARN trace or maybe just a noticeable slowdown).

Reading through some debugging threads on the mailing lists may give you
some ideas or insights and suggestions.

> >E.g. one thing I just noticed: while include/linux/compiler-gcc.h provides
> >shorthands (e.g. "__printf()") for various gcc __attribute__ macros, there
> >are still many places that don't use the shorthands, cfr. e.g.
> >"git grep 'attribute.*printf'".
> Are trivial patches like this really accepted?

Trivial patches are accepted (handled by Jiri Kosina) but I would say the
attribute macros suggested by Geert are not trivial at all!
Have a look at patches including trivial in their subject or sent to
trivial@kernel.org to get a feeling for the trivial patches, but also
have a look at Documentation/Submit* files (and all the rest in there).

Regards,
Bruno
