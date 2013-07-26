Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3GZEma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:42:30 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5893 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067Ab3GZEm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:42:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoHADb98VF5LPxH/2dsb2JhbABagwaDKLYJhTqBFRd0giQBAQUnExwWCgMQCAMOCgklDwUlAyETiA+5GhaOOYEuB4QAA5dekU6DJio
Date: Fri, 26 Jul 2013 14:42:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
        Jeff Layton <jlayton@samba.org>, linux-cifs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Recvfile patch used for Samba.
Message-ID: <20130726044218.GL13468@dastard>
References: <20130722215738.GB20647@samba2>
 <20130723071027.GJ19986@dastard>
 <20130723215858.GB16356@samba2>
 <20130724024723.GL19986@dastard>
 <1374740221.2713.8.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374740221.2713.8.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:17:01AM +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Wed, 2013-07-24 at 12:47 +1000, Dave Chinner wrote:
> > On Tue, Jul 23, 2013 at 02:58:58PM -0700, Jeremy Allison wrote:
> > > Having said that the OEMs that are using it does
> > > find it improves write speeds by a large amount (10%
> > > or more), so it's showing there is room for improvement
> > > here if the correct code can be created for recvfile.
> > 
> > 10% is not very large gain given the complexity it adds, and I
> > question that the gain actually comes from moving the memcpy() into
> > the kernel.  If this recvfile code enabled zero-copy behaviour into
> > the page cache, then it would be worth pursuing. But it doesn't, and
> > so IMO the complexity is not worth the gain right now.
> > 
> > Indeed, I suspect the 10% gain will be from the multi-page write
> > behaviour that was hacked into the code. I wrote a multi-page
> > write prototype ~3 years ago that showed write(2) performance gains
> > of roughly 10% on low CPU power machines running XFS.
...
> > I should probably pick this up again and push it forwards. FWIW,
> > I've attached the first multipage-write infrastructure patch from
> > the above branch to show how this sort of operation needs to be done
> > from a filesystem and page-cache perspective to avoid locking
> > problems have sane error handling.
> > 
> > I beleive the version that Christoph implemented for a couple of
> > OEMs around that time de-multiplexed the ->iomap method....
> 
> I have Christoph's version here and between other tasks, I'm working on
> figuring out how it all works and writing GFS2 support for it. I'd more
> or less got that complete for your version, but there are a number of
> differences with Christoph's code and it is taking me a while to ensure
> that I've not missed any corner cases and figuring out how to fit some
> of GFS2's odd write modes into the framework,

Can you send me Christoph's version so I can have a look at the
differences? I'm pretty sure there isn't anything architecturally
different, but I've never seen it so I don't know exactly how it
differs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
