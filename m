Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaIZJxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:53:23 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55367 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaIZJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:53:18 -0400
Message-ID: <5425378A.4090702@suse.cz>
Date: Fri, 26 Sep 2014 11:53:14 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/97] mm, thp: do not allow thp faults to avoid cpuset
 restrictions
References: <1409250945-30874-1-git-send-email-mgorman@suse.de> <1409250945-30874-9-git-send-email-mgorman@suse.de>
In-Reply-To: <1409250945-30874-9-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014, 08:34 PM, Mel Gorman wrote:
> From: David Rientjes <rientjes@google.com>
> 
> commit b104a35d32025ca740539db2808aa3385d0f30eb upstream.
> 
> The page allocator relies on __GFP_WAIT to determine if ALLOC_CPUSET
> should be set in allocflags.  ALLOC_CPUSET controls if a page allocation
> should be restricted only to the set of allowed cpuset mems.
> 
> Transparent hugepages clears __GFP_WAIT when defrag is disabled to prevent
> the fault path from using memory compaction or direct reclaim.  Thus, it
> is unfairly able to allocate outside of its cpuset mems restriction as a
> side-effect.
> 
> This patch ensures that ALLOC_CPUSET is only cleared when the gfp mask is
> truly GFP_ATOMIC by verifying it is also not a thp allocation.

Hi, the time has come to apply this series. Thanks a lot for doing that.

It all applies cleanly except this one, as it is already in 2.6.27. So
skipping makes it work nicely.

-- 
js
suse labs
