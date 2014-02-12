Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaBLKja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:39:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaBLKj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:39:28 -0500
Date: Wed, 12 Feb 2014 10:39:24 +0000
From: Mel Gorman <mgorman@suse.de>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140212103924.GO6732@suse.de>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <alpine.DEB.2.02.1402101851190.3447@chino.kir.corp.google.com>
 <20140211092514.GH6732@suse.de>
 <20140211152629.GA28210@amt.cnet>
 <20140211171035.GN6732@suse.de>
 <20140211201557.GA16281@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140211201557.GA16281@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 06:15:57PM -0200, Marcelo Tosatti wrote:
> On Tue, Feb 11, 2014 at 05:10:35PM +0000, Mel Gorman wrote:
> > On Tue, Feb 11, 2014 at 01:26:29PM -0200, Marcelo Tosatti wrote:
> > > > Or take a stab at allocating 1G pages at runtime. It would require
> > > > finding properly aligned 1Gs worth of contiguous MAX_ORDER_NR_PAGES at
> > > > runtime. I would expect it would only work very early in the lifetime of
> > > > the system but if the user is willing to use kernel parameters to
> > > > allocate them then it should not be an issue.
> > > 
> > > Can be an improvement on top of the current patchset? Certain use-cases
> > > require allocation guarantees (even if that requires kernel parameters).
> > > 
> > 
> > Sure, they're not mutually exclusive. It would just avoid the need to
> > create a new kernel parameter and use the existing interfaces.
> 
> Yes, the problem is there is no guarantee is there?
> 

There is no guarantee anyway and early in the lifetime of the system there
is going to be very little difference in success rates. In case there is a
misunderstanding here, I'm not looking to NAK a series that adds another
kernel parameter. If it was me, I would have tried runtime allocation
first to avoid adding a new interface but it's a personal preference.

-- 
Mel Gorman
SUSE Labs
