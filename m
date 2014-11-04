Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaKDVu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:50:57 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:55800 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaKDVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:50:55 -0500
Message-ID: <1415137850.2064.23.camel@sipsolutions.net>
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
 backport with BPAUTO
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Tue, 04 Nov 2014 22:50:50 +0100
In-Reply-To: <20141104215002.GF12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com>
	 <1415096092.2064.13.camel@sipsolutions.net>
	 <20141104215002.GF12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 22:50 +0100, Luis R. Rodriguez wrote:
> On Tue, Nov 04, 2014 at 11:14:52AM +0100, Johannes Berg wrote:
> > On Tue, 2014-11-04 at 00:43 -0800, Luis R. Rodriguez wrote:
> > 
> > > -            mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > > +            if bp_prefix not in sym:
> > > +                mf.write('compat-$(%s%s) += %s\n' % (bp_prefix, sym, ' '.join(o_files)))
> > > +            else:
> > > +                mf.write('compat-$(%s) += %s\n' % (sym, ' '.join(o_files)))
> > 
> > I don't think these changes are correct, the bp_prefix is needed anyway,
> > and there's no way it could already be. Looks like this comes from a
> > previous attempt where you misunderstood and thought
> > CONFIG_BACKPORT_BACKPORT_... was actually wrong, when in fact it is
> > correct (and would now be CONFIG_BACKPORT_BPAUTO_...)
> 
> I did at one point have BACKPORT_BPAUTO_* stuff on the compat/Kconfig for
> the auto stuff but figured that was superfluous. I'll respin with it.

Not sure what you mean? It seems to me you should just drop the changes
like the one I quoted above.

johannes

