Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab3GMNG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 09:06:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33823 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3GMNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 09:06:57 -0400
Date: Sat, 13 Jul 2013 15:06:51 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH 12/15] kconfig: sort found symbols by relevance
Message-ID: <20130713130651.GB3280@free.fr>
References: <cover.1372097219.git.yann.morin.1998@free.fr>
 <193b40aeb537b59eaa36e3dfaabedc2025332ebf.1372097219.git.yann.morin.1998@free.fr>
 <1373282357.4298.198.camel@chaos.site>
 <20130708173535.GB3206@free.fr>
 <20130710204648.GE3297@free.fr>
 <1373620065.4410.25.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1373620065.4410.25.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, All,

On 2013-07-12 11:07 +0200, Jean Delvare spake thusly:
[--SNIP--]
> > > > > +static int sym_rel_comp( const void *sym1, const void *sym2 )
> > > > > +{
> > > > > +	struct sym_match *s1 = *(struct sym_match **)sym1;
> > > > > +	struct sym_match *s2 = *(struct sym_match **)sym2;
> > > > 
> > > > You shouldn't need these casts.
> > > 
> > > Probably not, indeed, but I like to write (and read) what I expect to
> > > happen, and pointer arithmetics is always something I dread to foobar.
> > 
> > In fact, we need the cast, otherwise gcc whines about const/non-const.
> 
> And quite rightly so, as you are taking const pointers (i.e. the caller
> told you you are _not_ allowed to change the contents) and making them
> non-const pointers (i.e. you give yourself the right to still change the
> contents.) It happens that your function doesn't actually change the
> contents, so no harm done, but this is still conceptually wrong.
> Preserving the const nature of pointers down the call chain lets the
> compiler warn you if a function changes data it was not supposed to.
> 
> So what you want to do is:
> 
> static int sym_rel_comp(const void *sym1, const void *sym2)
> {
> 	const struct sym_match *s1 = sym1;
> 	const struct sym_match *s2 = sym2; 
> 
> This is both concise and correct, and it makes gcc happy.

Yes, that's what I thought to, and what I was about to do. Thanks for
confirming this! :-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
