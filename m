Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaGHJsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:48:33 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:58573 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaGHJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:48:32 -0400
Date: Tue, 8 Jul 2014 12:48:10 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v10 7/7] mm: Don't split THP page when syscall is called
Message-ID: <20140708094810.GB3490@node.dhcp.inet.fi>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
 <1404694438-10272-8-git-send-email-minchan@kernel.org>
 <20140707111303.GC23150@node.dhcp.inet.fi>
 <20140708013038.GD6076@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708013038.GD6076@bbox>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:30:38AM +0900, Minchan Kim wrote:
> Actually, I did but found no problem except CONFIG_DEBUG_VM but rollback
> after peeking [1].
> When I read the description in detail by your review, I think we can remove
> BUG_ON(PageTransHuge(page)) in try_to_unmap and go with no split for lazyfree
> page because they are not in swapcache any more so the assumption of [1] is
> not valid. Will do it in next revision.

No. try_to_unmap() knows nothing about PMDs, so page_check_address() will
always return NULL for THP and you will not unmap anything.

-- 
 Kirill A. Shutemov
