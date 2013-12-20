Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LTErG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:47:06 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64268 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LTErF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:47:05 -0500
X-AuditID: 9c930197-b7cefae000007949-75-52b3cbc6300c
Date: Fri, 20 Dec 2013 13:47:09 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
Message-ID: <20131220044709.GA1370@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
 <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
 <1387506681.8363.55.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387506681.8363.55.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Davidlohr.

On Thu, Dec 19, 2013 at 06:31:21PM -0800, Davidlohr Bueso wrote:
> On Thu, 2013-12-19 at 17:02 -0800, Andrew Morton wrote:
> > On Wed, 18 Dec 2013 15:53:59 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > 
> > > If parallel fault occur, we can fail to allocate a hugepage,
> > > because many threads dequeue a hugepage to handle a fault of same address.
> > > This makes reserved pool shortage just for a little while and this cause
> > > faulting thread who can get hugepages to get a SIGBUS signal.
> > > 
> > > To solve this problem, we already have a nice solution, that is,
> > > a hugetlb_instantiation_mutex. This blocks other threads to dive into
> > > a fault handler. This solve the problem clearly, but it introduce
> > > performance degradation, because it serialize all fault handling.
> > > 
> > > Now, I try to remove a hugetlb_instantiation_mutex to get rid of
> > > performance degradation.
> > 
> > So the whole point of the patch is to improve performance, but the
> > changelog doesn't include any performance measurements!
> > 
> > Please, run some quantitative tests and include a nice summary of the
> > results in the changelog.
> 
> I was actually spending this afternoon testing these patches with Oracle
> (I haven't seen any issues so far) and unless Joonsoo already did so, I
> want to run these by the libhugetlb test cases - I got side tracked by
> futexes though :/

Really thanks for your time to test these patches.
I already did libhugetlbfs test cases and passed it.

> 
> Please do consider that performance wise I haven't seen much in
> particular. The thing is, I started dealing with this mutex once I
> noticed it as the #1 hot lock in Oracle DB starts, but then once the
> faults are done, it really goes away. So I wouldn't say that the mutex
> is a bottleneck except for the first few minutes.

What I want to be sure is for the first few minutes you mentioned.
If possible, let me know the result like as following link.
https://lkml.org/lkml/2013/7/12/428

Thanks in advance. :)

> > 
> > This is terribly important, because if the performance benefit is
> > infinitesimally small or negative, the patch goes into the bit bucket ;)
> 
> Well, this mutex is infinitesimally ugly and needs to die (as long as
> performance isn't hurt).

Yes, I agreed.

Thanks.
