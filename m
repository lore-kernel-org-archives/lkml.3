Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaKEAVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:21:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaKEAVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:21:49 -0500
Date: Wed, 5 Nov 2014 01:21:47 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
	backport with BPAUTO
Message-ID: <20141105002147.GJ12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com> <1415096092.2064.13.camel@sipsolutions.net> <20141104215002.GF12953@wotan.suse.de> <1415137850.2064.23.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415137850.2064.23.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:50:50PM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 22:50 +0100, Luis R. Rodriguez wrote:
> > On Tue, Nov 04, 2014 at 11:14:52AM +0100, Johannes Berg wrote:
> > > On Tue, 2014-11-04 at 00:43 -0800, Luis R. Rodriguez wrote:
> > > 
> > > > -            mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > > > +            if bp_prefix not in sym:
> > > > +                mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > > > +            else:
> > > > +                mf.write('compat-$(%s) += %s\n' % (sym, ' '.join(o_files)))
> > > 
> > > I don't think these changes are correct, the bp_prefix is needed anyway,
> > > and there's no way it could already be. Looks like this comes from a
> > > previous attempt where you misunderstood and thought
> > > CONFIG_BACKPORT_BACKPORT_... was actually wrong, when in fact it is
> > > correct (and would now be CONFIG_BACKPORT_BPAUTO_...)
> > 
> > I did at one point have BACKPORT_BPAUTO_* stuff on the compat/Kconfig for
> > the auto stuff but figured that was superfluous. I'll respin with it.
> 
> Not sure what you mean? It seems to me you should just drop the changes
> like the one I quoted above.

If we keep BACKPORT_BPAUTO as prefix on compat/Kconfig for auto backport
stuff we'll end up with BACKPORT_BACKPORT_BPAUTO, while technically correct
as you have pointed out, I find it personally superfluous. If we however
only use BPAUTO_ prefix on the compat/Kconfig we'll end up with BACKPORT_BPAUTO.
Its subjective then, but I was opting in to prefer to just keep BPAUTO_ prefix
with the resulting CPTCFG_BPAUTO for packaging and CONFIG_BACKPORT_BPAUTO for
integration for these, if you however feel its best to double the BACKPORT
prefix that's fine too, it just seemed odd (although I realize correct).

To do what I just described I think you're right will try removing that,
testing that now. The other case that I ran into issues was the backport
versioning variables but I have solved that through other non intrusive means
to packaging (just use the C define with CPTCFG_ prefix, keeping the original
Makefile variables) which will be part of my next respin.

We still do need to decide if we want double BACKPORT_ prefix for BPAUTO
though, that remains subjective and I don't feel strongly about any way
we go.

  Luis
