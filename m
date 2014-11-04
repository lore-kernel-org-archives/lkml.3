Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaKDAjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:39:06 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:40075 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaKDAjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:39:02 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 4 Nov 2014 09:40:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>,
        David Miller <davem@davemloft.net>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct page
Message-ID: <20141104004045.GC8412@js1304-P5Q-DELUXE>
References: <1414898156-4741-1-git-send-email-hannes@cmpxchg.org>
 <20141103080208.GA7052@js1304-P5Q-DELUXE>
 <20141103150942.GA32052@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103150942.GA32052@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:09:42AM -0500, Johannes Weiner wrote:
> Hi Joonsoo,
> 
> On Mon, Nov 03, 2014 at 05:02:08PM +0900, Joonsoo Kim wrote:
> > On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
> > > Memory cgroups used to have 5 per-page pointers.  To allow users to
> > > disable that amount of overhead during runtime, those pointers were
> > > allocated in a separate array, with a translation layer between them
> > > and struct page.
> > 
> > Hello, Johannes.
> > 
> > I'd like to leave this translation layer.
> > Could you just disable that code with #ifdef until next user comes?
> > 
> > In our company, we uses PAGE_OWNER on mm tree which is the feature
> > saying who allocates the page. To use PAGE_OWNER needs modifying
> > struct page and then needs re-compile. This re-compile makes us difficult
> > to use this feature. So, we decide to implement run-time configurable
> > PAGE_OWNER through page_cgroup's translation layer code. Moreover, with
> > this infrastructure, I plan to implement some other debugging feature.
> > 
> > Because of my laziness, it didn't submitted to LKML. But, I will
> > submit it as soon as possible. If the code is removed, I would
> > copy-and-paste the code, but, it would cause lose of the history on
> > that code. So if possible, I'd like to leave that code now.
> 
> Please re-introduce this code when your new usecase is ready to be
> upstreamed.  There is little reason to burden an unrelated feature
> with a sizable chunk of dead code for a vague future user.

Okay.

Thanks.
