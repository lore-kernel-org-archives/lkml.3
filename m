Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaFDVqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:46:13 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34050 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaFDVqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:46:10 -0400
Date: Wed, 4 Jun 2014 17:45:53 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140604214553.GV2878@cmpxchg.org>
References: <20140528134905.GF2878@cmpxchg.org>
 <20140528142144.GL9895@dhcp22.suse.cz>
 <20140528152854.GG2878@cmpxchg.org>
 <20140528155414.GN9895@dhcp22.suse.cz>
 <20140528163335.GI2878@cmpxchg.org>
 <20140603110743.GD1321@dhcp22.suse.cz>
 <20140603142249.GP2878@cmpxchg.org>
 <20140604144658.GB17612@dhcp22.suse.cz>
 <20140604154408.GT2878@cmpxchg.org>
 <alpine.LSU.2.11.1406041218080.9583@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1406041218080.9583@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 12:18:59PM -0700, Hugh Dickins wrote:
> On Wed, 4 Jun 2014, Johannes Weiner wrote:
> > On Wed, Jun 04, 2014 at 04:46:58PM +0200, Michal Hocko wrote:
> > > 
> > > In the other email I have suggested to add a knob with the configurable
> > > default. Would you be OK with that?
> > 
> > No, I want to agree on whether we need that fallback code or not.  I'm
> > not interested in merging code that you can't convince anybody else is
> > needed.
> 
> I for one would welcome such a knob as Michal is proposing.

Now we have a tie :-)

> I thought it was long ago agreed that the low limit was going to fallback
> when it couldn't be satisfied.  But you seem implacably opposed to that
> as default, and I can well believe that Google is so accustomed to OOMing
> that it is more comfortable with OOMing as the default.  Okay.  But I
> would expect there to be many who want the attempt towards isolation that
> low limit offers, without a collapse to OOM at the first misjudgement.

At the same time, I only see users like Google pushing the limits of
the machine to a point where guarantees cover north of 90% of memory.
I would expect more casual users to work with much smaller guarantees,
and a good chunk of slack on top - otherwise they already had better
be set up for the occasional OOM.  Is this an unreasonable assumption
to make?

I'm not opposed to this feature per se, but I'm really opposed to
merging it for the partial hard bindings argument and for papering
over deficiencies in our reclaim code, because I don't want any of
that in the changelog, in the documentation, or in what we otherwise
tell users about it.
