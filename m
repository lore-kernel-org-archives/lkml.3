Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaKUXio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:38:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaKUXim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:38:42 -0500
Date: Fri, 21 Nov 2014 15:38:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm/page_owner: correct owner information for
 early allocated pages
Message-Id: <20141121153841.c15fa400fd5c76d3946523a8@linux-foundation.org>
In-Reply-To: <1416557646-21755-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1416557646-21755-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1416557646-21755-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 17:14:06 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Extended memory to store page owner information is initialized some time
> later than that page allocator starts. Until initialization, many pages
> can be allocated and they have no owner information. This make debugging
> using page owner harder, so some fixup will be helpful.
> 
> This patch fix up this situation by setting fake owner information
> immediately after page extension is initialized. Information doesn't
> tell the right owner, but, at least, it can tell whether page is
> allocated or not, more correctly.
> 
> On my testing, this patch catches 13343 early allocated pages, although
> they are mostly allocated from page extension feature. Anyway, after then,
> there is no page left that it is allocated and has no page owner flag.

We really should have a Documentation/vm/page_owner.txt which explains
all this stuff, provides examples, etc.
