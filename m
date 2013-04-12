Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3DLUH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:07:59 -0400
Received: from bitsync.net ([80.83.126.10]:41135 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab3DLUH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:07:58 -0400
Message-ID: <5168699A.40407@bitsync.net>
Date: Fri, 12 Apr 2013 22:07:54 +0200
From: Zlatko Calusic <zcalusic@bitsync.net>
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        dormando <dormando@rydia.net>, Satoru Moriya <satoru.moriya@hds.com>,
        Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Reduce system disruption due to kswapd V2
References: <1365505625-9460-1-git-send-email-mgorman@suse.de> <51672331.6070605@bitsync.net> <20130412193947.GJ11656@suse.de>
In-Reply-To: <20130412193947.GJ11656@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.04.2013 21:40, Mel Gorman wrote:
> On Thu, Apr 11, 2013 at 10:55:13PM +0200, Zlatko Calusic wrote:
>> On 09.04.2013 13:06, Mel Gorman wrote:
>> <SNIP>
>>
>> - The only slightly negative thing I observed is that with the patch
>> applied kswapd burns 10x - 20x more CPU. So instead of about 15
>> seconds, it has now spent more than 4 minutes on one particular
>> machine with a quite steady load (after about 12 days of uptime).
>> Admittedly, that's still nothing too alarming, but...
>>
>
> Would you happen to know what circumstances trigger the higher CPU
> usage?
>

Really nothing special. The server is lightly loaded, but it does enough 
reading from the disk so that pagecache is mostly populated and page 
reclaiming is active. So, kswapd is no doubt using CPU time gradually, 
nothing extraordinary.

When I sent my reply yesterday, the server uptime was 12 days, and 
kswapd had accumulated 4:28 CPU time. Now, approx 24 hours later (13 
days uptime):

root        23  0.0  0.0      0     0 ?        S    Mar30   4:52 [kswapd0]

I will apply your v3 series soon and see if there's any improvement wrt 
CPU usage, although as I said I don't see that as a big issue. It's 
still only 0.013% of available CPU resources (dual core CPU).

-- 
Zlatko

