Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3B1BjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:39:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45281 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3B1BjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:39:02 -0500
Date: Wed, 27 Feb 2013 17:35:14 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Message-ID: <20130228013514.GA7556@lizard.fhda.edu>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu>
 <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 07:48:38PM -0500, Paul Gortmaker wrote:
[...]
> If you don't want to take the commit, I won't argue it any further, but
> I genuinely do hope the above logical arguments perhaps might cause
> you to  change your mind.

As a maintainer of drivers/power/, I have to keep things in a sane state,
which means, that I want to compile-test the patches that I am merging.

Testing patches takes time, and if I have to do it for all bunch of
different machines and architectures, it becomes mess and unmanageable. In
another words, it is easier for me to use as little different
setups/.configs/cross-compilers/trees/etc as possible.

For example, here is the scenario:

- someone sends me a patch for goldfish driver;
- I quickly compile it on my [underpowered] x86 laptop without need for
  cross-compilation and special configs;
- It compiles fine, produces no warnings, so I happily send out the
  'Applied, thanks!' email;

Now, with your patch:

- Someone sends me a patch for goldfish driver;
- I starting to look for my cross-compilers collections, making all the
  environment setups, setting up a new build tree, looking for the
  outdated goldfish config, the ARM thing fails to build somewhere in
  arch/arm/plat-foo and drivers/mfd/bar. I become grumpy... and, you might
  not believe me, I open and edit drivers/power/Kconfig and remove
  needless 'depends on' (that is, I actually do these kind of things when
  I feel lazy enough).

Do you agree that without the additional deps life is easier for me? :)

If so, please do help me and the rest of the maintainers: instead of
adding the unneeded deps, for consistency just remove those which are not
needed.

Thanks,

Anton

p.s. Quick answers for the rest of your arguments:

> The linux-next compile queue as it is today barely gets completed within
>  a 24h window.

So, it is large enough already, and nothing we can do about it, things are
growing. But the good news is that no human attention is needed to compile
things. That is what machines are for. :)

> --why shouldn't we restrict the maintenance overhead of CONFIG_FOO
> to people who really do care about supporting and testing and updating
> features conditional on CONFIG_FOO?  Given the size of the kernel
> today, this seems to make sense in terms of developer "load balancing".

You don't have to enable/fix everything. Some things become broken, so
just disable them for the time being. But when people stumble upon broken
drivers, the drivers are either get fixed, or removed (if no one wants to
fix it). Sweeping drivers under 'depends on' doesn't do anything good in
this regard, IMO.

If we notice that goldfish is broken for long time and nobody cares to fix
it, then it is a good time to think about its removal. Since goldfish has
nothing goldfish-specific, it can be broeken only in a generic way, so if
it is broken on x86, it is as well broken for ARM.

> If you don't want to take the commit, I won't argue it any further

I don't want to take it for a reason, but I do care whether my reasons
make sense to you.
