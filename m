Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3IJNvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:51:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3IJNvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:51:36 -0400
Date: Tue, 10 Sep 2013 14:51:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 1/9] migrate: make core migration code aware of hugepage
Message-ID: <20130910135129.GP22421@suse.de>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-2-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1376025702-14818-2-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:21:34AM -0400, Naoya Horiguchi wrote:
> Before enabling each user of page migration to support hugepage,
> this patch enables the list of pages for migration to link not only
> LRU pages, but also hugepages. As a result, putback_movable_pages()
> and migrate_pages() can handle both of LRU pages and hugepages.
> 

LRU pages and *allocated* hugepages.

On its own the patch looks ok but it's not obvious at this point what
happens for pages that are on the hugetlbfs pool lists but not allocated
by any process. They will fail to isolate because of the
get_page_unless_zero() check. Maybe it's handled by a later patch.

-- 
Mel Gorman
SUSE Labs
