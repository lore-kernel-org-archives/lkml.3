Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaEANdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:33:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60073 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaEANdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:33:43 -0400
Date: Thu, 1 May 2014 09:33:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] mm: Do not use unnecessary atomic operations when
 adding pages to the LRU
Message-ID: <20140501133340.GE23420@cmpxchg.org>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-16-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398933888-4940-16-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:44:46AM +0100, Mel Gorman wrote:
> When adding pages to the LRU we clear the active bit unconditionally. As the
> page could be reachable from other paths we cannot use unlocked operations
> without risk of corruption such as a parallel mark_page_accessed. This
> patch test if is necessary to clear the atomic flag before using an atomic
> operation. In the unlikely even this races with mark_page_accesssed the

                             event

> consequences are simply that the page may be promoted to the active list
> that might have been left on the inactive list before the patch. This is
> a marginal consequence.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
