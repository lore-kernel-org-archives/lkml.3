Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaGAICN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:02:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbaGAICK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:02:10 -0400
Date: Tue, 1 Jul 2014 09:02:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/4] mm: page_alloc: Reduce cost of the fair zone
 allocation policy
Message-ID: <20140701080205.GT10819@suse.de>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
 <1404146883-21414-5-git-send-email-mgorman@suse.de>
 <20140630141404.e09bdb5fa6a879d17c4556b1@linux-foundation.org>
 <20140630215121.GQ10819@suse.de>
 <20140630150914.6db3805c28c60283deb94206@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140630150914.6db3805c28c60283deb94206@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:09:14PM -0700, Andrew Morton wrote:
> On Mon, 30 Jun 2014 22:51:21 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > > That's a large change in system time.  Does this all include kswapd
> > > activity?
> > > 
> > 
> > I don't have a profile to quantify that exactly. It takes 7 hours to
> > complete a test on that machine in this configuration
> 
> That's nuts.  Why should measuring this require more than a few minutes?

That's how long the full test takes to complete for each part of the IO
test. Profiling a subsection of it will miss some parts with no
guarantee the sampled subset is representative. Profiling for smaller
amounts of IO so the test completes quickly does not guarantee that the
sample is representative. Reducing the size of memory of the machine
using any tricks is also not representative etc.

-- 
Mel Gorman
SUSE Labs
