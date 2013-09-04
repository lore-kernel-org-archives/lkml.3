Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab3IDIog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:44:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44994 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab3IDIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:44:33 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-10-5226f2ef3280
Date: Wed, 4 Sep 2013 17:44:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 19/20] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
Message-ID: <20130904084430.GD16355@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-20-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376040398-11212-20-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 06:26:37PM +0900, Joonsoo Kim wrote:
> If parallel fault occur, we can fail to allocate a hugepage,
> because many threads dequeue a hugepage to handle a fault of same address.
> This makes reserved pool shortage just for a little while and this cause
> faulting thread who can get hugepages to get a SIGBUS signal.
> 
> To solve this problem, we already have a nice solution, that is,
> a hugetlb_instantiation_mutex. This blocks other threads to dive into
> a fault handler. This solve the problem clearly, but it introduce
> performance degradation, because it serialize all fault handling.
> 
> Now, I try to remove a hugetlb_instantiation_mutex to get rid of
> performance degradation. For achieving it, at first, we should ensure that
> no one get a SIGBUS if there are enough hugepages.
> 
> For this purpose, if we fail to allocate a new hugepage when there is
> concurrent user, we return just 0, instead of VM_FAULT_SIGBUS. With this,
> these threads defer to get a SIGBUS signal until there is no
> concurrent user, and so, we can ensure that no one get a SIGBUS if there
> are enough hugepages.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 

Hello, David.
May I ask to you to review this one?
I guess that you already thought about the various race condition,
so I think that you are the most appropriate reviewer to this patch. :)

Thanks.

