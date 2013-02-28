Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3B1CRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 21:17:40 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61145 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3B1CRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 21:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130228013514.GA7556@lizard.fhda.edu>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu> <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
 <20130228013514.GA7556@lizard.fhda.edu>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 27 Feb 2013 21:17:06 -0500
X-Google-Sender-Auth: dIcaHXKYOP_--gK0Mg0ylSHeTfc
Message-ID: <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 8:35 PM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Wed, Feb 27, 2013 at 07:48:38PM -0500, Paul Gortmaker wrote:
> [...]
>> If you don't want to take the commit, I won't argue it any further, but
>> I genuinely do hope the above logical arguments perhaps might cause
>> you to  change your mind.
>
> As a maintainer of drivers/power/, I have to keep things in a sane state,
> which means, that I want to compile-test the patches that I am merging.

As you should, and nobody will fault you for that objective.

>
> Testing patches takes time, and if I have to do it for all bunch of
> different machines and architectures, it becomes mess and unmanageable. In

So, you actually want my change then -- you do not want to test for
goldfish power issues unless goldfish is selected.  This is how I see
the situation.

> another words, it is easier for me to use as little different
> setups/.configs/cross-compilers/trees/etc as possible.
>
> For example, here is the scenario:
>
> - someone sends me a patch for goldfish driver;
> - I quickly compile it on my [underpowered] x86 laptop without need for
>   cross-compilation and special configs;
> - It compiles fine, produces no warnings, so I happily send out the
>   'Applied, thanks!' email;

I can not see how the above is at all relevant.  If someone sends you a
patch for ARCH != x86, then your workflow will fail, regardless of what
actually is within the patch.  As a maintainer, you need to be able to
handle cross compiles -- you can't escape the slightly more detailed
testing requirements we need to get from subsystem maintainers.  There
are cross compile capable toolchains on kernel.org, and I use them
regularly before sending out changes that can impact multiple arch.

ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/

We can forgive individual contributors for not being arch aware, but
at the subsystem maintainer level, folks should be arch aware, and
doing regular x-compiles.

> Now, with your patch:
>
> - Someone sends me a patch for goldfish driver;
> - I starting to look for my cross-compilers collections, making all the
>   environment setups, setting up a new build tree, looking for the
>   outdated goldfish config, the ARM thing fails to build somewhere in
>   arch/arm/plat-foo and drivers/mfd/bar. I become grumpy... and, you might
>   not believe me, I open and edit drivers/power/Kconfig and remove

I am confused here.  If there are correct depends lines here in the Kconfig,
then it _protects_ you from suffering like this.  Yet, you want me to think
that it adds new work, new cross compile requirements and so on.  I do
not see how that can possibly happen.

>   needless 'depends on' (that is, I actually do these kind of things when
>   I feel lazy enough).
>
> Do you agree that without the additional deps life is easier for me? :)

No, I do not agree.  In fact I see it as totally the opposite.  But I already
said that I would not pursue this further, based only on differing points
of view, and so, after sending this, I will adhere to that now.

> If so, please do help me and the rest of the maintainers: instead of
> adding the unneeded deps, for consistency just remove those which are not
> needed.

I think what I sent matches the above criteria.  If you still are convinced
that I am incorrect in this regard, then I hope you can point to explicit
specifics that can convince me I am wrong.  At the moment I do not
see anything to convince me that is the case.  We are expanding work
for maintainers, testers, and people doing build coverage for no return
whatsoever, including yourself.

Thanks,
Paul.
--

>
> Thanks,
>
> Anton
>
> p.s. Quick answers for the rest of your arguments:
>
>> The linux-next compile queue as it is today barely gets completed within
>>  a 24h window.
>
> So, it is large enough already, and nothing we can do about it, things are
> growing. But the good news is that no human attention is needed to compile
> things. That is what machines are for. :)
>
>> --why shouldn't we restrict the maintenance overhead of CONFIG_FOO
>> to people who really do care about supporting and testing and updating
>> features conditional on CONFIG_FOO?  Given the size of the kernel
>> today, this seems to make sense in terms of developer "load balancing".
>
> You don't have to enable/fix everything. Some things become broken, so
> just disable them for the time being. But when people stumble upon broken
> drivers, the drivers are either get fixed, or removed (if no one wants to
> fix it). Sweeping drivers under 'depends on' doesn't do anything good in
> this regard, IMO.
>
> If we notice that goldfish is broken for long time and nobody cares to fix
> it, then it is a good time to think about its removal. Since goldfish has
> nothing goldfish-specific, it can be broeken only in a generic way, so if
> it is broken on x86, it is as well broken for ARM.
>
>> If you don't want to take the commit, I won't argue it any further
>
> I don't want to take it for a reason, but I do care whether my reasons
> make sense to you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
