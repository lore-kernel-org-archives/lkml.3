Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3EZNw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab3EZNwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:52:55 -0400
Date: Sun, 26 May 2013 10:52:37 -0300
From: Rafael Aquini <aquini@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, shli@kernel.org, kzak@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, "riel@redhat.com" <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 01/02] swap: discard while swapping only if
 SWAP_FLAG_DISCARD_PAGES
Message-ID: <20130526135237.GA2333@x61.redhat.com>
References: <cover.1369529143.git.aquini@redhat.com>
 <537407790857e8a5d4db5fb294a909a61be29687.1369529143.git.aquini@redhat.com>
 <CAHGf_=qU5nBeya=God5AyG2szvtJJCDd4VOt0TJZBgiEX27Njw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=qU5nBeya=God5AyG2szvtJJCDd4VOt0TJZBgiEX27Njw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 07:44:56AM -0400, KOSAKI Motohiro wrote:
> > +                       /*
> > +                        * By flagging sys_swapon, a sysadmin can tell us to
> > +                        * either do sinle-time area discards only, or to just
> > +                        * perform discards for released swap page-clusters.
> > +                        * Now it's time to adjust the p->flags accordingly.
> > +                        */
> > +                       if (swap_flags & SWAP_FLAG_DISCARD_ONCE)
> > +                               p->flags &= ~SWP_PAGE_DISCARD;
> > +                       else if (swap_flags & SWAP_FLAG_DISCARD_PAGES)
> > +                               p->flags &= ~SWP_AREA_DISCARD;
> 
> When using old swapon(8), this code turn off both flags, right?

As the flag that enables swap discards SWAP_FLAG_DISCARD remains meaning the
same it meant before, when using old swapon(8) (SWP_PAGE_DISCARD|SWP_AREA_DISCARD)
will remain flagged when discard is enabled, so we keep doing discards the same way 
we did before (at swapon, and for every released page-cluster). 
The flags are removed orthogonally only when the new swapon(8) selects one of the
particular discard policy available by using either SWAP_FLAG_DISCARD_ONCE,
or SWAP_FLAG_DISCARD_PAGES flags.

