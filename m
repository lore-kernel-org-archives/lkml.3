Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3F1Spw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:45:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53528 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3F1Spu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:45:50 -0400
Date: Fri, 28 Jun 2013 11:45:47 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, kmpark@infradead.org,
        hyunhee.kim@samsung.com
Subject: Re: [PATCH v2] vmpressure: implement strict mode
Message-ID: <20130628184547.GA14287@teo>
References: <20130628000201.GB15637@bbox>
 <20130627173433.d0fc6ecd.akpm@linux-foundation.org>
 <20130628005852.GA8093@teo>
 <20130627181353.3d552e64.akpm@linux-foundation.org>
 <20130628043411.GA9100@teo>
 <20130628050712.GA10097@teo>
 <20130628100027.31504abe@redhat.com>
 <20130628165722.GA12271@teo>
 <20130628170917.GA12610@teo>
 <20130628142558.5da3d030@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130628142558.5da3d030@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 02:25:58PM -0400, Luiz Capitulino wrote:
> > > > That's how it's expected to work, because on strict mode you're notified
> > > > for the level you registered for. So apps registering for critical, will
> > > > still be notified on critical just like before.
> > > 
> > > Suppose you introduce a new level, and the system hits this level. Before,
> > > the app would receive at least some notification for the given memory load
> > > (i.e. one of the old levels), with the new level introduced in the kernel,
> > > the app will receive no events at all.
> 
> That's not true. If an app registered for critical it will still get
> critical notification when the system is at the critical level. Just as it
> always did. No new events will change this.
> 
> With today's semantics though, new events will change when current events
> are triggered. So each new extension will cause applications to have
> different behaviors, in different kernel versions. This looks quite
> undesirable to me.

I'll try to explain it again.

Old behaviour:

low -> event
  x <- but the system is at this unnamed level, between low and med
med
crit


We add a level:

low
low-med <- system at this state, we send an event, but the old app does
           not know about it, so it won't receive *any* notifications. (In
	   older kernels it would receive low level notification
med
crit

You really don't see a problem here?

I see the problem, and I see these solutions:

1. Use current scheme.
2. Add versioning.
3. Never change the levels (how can we know?)

Anton
