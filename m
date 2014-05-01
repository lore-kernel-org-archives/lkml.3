Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaEANkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 09:40:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaEANkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 09:40:32 -0400
Date: Thu, 1 May 2014 14:40:28 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/17] mm: Do not use unnecessary atomic operations when
 adding pages to the LRU
Message-ID: <20140501134028.GL23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-16-git-send-email-mgorman@suse.de>
 <20140501133340.GE23420@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140501133340.GE23420@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:33:40AM -0400, Johannes Weiner wrote:
> On Thu, May 01, 2014 at 09:44:46AM +0100, Mel Gorman wrote:
> > When adding pages to the LRU we clear the active bit unconditionally. As the
> > page could be reachable from other paths we cannot use unlocked operations
> > without risk of corruption such as a parallel mark_page_accessed. This
> > patch test if is necessary to clear the atomic flag before using an atomic
> > operation. In the unlikely even this races with mark_page_accesssed the
> 
>                              event
> 

Will be corrected in v3. Thanks.

-- 
Mel Gorman
SUSE Labs
