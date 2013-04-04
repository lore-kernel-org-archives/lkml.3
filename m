Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763122Ab3DDQU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763102Ab3DDQUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:20:25 -0400
Date: Thu, 4 Apr 2013 18:20:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] mm/hugetlb: gigantic hugetlb page pools shrink
 supporting
Message-ID: <20130404162023.GQ29911@dhcp22.suse.cz>
References: <1365066554-29195-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20130404161746.GP29911@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404161746.GP29911@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-04-13 18:17:46, Michal Hocko wrote:
> On Thu 04-04-13 17:09:08, Wanpeng Li wrote:
> > order >= MAX_ORDER pages are only allocated at boot stage using the 
> > bootmem allocator with the "hugepages=xxx" option. These pages are never 
> > free after boot by default since it would be a one-way street(>= MAX_ORDER
> > pages cannot be allocated later), but if administrator confirm not to 
> > use these gigantic pages any more, these pinned pages will waste memory
> > since other users can't grab free pages from gigantic hugetlb pool even
> > if OOM, it's not flexible.  The patchset add hugetlb gigantic page pools
> > shrink supporting. Administrator can enable knob exported in sysctl to
> > permit to shrink gigantic hugetlb pool.
> 
> I am not sure I see why the new knob is needed.
> /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages is root interface so
> an additional step to allow writing to the file doesn't make much sense
> to me to be honest.
> 
> Support for shrinking gigantic huge pages makes some sense to me but I
> would be interested in the real world example. GB pages are usually used
> in very specific environments where the amount is usually well known.
> 
> I could imagine nr_hugepages_mempolicy would make more sense to free
> pages from particular nodes so they could be offlined for example.
> Does the patchset handles this as well?
 
Ohh, I should have checked before asking. Both knobs use the same
hugetlb_sysctl_handler_common and unless there is something hardcoded in
the patches then it should be supproted.

-- 
Michal Hocko
SUSE Labs
