Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaEANZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:25:27 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60065 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEANZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:25:26 -0400
Date: Thu, 1 May 2014 09:25:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] mm: page_alloc: Do not update zlc unless the zlc
 is active
Message-ID: <20140501132520.GC23420@cmpxchg.org>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398933888-4940-2-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:44:32AM +0100, Mel Gorman wrote:
> The zlc is used on NUMA machines to quickly skip over zones that are full.
> However it is always updated, even for the first zone scanned when the
> zlc might not even be active. As it's a write to a bitmap that potentially
> bounces cache line it's deceptively expensive and most machines will not
> care. Only update the zlc if it was active.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
