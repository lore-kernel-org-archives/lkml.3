Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaG2XWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:22:23 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:41735 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbaG2XWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:22:22 -0400
Date: Wed, 30 Jul 2014 02:21:42 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
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
Message-ID: <20140729232142.GB17685@node.dhcp.inet.fi>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
 <1406553101-29326-6-git-send-email-vbabka@suse.cz>
 <alpine.DEB.2.02.1407281709050.8998@chino.kir.corp.google.com>
 <53D7690D.5070307@suse.cz>
 <alpine.DEB.2.02.1407291559130.20991@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407291559130.20991@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:02:09PM -0700, David Rientjes wrote:
> Hmm, I'm confused at how that could be true, could you explain what 
> memory other than thp can return true for PageTransHuge()?

PageTransHuge() will be true for any head of compound page if THP is
enabled compile time: hugetlbfs, slab, whatever.

-- 
 Kirill A. Shutemov
