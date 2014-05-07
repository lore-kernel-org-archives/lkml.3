Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaEGJnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:43:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbaEGJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:43:19 -0400
Date: Wed, 7 May 2014 10:43:16 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] mm: page_alloc: Use jump labels to avoid checking
 number_of_cpusets
Message-ID: <20140507094316.GG23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-4-git-send-email-mgorman@suse.de>
 <20140506202350.GE1429@laptop.programming.kicks-ass.net>
 <20140506222118.GB23991@suse.de>
 <20140507090421.GO11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140507090421.GO11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:04:21AM +0200, Peter Zijlstra wrote:
> On Tue, May 06, 2014 at 11:21:18PM +0100, Mel Gorman wrote:
> > On Tue, May 06, 2014 at 10:23:50PM +0200, Peter Zijlstra wrote:
> 
> > > Why the HAVE_JUMP_LABEL and number_of_cpusets thing? When
> > > !HAVE_JUMP_LABEL the static_key thing reverts to an atomic_t and
> > > static_key_false() becomes:
> > > 
> > 
> > Because number_of_cpusets is used to size a kmalloc(). Potentially I could
> > abuse the internals of static keys and use the value of key->enabled but
> > that felt like abuse of the API.
> 
> But are those ifdefs worth the saving of 4 bytes of .data?
> 
> That said, I see no real problem adding static_key_count().

I thought it would be considered API abuse as I always viewed the labels
as being a enabled/disabled thing with the existence of the ref count
being an internal implementation detail. I'll take this approach.

Thanks.

-- 
Mel Gorman
SUSE Labs
