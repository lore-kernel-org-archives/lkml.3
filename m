Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKDVuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:50:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKDVuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:50:07 -0500
Date: Tue, 4 Nov 2014 22:50:02 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
	backport with BPAUTO
Message-ID: <20141104215002.GF12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com> <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com> <1415096092.2064.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415096092.2064.13.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:14:52AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 00:43 -0800, Luis R. Rodriguez wrote:
> 
> > -            mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > +            if bp_prefix not in sym:
> > +                mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > +            else:
> > +                mf.write('compat-$(%s) += %s\n' % (sym, ' '.join(o_files)))
> 
> I don't think these changes are correct, the bp_prefix is needed anyway,
> and there's no way it could already be. Looks like this comes from a
> previous attempt where you misunderstood and thought
> CONFIG_BACKPORT_BACKPORT_... was actually wrong, when in fact it is
> correct (and would now be CONFIG_BACKPORT_BPAUTO_...)

I did at one point have BACKPORT_BPAUTO_* stuff on the compat/Kconfig for
the auto stuff but figured that was superfluous. I'll respin with it.

  Luis
