Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3GWBFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:05:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40952 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3GWBFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:05:38 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 05/10] mm, hugetlb: fix and clean-up node iteration code to alloc or free
In-Reply-To: <20130722162336.GJ24400@dhcp22.suse.cz>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com> <1374482191-3500-6-git-send-email-iamjoonsoo.kim@lge.com> <20130722162336.GJ24400@dhcp22.suse.cz>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 23 Jul 2013 06:35:15 +0530
Message-ID: <87r4eqm6gk.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072300-0260-0000-0000-0000035A26CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Mon 22-07-13 17:36:26, Joonsoo Kim wrote:
>> Current node iteration code have a minor problem which do one more
>> node rotation if we can't succeed to allocate. For example,
>> if we start to allocate at node 0, we stop to iterate at node 0.
>> Then we start to allocate at node 1 for next allocation.
>> 
>> I introduce new macros "for_each_node_mask_to_[alloc|free]" and
>> fix and clean-up node iteration code to alloc or free.
>> This makes code more understandable.
>
> I don't know but it feels like you are trying to fix an awkward
> interface with another one. Why hstate_next_node_to_alloc cannot simply
> return MAX_NUMNODES once the loop is done and start from first_node next
> time it is called? We wouldn't have the bug you are mentioning and you
> do not need scary looking macros.
>

Even though the macros looks confusing, the changes do help rest of the
code. for ex: I liked how it made alloc simpler.

 +	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
 +		page = alloc_fresh_huge_page_node(h, node);

-aneesh

