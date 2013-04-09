Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab3DIV2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:28:07 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:48914 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934470Ab3DIV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <1365538036-pu7x5mck-mutt-n-horiguchi@ah.jp.nec.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F68BB.3010601@gmail.com> <1365538036-pu7x5mck-mutt-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 9 Apr 2013 17:27:44 -0400
Message-ID: <CAHGf_=o+GQ9PJy=rkO1zxhd81NpyTvDQA7phN8StX2+EQ+ZE=g@mail.gmail.com>
Subject: Re: [PATCH 09/10] memory-hotplug: enable memory hotplug to handle hugepage
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> numa_node_id() is really silly. This might lead to allocate from offlining node.
>
> Right, it should've been alloc_huge_page().
>
>> and, offline_pages() should mark hstate as isolated likes normal pages for prohibiting
>> new allocation at first.
>
> It seems that alloc_migrate_target() calls alloc_page() for normal pages
> and the destination pages can be in the same node with the source pages
> (new page allocation from the same memblock are prohibited.)

No. It can't. memory hotplug change buddy attribute to MIGRATE_ISOLTE at first.
then alloc_page() never allocate from source node. however huge page don't use
buddy. then we need another trick.


> So if we want to avoid new page allocation from the same node,
> this is the problem both for normal and huge pages.
>
> BTW, is it correct to think that all users of memory hotplug assume
> that they want to hotplug a whole node (not the part of it?)

Both are valid use case. admin can isolate a part of memory for isolating
broken memory range.

but I'm sure almost user want to remove whole node.
