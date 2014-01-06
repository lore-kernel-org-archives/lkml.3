Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaAFAMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:12:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44322 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaAFAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:12:30 -0500
X-AuditID: 9c930179-b7c89ae000006438-e3-52c9f4ebad1b
Date: Mon, 6 Jan 2014 09:12:37 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 03/14] mm, hugetlb: protect region tracking via newly
 introduced resv_map lock
Message-ID: <20140106001237.GA696@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20131221135819.GB12407@voom.fritz.box>
 <20131223010517.GB19388@lge.com>
 <20131224120012.GH12407@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131224120012.GH12407@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 11:00:12PM +1100, David Gibson wrote:
> On Mon, Dec 23, 2013 at 10:05:17AM +0900, Joonsoo Kim wrote:
> > On Sun, Dec 22, 2013 at 12:58:19AM +1100, David Gibson wrote:
> > > On Wed, Dec 18, 2013 at 03:53:49PM +0900, Joonsoo Kim wrote:
> > > > There is a race condition if we map a same file on different processes.
> > > > Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> > > > When we do mmap, we don't grab a hugetlb_instantiation_mutex, but,
> > > > grab a mmap_sem. This doesn't prevent other process to modify region
> > > > structure, so it can be modified by two processes concurrently.
> > > > 
> > > > To solve this, I introduce a lock to resv_map and make region manipulation
> > > > function grab a lock before they do actual work. This makes region
> > > > tracking safe.
> > > 
> > > It's not clear to me if you're saying there is a list corruption race
> > > bug in the existing code, or only that there will be if the
> > > instantiation mutex goes away.
> > 
> > Hello,
> > 
> > The race exists in current code.
> > Currently, region tracking is protected by either down_write(&mm->mmap_sem) or
> > down_read(&mm->mmap_sem) + instantiation mutex. But if we map this hugetlbfs
> > file to two different processes, holding a mmap_sem doesn't have any impact on
> > the other process and concurrent access to data structure is possible.
> 
> Ouch.  In that case:
> 
> Acked-by: David Gibson <david@gibson.dropbear.id.au>
> 
> It would be really nice to add a testcase for this race to the
> libhugetlbfs testsuite.

Okay!
I will add it.

Thanks.
