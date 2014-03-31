Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaCaQ3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:29:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:14218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbaCaQ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:29:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,766,1389772800"; 
   d="scan'208";a="484105172"
Message-ID: <5339977F.4070905@intel.com>
Date: Mon, 31 Mar 2014 09:27:43 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
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
Subject: Re: [PATCH v3 00/14] mm, hugetlb: remove a hugetlb_instantiation_mutex
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 10:53 PM, Joonsoo Kim wrote:
> * NOTE for v3
> - Updating patchset is so late because of other works, not issue from
> this patchset.

Hey Joonsoo,

Any plans to repost these?

I've got some folks with a couple TB of RAM seeing long startup times
with $LARGE_DATABASE_PRODUCT.  It looks to be contention on
hugetlb_instantiation_mutex because everyone is trying to zero hugepages
under that lock in parallel.  Just removing the lock sped things up
quite a bit.
