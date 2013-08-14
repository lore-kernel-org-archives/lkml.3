Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab3HNWWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:22:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933115Ab3HNWWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:22:45 -0400
Date: Wed, 14 Aug 2013 23:22:41 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        riel@redhat.com, aquini@redhat.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-ID: <20130814222241.GQ2296@suse.de>
References: <520B0B75.4030708@huawei.com>
 <20130814085711.GK2296@suse.de>
 <20130814155205.GA2706@gmail.com>
 <20130814132602.814a88e991e29c5b93bbe22c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130814132602.814a88e991e29c5b93bbe22c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 01:26:02PM -0700, Andrew Morton wrote:
> On Thu, 15 Aug 2013 00:52:29 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > On Wed, Aug 14, 2013 at 09:57:11AM +0100, Mel Gorman wrote:
> > > On Wed, Aug 14, 2013 at 12:45:41PM +0800, Xishi Qiu wrote:
> > > > A large free page buddy block will continue many times, so if the page 
> > > > is free, skip the whole page buddy block instead of one page.
> > > > 
> > > > Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> > > 
> > > page_order cannot be used unless zone->lock is held which is not held in
> > > this path. Acquiring the lock would prevent parallel allocations from the
> > 
> > Argh, I missed that.
> 
> I missed it as well. And so did Xishi Qiu.
> 
> Mel, we have a problem.  What can we do to make this code more
> maintainable?

I sit in the bad man corner until I write a comment patch :/

page_order already has a comment but obviously the call site on compaction.c
could do with a hint. As I think the consequences of this race can be
dealt with I'm hoping Xishi Qiu will take the example I posted, fix it
if it needs fixing, turn it into a real patch and run it through whatever
test case led him to find this problem in the first place (HINT HINT). If
that happens, great!  If not, I might do it myself and failing that, I'll
post a patch adding a comment explaining why page_order is not used there.

-- 
Mel Gorman
SUSE Labs
