Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaAOUrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:47:10 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:37496 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaAOUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:47:07 -0500
Message-ID: <1389818820.17932.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, aswin@hp.com
Date: Wed, 15 Jan 2014 12:47:00 -0800
In-Reply-To: <20140114205603.f4fd2678.akpm@linux-foundation.org>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
	 <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
	 <20131220140153.GC11295@suse.de>
	 <1387608497.3119.17.camel@buesod1.americas.hpqcorp.net>
	 <20131223004438.GA19388@lge.com> <20131223021118.GA2487@lge.com>
	 <1388778945.2956.20.camel@buesod1.americas.hpqcorp.net>
	 <20140106001938.GB696@lge.com>
	 <1389010745.14953.5.camel@buesod1.americas.hpqcorp.net>
	 <20140107015701.GB26726@lge.com>
	 <1389062214.9937.0.camel@buesod1.americas.hpqcorp.net>
	 <alpine.DEB.2.02.1401141906350.451@chino.kir.corp.google.com>
	 <1389760669.4971.31.camel@buesod1.americas.hpqcorp.net>
	 <20140114205603.f4fd2678.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 20:56 -0800, Andrew Morton wrote:
> On Tue, 14 Jan 2014 20:37:49 -0800 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > On Tue, 2014-01-14 at 19:08 -0800, David Rientjes wrote:
> > > On Mon, 6 Jan 2014, Davidlohr Bueso wrote:
> > > 
> > > > > If Andrew agree, It would be great to merge 1-7 patches into mainline
> > > > > before your mutex approach. There are some of clean-up patches and, IMO,
> > > > > it makes the code more readable and maintainable, so it is worth to merge
> > > > > separately.
> > > > 
> > > > Fine by me.
> > > > 
> > > 
> > > It appears like patches 1-7 are still missing from linux-next, would you 
> > > mind posting them in a series with your approach?
> > 
> > I haven't looked much into patches 4-7, but at least the first three are
> > ok. I was waiting for Andrew to take all seven for linux-next and then
> > I'd rebase my approach on top. Anyway, unless Andrew has any
> > preferences, if by later this week they're not picked up, I'll resend
> > everything.
> 
> Well, we're mainly looking for bugfixes this last in the cycle. 
> "[PATCH v3 03/14] mm, hugetlb: protect region tracking via newly
> introduced resv_map lock" fixes a bug, but I'd assumed that it depended
> on earlier patches. 

It doesn't seem to depend on anything. All 1-7 patches apply cleanly on
linux-next, the last change to mm/hugetlb.c was commit 3ebac7fa (mm:
dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE).

>  If we think that one is serious then it would be
> better to cook up a minimal fix which is backportable into 3.12 and
> eariler?

I don't think it's too serious, afaik it's a theoretical race and I
haven't seen any bug reports for it. So we can probably just wait for
3.14, as you say, it's already late in the cycle anyways. Just let me
know what you want to do so we can continue working on the actual
performance issue.

Thanks,
Davidlohr

