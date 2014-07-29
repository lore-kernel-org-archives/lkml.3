Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaG2Xvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:51:42 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39137 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaG2Xvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:51:41 -0400
Date: Tue, 29 Jul 2014 16:51:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 05/14] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
In-Reply-To: <20140729232142.GB17685@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.02.1407291646590.961@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-6-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281709050.8998@chino.kir.corp.google.com> <53D7690D.5070307@suse.cz> <alpine.DEB.2.02.1407291559130.20991@chino.kir.corp.google.com>
 <20140729232142.GB17685@node.dhcp.inet.fi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, Kirill A. Shutemov wrote:

> > Hmm, I'm confused at how that could be true, could you explain what 
> > memory other than thp can return true for PageTransHuge()?
> 
> PageTransHuge() will be true for any head of compound page if THP is
> enabled compile time: hugetlbfs, slab, whatever.
> 

I was meaning in the context of the patch :)  Since PageLRU is set, that 
discounts slab so we're left with thp or hugetlbfs.  Logically, both 
should have sizes that are >= the size of the pageblock itself so I'm not 
sure why we don't unconditionally align up to pageblock_nr_pages here.  Is 
there a legitimiate configuration where a pageblock will span multiple 
pages of HPAGE_PMD_ORDER?
