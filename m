Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946401Ab3BHNfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:35:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51362 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946057Ab3BHNen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:34:43 -0500
Date: Fri, 8 Feb 2013 07:34:41 -0600
From: Robin Holt <holt@sgi.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Linux MM <linux-mm@kvack.org>, mgorman@suse.de, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: rename confusing function names
Message-ID: <20130208133441.GH3460@sgi.com>
References: <51113CE3.5090000@gmail.com>
 <20130205192640.GC6481@cmpxchg.org>
 <20130205141332.04fcceac.akpm@linux-foundation.org>
 <5111AC7D.9070505@cn.fujitsu.com>
 <20130205172057.3be4dbd4.akpm@linux-foundation.org>
 <5111B318.9020204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5111B318.9020204@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > static unsigned int nr_free_zone_pages(int offset)
> > {
> > 	...
> > 	unsigned int sum = 0;
> > 	...
> > 	return sum;
> > }
> > 
> > How long will it be until these things start exploding from
> > sums-of-zones which exceed 16TB?  
> > 
> 
> You mean overflow? Hmm.. it might happens. Change the sum to
> unsigned long is ok?

We are in the process right now of building a 32TB machine.  Let me make
a note about this right away.  Thankfully, the memory will be spread
over 256 zones so it should not impact us right away.

Thanks,
Robin
