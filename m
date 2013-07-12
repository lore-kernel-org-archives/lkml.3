Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab3GLI6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:58:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab3GLI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:58:06 -0400
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
In-Reply-To: <20130708173535.GB3206@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
	 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
	 <1373282357.4298.198.camel@chaos.site>  <20130708173535.GB3206@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 12 Jul 2013 10:57:48 +0200
Message-ID: <1373619468.4410.19.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yann,

Sorry again for the late reply, busy...

Le Monday 08 July 2013 à 19:35 +0200, Yann E. MORIN a écrit :
> On 2013-07-08 13:19 +0200, Jean Delvare spake thusly:
> > This is more concise and easier to grasp, methinks. I don't think the
> > reference to the user's locale is needed, as there's no surprise here,
> > and it probably doesn't matter anyway for kernel symbols.
> 
> Yes it may matter even for kernel symbols, since some locales may
> consider '_' as a character to sort by, while other locales may not.

I didn't know that, thanks for the information. That being said I still
believe mentioning the user's locale is not needed ;-)

> > BTW I was wondering if it would add value to explicitly print group
> > header labels "Exact matches" and "Other matches" in the search results.
> > What do you think?
> 
> It is not trivial to do, since the search function only returns a single
> array, so there's no way for frontends (which do the display) to
> differentiate which part of the array are exact matches, and which are
> only partial matches.
> 
> It is much more involved, and I don't think it would be easy to
> implement.

I understand, and I agree it's not worth the effort.

> > > +{
> > > +	struct sym_match *s1 = *(struct sym_match **)sym1;
> > > +	struct sym_match *s2 = *(struct sym_match **)sym2;
> > 
> > You shouldn't need these casts.
> 
> Probably not, indeed, but I like to write (and read) what I expect to
> happen, and pointer arithmetics is always something I dread to foobar.

I hear this argument every now and then but I do not think it holds. If
you always forcibly cast pointers even when you don't have to, then gcc
has no chance to warn you if you get it wrong.

More on this later as I reply to your next post...

> > It might be even faster to store the symbol length in struct sym_match,
> > but this would increase the structure size and consequently memory
> > consumption, and it is questionable if the speed gain is worth it.
> > Probably not.
> 
> I intended this structure to only hold the result of the regexp match,
> and nothing more. The symbol length does not belong there, IMHO.
> Besides, it's easy to get back, since the symbol struct is available.
> 
> OTOH, we would gain by computing strlen at regexp match, instead of
> every time in the sorting function.
> 
> But that's micro-optimisation, methinks. Searching for the example
> ^ATH.K took less than me focusing from the RETURN key to the screen. ;-)

OK, fair enough. I always pay attention to algorithmic complexity
because not everyone is running brand new and powerful machines (I am
not, to start with.)

I agree that the number of items returned by the search should generally
be small enough so it shouldn't be an issue in practice. If you want to
test your code on extreme cases though, you could search for "A" or even
".". It takes about 20 seconds for "A" on my machine and close to 1
minute for ".", which is quite slow. That being said that was already
the case before your patch, so I'm not blaming your changes for it.

> (...)
> Thank you for the review! :-)

You're welcome :-)

-- 
Jean Delvare
Suse L3

