Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaEMOa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760129AbaEMOay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:30:54 -0400
Date: Tue, 13 May 2014 15:30:50 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 17/19] fs: buffer: Do not use unnecessary atomic
 operations when discarding buffers
Message-ID: <20140513143050.GU23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-18-git-send-email-mgorman@suse.de>
 <20140513110951.GB30445@twins.programming.kicks-ass.net>
 <20140513125007.GQ23991@suse.de>
 <20140513134943.GD22070@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140513134943.GD22070@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:49:43PM +0200, Jan Kara wrote:
> > > operation which is available on a lot of architectures, we'll be stuck
> > > with a cmpxchg loop instead :/
> > > 
> > > *sigh*
> > > 
> > > Anyway, nothing wrong with this patch, however, you could, if you really
> > > wanted to push things, also include BH_Lock in that clear :-)
> > 
> > That's a bold strategy Cotton.
> > 
> > Untested patch on top
>   Although this looks correct, I have to say I prefer the explicit
> unlock_buffer() unless this has a measurable benefit.
> 

I will keep this as a separate patch, move it to the end of the series
and check what the profiles look like. Thanks.

-- 
Mel Gorman
SUSE Labs
