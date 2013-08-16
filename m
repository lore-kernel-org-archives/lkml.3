Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3HPROz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:14:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39348 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3HPROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:14:50 -0400
Date: Fri, 16 Aug 2013 19:14:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-ID: <20130816171448.GA13841@merkur.ravnborg.org>
References: <CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com> <20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au> <87zjsted0c.fsf@linaro.org> <20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au> <20130808103614.a039da2f236154b52329b28b@canb.auug.org.au> <20130808191650.GB3282@free.fr> <20130808215449.GD3282@free.fr> <20130809114248.GA5691@merkur.ravnborg.org> <20130811213923.GA5312@free.fr> <520E24CE.9040604@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E24CE.9040604@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:10:38PM +0200, Michal Marek wrote:
> On 11.8.2013 23:39, Yann E. MORIN wrote:
> > On 2013-08-09 13:42 +0200, Sam Ravnborg spake thusly:
> >> If we drop the special handling of "MODULES" and introduced
> >> the following in we may fix it - hopefully:
> >>
> >> config MODULES
> >> 	option modules
> >>
> >> The option handling is already in place. It is even documented :-)
> > 
> > Yes, indeed, that one is pretty easy! :-)
> > 
> >> At least we could then drop the sym_lookup here (zconf.y):
> >>         if (!modules_sym->prop) {
> >>                 struct property *prop;
> >>
> >>                 prop = prop_alloc(P_DEFAULT, modules_sym);
> >>                 prop->expr = expr_alloc_symbol(sym_lookup("MODULES", 0));
> >>         }
> >> Without the sym_lookup I think the symbol will not be defined and tus not marked valid.
> > 
> > Sorry, I don't understand what we should do here.
> > 
> > From what I understand, here's what happens:
> >   - there's no symbol that declared the 'modules' option, so the
> >     modules_sym->prop is NULL;
> >   - so we look for the symbol 'MODULES' and use that as the symbol used
> >     to evaluate if tristates are enabled.
> > 
> > So, now we have 'option modules' added to MODULES, we never enter this
> > if() condition.
> > 
> > But what would happen to other projects that do not have a symbol set
> > with 'option modules' and no 'MODULES' symbol? Surely, those projects do
> > not need tristates, but what should the code do in this case?
> > 
> > So, I don't know what to replace this 'sym_lookup("MODULES", 0)' with.
> 
> If the Kconfig files do not provide any symbol with 'option modules',
> then set modules_sym to a dummy bool with the value 'n'?
This is my thinking too - to use the symbol "n".
But I wanted to try it out - but so far have not had time for it.

	Sam
