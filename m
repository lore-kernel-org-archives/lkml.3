Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3HTVEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:04:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3HTVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:04:08 -0400
Date: Tue, 20 Aug 2013 14:04:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] mm: thrash detection-based file cache sizing v4
Message-Id: <20130820140406.694b248b41611883878f8245@linux-foundation.org>
In-Reply-To: <1376767883-4411-1-git-send-email-hannes@cmpxchg.org>
References: <1376767883-4411-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Aug 2013 15:31:14 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> This series solves the problem by maintaining a history of pages
> evicted from the inactive list, enabling the VM to tell streaming IO
> from thrashing and rebalance the page cache lists when appropriate.

I can't say I'm loving the patchset.  It adds significant bloat to the
inode (of all things!), seems to add some runtime overhead and
certainly adds boatloads of complexity.

In return for which we get...  well, I don't know what we get - no data
was included.  It had better be good!

To aid in this decision, please go through the patchset and calculate
and itemize the overhead: increased inode size, increased radix-tree
consumption, lengthier code paths, anything else I missed  Others can
make their own judgements regarding complexity increase.

Then please carefully describe the benefits, then see if you can
convince us that one is worth the other!

