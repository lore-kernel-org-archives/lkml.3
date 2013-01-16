Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3APRsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:48:33 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:44486 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795Ab3APRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:48:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wWpoNA7NeH2OSVd1nwgP2ldU8kxiLets=
Date: Wed, 16 Jan 2013 12:47:36 -0500
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
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20130116174736.GJ25500@titan.lakedaemon.net>
References: <50F3F289.3090402@web.de>
 <20130115165642.GA25500@titan.lakedaemon.net>
 <20130115175020.GA3764@kroah.com>
 <20130115201617.GC25500@titan.lakedaemon.net>
 <20130115215602.GF25500@titan.lakedaemon.net>
 <50F5F1B7.3040201@web.de>
 <20130116024014.GH25500@titan.lakedaemon.net>
 <50F61D86.4020801@web.de>
 <50F66B1B.40301@web.de>
 <50F6E419.5080007@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F6E419.5080007@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:32:09PM +0100, Soeren Moch wrote:
> On 16.01.2013 09:55, Soeren Moch wrote:
> >On 16.01.2013 04:24, Soeren Moch wrote:
> >>I did not bisect it, but Marek mentioned earlier that commit
> >>e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
> >>new code for dma allocations. This is probably the root cause for the
> >>new (mis-)behavior (due to my tests 3.6.0 is not working anymore).
> >
> >I don't want to say that Mareks patch is wrong, probably it triggers a
> >bug somewhere else! (in em28xx?)
> 
> The em28xx sticks are using isochronous usb transfers. Is there a
> special handling for that?

I'm looking at that now.  It looks like the em28xx wants (as a maximum)
655040 bytes (em28xx-core.c:1088).  There are 5 transfer buffers, with
64 max packets and 2047 max packet size (runtime reported max & 0x7ff).

If it actually needs all of that, then the answer may be to just
increase coherent_pool= when using that driver.  I'll keep digging.

thx,

Jason.
