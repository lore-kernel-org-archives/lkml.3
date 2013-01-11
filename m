Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3AKCul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:50:41 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:56438 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3AKCuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:50:40 -0500
Date: Fri, 11 Jan 2013 02:50:39 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.8-rc2/rc3 write() blocked on CLOSE_WAIT TCP socket
Message-ID: <20130111025039.GA4723@dcvr.yhbt.net>
References: <20130111004915.GA15415@dcvr.yhbt.net>
 <1357869675.27446.2962.camel@edumazet-glaptop>
 <1357870727.27446.2988.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357870727.27446.2988.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Yes, thats definitely the problem, sorry for that.
> 
> 
> [PATCH] tcp: accept RST without ACK flag
> 
> commit c3ae62af8e755 (tcp: should drop incoming frames without ACK flag
> set) added a regression on the handling of RST messages.
> 
> RST should be allowed to come even without ACK bit set. We validate
> the RST by checking the exact sequence, as requested by RFC 793 and 
> 5961 3.2, in tcp_validate_incoming()
> 
> Reported-by: Eric Wong <normalperson@yhbt.net>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

All good here, thanks for the quick turnaround!

Tested-by: Eric Wong <normalperson@yhbt.net>

(I originally thought the FIFOs were part of the problem, so I left
 that in my test case)
