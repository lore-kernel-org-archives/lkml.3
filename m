Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaCaR0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:26:21 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39267 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaCaR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:26:19 -0400
Message-ID: <1396286773.2507.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 00/14] mm, hugetlb: remove a
 hugetlb_instantiation_mutex
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Date: Mon, 31 Mar 2014 10:26:13 -0700
In-Reply-To: <5339977F.4070905@intel.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <5339977F.4070905@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 09:27 -0700, Dave Hansen wrote:
> On 12/17/2013 10:53 PM, Joonsoo Kim wrote:
> > * NOTE for v3
> > - Updating patchset is so late because of other works, not issue from
> > this patchset.
> 
> Hey Joonsoo,
> 
> Any plans to repost these?
> 
> I've got some folks with a couple TB of RAM seeing long startup times
> with $LARGE_DATABASE_PRODUCT.  It looks to be contention on
> hugetlb_instantiation_mutex because everyone is trying to zero hugepages
> under that lock in parallel.  Just removing the lock sped things up
> quite a bit.

Welcome to my world. Regarding the instantiation mutex, it is addressed,
see commit c999c05ff595 in -next. 

As for the clear page overhead, I brought this up in lsfmm last week,
proposing some daemon to clear pages when we have idle cpu... but didn't
get much positive feedback. Basically (i) not worth the additional
complexity and (ii) can trigger different application startup times,
which seems to be something negative. I do have a patch that implements
huge_clear_page with non-temporal hinting but I didn't see much
difference on my environment, would you want to give it a try?

Thanks,
Davidlohr

