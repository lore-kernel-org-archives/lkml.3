Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3APRxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:53:01 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62908 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752576Ab3APRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:52:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19d1OePLPXwrFHurwwAt8iIGol5jYVULBU=
Date: Wed, 16 Jan 2013 12:52:03 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Soeren Moch <smoch@web.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment
Message-ID: <20130116175203.GK25500@titan.lakedaemon.net>
References: <20130115165642.GA25500@titan.lakedaemon.net>
 <20130115175020.GA3764@kroah.com>
 <20130115201617.GC25500@titan.lakedaemon.net>
 <20130115215602.GF25500@titan.lakedaemon.net>
 <50F5F1B7.3040201@web.de>
 <20130116024014.GH25500@titan.lakedaemon.net>
 <50F61D86.4020801@web.de>
 <50F66B1B.40301@web.de>
 <20130116155045.GI25500@titan.lakedaemon.net>
 <50F6DDF7.9080605@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F6DDF7.9080605@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:05:59PM +0100, Soeren Moch wrote:
> On 16.01.2013 16:50, Jason Cooper wrote:
> >On Wed, Jan 16, 2013 at 09:55:55AM +0100, Soeren Moch wrote:
> >>On 16.01.2013 04:24, Soeren Moch wrote:
> >>>On 16.01.2013 03:40, Jason Cooper wrote:
> >>>>On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
> >>>>>On 15.01.2013 22:56, Jason Cooper wrote:
> >>>>>>On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
> >
> >>OK, I could trigger the error
> >>   ERROR: 1024 KiB atomic DMA coherent pool is too small!
> >>   Please increase it with coherent_pool= kernel parameter!
> >>only with em28xx sticks and sata, dib0700 sticks removed.
> >
> >Did you test the reverse scenario?  ie dib0700 with sata_mv and no
> >em28xx.
> 
> Maybe I can test this next night.

Please do, this will tell us if it is in the USB drivers or lower
(something in common).

> >>>>What would be most helpful is if you could do a git bisect between
> >>>>v3.5.x (working) and the oldest version where you know it started
> >>>>failing (v3.7.1 or earlier if you know it).
> >>>>
> >>>I did not bisect it, but Marek mentioned earlier that commit
> >>>e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
> >>>new code for dma allocations. This is probably the root cause for the
> >>>new (mis-)behavior (due to my tests 3.6.0 is not working anymore).
> >>
> >>I don't want to say that Mareks patch is wrong, probably it triggers a
> >>bug somewhere else! (in em28xx?)
> >
> >Of the four drivers you listed, none are using dma.  sata_mv is the only
> >one.
> 
> usb_core is doing the actual DMA for the usb bridge drivers, I think.

Yes, my mistake.  I'd like to attribute that statement to pre-coffee
rambling. :-)

> >If one is to believe the comments in sata_mv.c:~151, then the alignment
> >is wrong for the sg_tbl_pool.
> >
> >Could you please try the following patch?
> 
> OK, what should I test first, the setup from last night (em28xx, no
> dib0700) plus your patch, or the reverse setup (dib0700, no em28xx)
> without your patch, or my normal setting (all dvb sticks) plus your
> patch?

if testing time is limited, please do the test I outlined at the top of
this email.  I've been digging more into the dma code and while I think
the patch is correct, I don't see where it would fix your problem (yet).

thx,

Jason.
