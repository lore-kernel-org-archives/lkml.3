Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3AKAvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:51:07 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:55681 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab3AKAvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:51:05 -0500
Date: Fri, 11 Jan 2013 00:51:05 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130111005105.GA15023@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110194212.GJ13304@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> wrote:
> mm: compaction: Partially revert capture of suitable high-order page

<snip>
 
> Reported-by: Eric Wong <normalperson@yhbt.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Thanks, my original use case and test works great after several hours!

Tested-by: Eric Wong <normalperson@yhbt.net>


Unfortunately, I also hit a new bug in 3.8 (not in 3.7.x).  based on Eric
Dumazet's observations, sk_stream_wait_memory may be to blame.
Fortunately this is easier to reproduce (I've cc-ed participants
on this thread already): <20130111004915.GA15415@dcvr.yhbt.net>
