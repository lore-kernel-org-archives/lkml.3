Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849Ab3DJC0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765455Ab3DJC0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:26:01 -0400
Date: Tue, 09 Apr 2013 22:24:58 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1365560698-qyvvld1y-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAHGf_=oL7dORGCJZtLxrwc9cGgrakAsfAOJ4xx659nDmQd=rcw@mail.gmail.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F68BB.3010601@gmail.com>
 <1365538036-pu7x5mck-mutt-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=o+GQ9PJy=rkO1zxhd81NpyTvDQA7phN8StX2+EQ+ZE=g@mail.gmail.com>
 <1365547416-z92y6qa9-mutt-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=oL7dORGCJZtLxrwc9cGgrakAsfAOJ4xx659nDmQd=rcw@mail.gmail.com>
Subject: Re: [PATCH 09/10] memory-hotplug: enable memory hotplug to handle
 hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <CAHGf_=oL7dORGCJZtLxrwc9cGgrakAsfAOJ4xx659nDmQd=rcw@mail.gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:56:58PM -0400, KOSAKI Motohiro wrote:
> On Tue, Apr 9, 2013 at 6:43 PM, Naoya Horiguchi
...
> > MIGRATE_ISOLTE is changed only within the range [start_pfn, end_pfn)
> > given as the argument of __offline_pages (see also start_isolate_page_range),
> > so it's set only for pages within the single memblock to be offlined.
> 
> When partial memory hot remove, that's correct behavior. different
> node is not required.
> 
> > BTW, in previous discussion I already agreed with checking migrate type
> > in hugepage allocation code (maybe it will be in dequeue_huge_page_vma(),)
> > so what you concern should be solved in the next post.
> 
> Umm.. Maybe I missed such discussion. Do you have a pointer?

Please see the bottom of the following:
  http://thread.gmane.org/gmane.linux.kernel.mm/96665/focus=96920
It's not exactly the same, but we need to prevent the allocation
from the memblock under hotremoving not only to be efficient,
but also to avoid the race.

Thanks,
Naoya
