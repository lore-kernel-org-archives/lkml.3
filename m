Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaJMPRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:17:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbaJMPRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:17:31 -0400
Date: Mon, 13 Oct 2014 16:17:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/97] mm, thp: do not allow thp faults to avoid cpuset
 restrictions
Message-ID: <20141013151727.GB23874@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
 <1409250945-30874-9-git-send-email-mgorman@suse.de>
 <5425378A.4090702@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5425378A.4090702@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:53:14AM +0200, Jiri Slaby wrote:
> On 08/28/2014, 08:34 PM, Mel Gorman wrote:
> > From: David Rientjes <rientjes@google.com>
> > 
> > commit b104a35d32025ca740539db2808aa3385d0f30eb upstream.
> > 
> > The page allocator relies on __GFP_WAIT to determine if ALLOC_CPUSET
> > should be set in allocflags.  ALLOC_CPUSET controls if a page allocation
> > should be restricted only to the set of allowed cpuset mems.
> > 
> > Transparent hugepages clears __GFP_WAIT when defrag is disabled to prevent
> > the fault path from using memory compaction or direct reclaim.  Thus, it
> > is unfairly able to allocate outside of its cpuset mems restriction as a
> > side-effect.
> > 
> > This patch ensures that ALLOC_CPUSET is only cleared when the gfp mask is
> > truly GFP_ATOMIC by verifying it is also not a thp allocation.
> 
> Hi, the time has come to apply this series. Thanks a lot for doing that.
> 

Thanks for picking them up!

-- 
Mel Gorman
SUSE Labs
