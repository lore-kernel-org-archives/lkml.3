Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3C2Jg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 05:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab3C2Jg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 05:36:28 -0400
Date: Fri, 29 Mar 2013 10:36:24 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] soft-offline: use migrate_pages() instead of
 migrate_huge_page()
Message-ID: <20130329093624.GC21227@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87boa69z6j.fsf@linux.vnet.ibm.com>
 <20130327135250.GI16579@dhcp22.suse.cz>
 <87li967p5j.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li967p5j.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 29-03-13 10:56:00, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko@suse.cz> writes:
[...]
> > Little bit offtopic:
> > Btw. hugetlb migration breaks to charging even before this patchset
> > AFAICS. The above put_page should remove the last reference and then it
> > will uncharge it but I do not see anything that would charge a new page.
> > This is all because regula LRU pages are uncharged when they are
> > unmapped. But this a different story not related to this series.
> 
> 
> But when we call that put_page, we would have alreayd move the cgroup
> information to the new page. We have
> 
> 	h_cg = hugetlb_cgroup_from_page(oldhpage);
> 	set_hugetlb_cgroup(oldhpage, NULL);
> 
> 	/* move the h_cg details to new cgroup */
> 	set_hugetlb_cgroup(newhpage, h_cg);
> 
> 
> in hugetlb_cgroup_migrate

Yes but the res counter charge would be missing for the newpage after
put_page

-- 
Michal Hocko
SUSE Labs
