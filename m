Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaKCTkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:40:21 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:48363 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaKCTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:40:19 -0500
Message-ID: <1415043615.2726.4.camel@sipsolutions.net>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for
 CONFIG_BACKPORT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Date: Mon, 03 Nov 2014 20:40:15 +0100
In-Reply-To: <CAB=NE6U7-TE9Oe_aTvjr4Y1iGALMeRohmx-ekbzmRuzAbbqTTA@mail.gmail.com> (sfid-20141103_203035_104913_5BEC1A98)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
	 <1414741273.3014.3.camel@jlt4.sipsolutions.net>
	 <20141031193408.GA12953@wotan.suse.de>
	 <1414786943.3014.37.camel@jlt4.sipsolutions.net>
	 <CAB=NE6UVca47FyZv54pED3C_1go+-Ra_AbSwW1+=Gj5YWP0GHw@mail.gmail.com>
	 <CAB=NE6U7-TE9Oe_aTvjr4Y1iGALMeRohmx-ekbzmRuzAbbqTTA@mail.gmail.com>
	 (sfid-20141103_203035_104913_5BEC1A98)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 11:30 -0800, Luis R. Rodriguez wrote:
> On Fri, Oct 31, 2014 at 1:33 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> That also makes me think of something else - we currently use BACKPORT_
> >> as a prefix for some of the other stuff under compat/Kconfig, and in
> >> fact rename some things (like CONFIG_BACKPORT_AVERAGE) so maybe also
> >> using CONFIG_BACKPORT_ here isn't a great idea? Might want to use
> >> something else, say CONFIG_BPT_ or so.
> >
> > That's a good point, I take it that it does not matter which one we
> > pick for each, so long as its different? If so I think CONFIG_BACKPORT
> > is pretty clear for things we carry over like device drivers, but this
> > is just subjective and so long as we pick something I think it'll be
> > fine.
> 
> Thought about this some more, the stuff under compat/ is just
> backported through a slightly different strategy -- the Kconfig
> copy-file stuff but yet its very similar to the copy-list mechanism,
> where it ends up is different but I am not sure if it makes sense to
> keep a different naming scheme for each backport strategy.

Yes, but the stuff under compat/ is also treated specially by the
scripting - config symbols there automatically replace the ones in the
rest of the tree for example (see "config AVERAGE" for example, you get
"depends on BACKPORT_AVERAGE" and some BUILD_PACKPORT_AVERAGE magic)

johannes

