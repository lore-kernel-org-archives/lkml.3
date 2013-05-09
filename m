Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3EIQMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:12:41 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63575 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3EIQMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:12:40 -0400
Date: Thu, 9 May 2013 18:12:17 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Wang YanQing <udknight@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v3] kconfig: sort found symbols by relevance
Message-ID: <20130509161217.GA2948@free.fr>
References: <1367826629.4494.30.camel@chaos.site>
 <1367874931-6251-1-git-send-email-yann.morin.1998@free.fr>
 <20130509152731.GA3355@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130509152731.GA3355@udknight>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Thu, May 09, 2013 at 11:27:31PM +0800, Wang YanQing wrote:
> On Mon, May 06, 2013 at 11:15:31PM +0200, Yann E. MORIN wrote:
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > When searching for symbols, return the symbols sorted by relevance.
> > 
> > Sorting is done as thus:
> >   - first, symbols with a prompt,   [1]
> >   - then, smallest offset,          [2]
> >   - then, shortest match,           [3]
> >   - then, highest relative match,   [4]
> >   - finally, alphabetical sort      [5]
> > 
> > So, searching (eg.) for 'P.*CI' :
> > 
> > [1] Symbols of interest are probably those with a prompt, as they can be
> >     changed, while symbols with no prompt are only for info. Thus:
> >         PCIEASPM comes before PCI_ATS
> 
> Search the value of symbols with no prompt are useful too

My reasonning here is that often I need to toggle a symbol, but am not
sure what menu it's in, so I search for it.

Sometime, I also need to search for prompt-less symbols, too, to see why
a symbol I want is not visible. But that's not the most common use-case.

Also, the examples provided were with a very verbose search: 'P.*CI'
which is expected to return a hell of a lot of symbols. More precise
searches will yield substancially fewer symbols, so the search results
will probably fit in 1 or 2 pages, not 10+ like 'P.*CI'

> > [2] Symbols that match earlier in the name are to be preferred over
> >     symbols which match later. Thus:
> >         PCI_MSI comes before WDTPCI
> 
> We can achieve this with ^PCI regular search

Yes, but I expect users do enter the begining of symbols, not a string
in the middle or at the end.

Also, as Jean and Thomas have proven, not many people know that searches
can be regular expressions.

> > [3] The shortest match is (IMHO) more interesting than a longer one.
> >     Thus:
> >         PCI comes before PCMCIA
> 
> We can achieve this with ^PCI regular search plus your previous heuristic

This one is not about location of the match, it's about the length of
the match: the shortest the match, the more interesting it is (IMHO). So
we'd prefer FOO_PCI_BAR_BUZ over A_PACI_B  (when searching for 'P.*CI').

> > [4] The relative match is the ratio of the length of the match against
> >     the length of the symbol. The more of a symbol name we match, the
> >     more instersting that symbol is. Thus:
> >         PCIEAER comes before PCIEASPM
> 
> This is what your first heuristic
> 
> > [5] As fallback, sort symbols alphabetically
> This is in your first heuristic too.
> 
> > This heuristic tries hard to get interesting symbols first in the list.
> I don't mean your this heuristic is bad, but

This heuristic is just that: a heuristic. It kicks in only if the user
dit not provide an anchored regexp (ie with start- or end-of-line).

For the ten-or-so tests I did, the sorting was rather appropriate,
though that's only ten-or-so tests and is not exhaustive (and probably
subject to testing bias, too).

What I'm trying to achieve here is come up with a way to sort symbols
for searches of *non-anchored* regexps. Anchored regexps will always
provide the results they used to provide so far.

Maybe we can emphasize in the UI the fact that regexps, and especially
anchored regexps, can be used.

> maybe provide mechanism to user will make guesser life easier.

Sorry, I can't make sense of this sentence. :-( Can you elaborate a bit
what you meant, please?

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
