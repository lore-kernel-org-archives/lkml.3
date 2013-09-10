Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3IJTTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3IJTTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:19:01 -0400
Date: Tue, 10 Sep 2013 15:18:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1378840706-f02wha3y-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130910135129.GP22421@suse.de>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130910135129.GP22421@suse.de>
Subject: Re: [PATCH 1/9] migrate: make core migration code aware of hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130910135129.GP22421@suse.de>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 02:51:30PM +0100, Mel Gorman wrote:
> On Fri, Aug 09, 2013 at 01:21:34AM -0400, Naoya Horiguchi wrote:
> > Before enabling each user of page migration to support hugepage,
> > this patch enables the list of pages for migration to link not only
> > LRU pages, but also hugepages. As a result, putback_movable_pages()
> > and migrate_pages() can handle both of LRU pages and hugepages.
> > 
> 
> LRU pages and *allocated* hugepages.

Right.

> On its own the patch looks ok but it's not obvious at this point what
> happens for pages that are on the hugetlbfs pool lists but not allocated
> by any process.

OK. I'll add comments about clarifying that. Now I'm preparing the next
patchset for migration of 1GB hugepages, so it's done in that series.

> They will fail to isolate because of the
> get_page_unless_zero() check. Maybe it's handled by a later patch.

The callers which determine the target pages with virtual address (like
mbind, migrate_pages) don't try to migrate hugepages in the hugetlbfs
pool. And the other callers which determine targets with physical address
(like memory hotplug and soft offline) have their own check not to migrate
free hugepages.

Thanks,
Naoya Horiguchi
