Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3APClN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:41:13 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18202 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757282Ab3APClM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:41:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Hlho7mt4XCrRNG7rr89biieNJ81yWc38=
Date: Tue, 15 Jan 2013 21:40:14 -0500
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
Message-ID: <20130116024014.GH25500@titan.lakedaemon.net>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <50F3F289.3090402@web.de>
 <20130115165642.GA25500@titan.lakedaemon.net>
 <20130115175020.GA3764@kroah.com>
 <20130115201617.GC25500@titan.lakedaemon.net>
 <20130115215602.GF25500@titan.lakedaemon.net>
 <50F5F1B7.3040201@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F5F1B7.3040201@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren,

On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
> On 15.01.2013 22:56, Jason Cooper wrote:
> >On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:
> >>If my understanding is correct, one of the drivers (most likely one)
> >>either asks for too small of a dma buffer, or is not properly
> >>deallocating blocks from the per-device pool.  Either case leads to
> >>exhaustion, and falling back to the atomic pool.  Which subsequently
> >>gets wiped out as well.
> >
> >If my hunch is right, could you please try each of the three dvb drivers
> >in turn and see which one (or more than one) causes the error?
> 
> In fact I use only 2 types of DVB sticks: em28xx usb bridge plus drxk
> demodulator, and dib0700 usb bridge plus dib7000p demod.
> 
> I would bet for em28xx causing the error, but this is not thoroughly
> tested. Unfortunately testing with removed sticks is not easy, because
> this is a production system and disabling some services for the long
> time we need to trigger this error will certainly result in unhappy
> users.

Just out of curiosity, what board is it?

> I will see what I can do here. Is there an easy way to track the buffer
> usage without having to wait for complete exhaustion?

DMA_API_DEBUG

> In linux-3.5.x there is no such problem. Can we use all available memory
> for dma buffers here on armv5 architectures, in contrast to newer
> kernels?

Were the loads exactly the same when you tested 3.5.x?  I looked at the
changes from v3.5 to v3.7.1 for all four drivers you mentioned as well
as sata_mv.

The biggest thing I see is that all of the media drivers got shuffled
around into their own subdirectories after v3.5.  'git show -M 0c0d06c'
shows it was a clean copy of all the files.

What would be most helpful is if you could do a git bisect between
v3.5.x (working) and the oldest version where you know it started
failing (v3.7.1 or earlier if you know it).

thx,

Jason.
