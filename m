Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3GJUq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:46:56 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64464 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3GJUqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:46:54 -0400
Date: Wed, 10 Jul 2013 22:46:48 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
Message-ID: <20130710204648.GE3297@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
 <1373282357.4298.198.camel@chaos.site>
 <20130708173535.GB3206@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130708173535.GB3206@free.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-07-08 19:35 +0200, Yann E. MORIN spake thusly:
> On 2013-07-08 13:19 +0200, Jean Delvare spake thusly:
> > Le Monday 24 June 2013 à 20:11 +0200, Yann E. MORIN a écrit :
> > > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> [--SNIP--]
> > > Since the search can be a regexp, it is possible that more than one symbol
> > > matches exactly. In this case, we can't decide which to sort first, so we
> > > fallback to alphabeticall sort.
[--SNIP--]
> > > Reported-by: Jean Delvare <jdelvare@suse.de>
> > > Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > > Cc: Jean Delvare <jdelvare@suse.de>
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Cc: Roland Eggner <edvx1@systemanalysen.net>
> > > Cc: Wang YanQing <udknight@gmail.com>
> > 
> > I tested it and it works fine, thanks!
> > 
> > Tested-by: Jean Delvare <jdelvare@suse.de>
> > 
> > Now comes my late review. Overall I like the idea and the code but a few
> > things could be improved:
> 
> Since this is already in Michal's tree, on should I proceed?
>   - send an updated patch that replaces that one, or
>   - send another additional patch with your proposed changes?

OK, since Michal already sent his pull-request to Linus, I'll prepare a
corrective patch I'll submit before the end of the week. Is that OK with
you, Michal?

[--SNIP--]
> > > +static int sym_rel_comp( const void *sym1, const void *sym2 )
> > > +{
> > > +	struct sym_match *s1 = *(struct sym_match **)sym1;
> > > +	struct sym_match *s2 = *(struct sym_match **)sym2;
> > 
> > You shouldn't need these casts.
> 
> Probably not, indeed, but I like to write (and read) what I expect to
> happen, and pointer arithmetics is always something I dread to foobar.

In fact, we need the cast, otherwise gcc whines about const/non-const.

[--SNIP--]
> > >  	for_all_symbols(i, sym) {
> > > +		struct sym_match *tmp_sym_match;
> > >  		if (sym->flags & SYMBOL_CONST || !sym->name)
> > >  			continue;
> > > -		if (regexec(&re, sym->name, 0, NULL, 0))
> > > +		if (regexec(&re, sym->name, 1, match, 0))
> > >  			continue;
> > >  		if (cnt + 1 >= size) {
> > 
> > I think the "+ 1" can be dropped because the new array is not
> > NULL-terminated.

Indeed.

> > > +			sym_match_arr = tmp;
> > >  		}
> > >  		sym_calc_value(sym);
> > > -		sym_arr[cnt++] = sym;
> > > +		tmp_sym_match = (struct sym_match*)malloc(sizeof(struct sym_match));
> > 
> > Cast not needed.
> 
> OK.
> 
> > In fact I don't think this allocation is needed in the first place.
> > Calling malloc for every match is rather costly. If you would have
> > allocated an array of struct sym_match (rather than only pointers
> > thereto) before, you would not need this per-symbol malloc. Struct
> > sym_match is small enough to not warrant an extra level of allocation
> > and indirection IMHO.

Indeed, it makes for cleaner code.

Thank you again! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
