Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaKFViK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:38:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKFViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:38:08 -0500
Message-ID: <545BEA3B.40005@suse.cz>
Date: Thu, 06 Nov 2014 22:38:03 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "P. Christeas" <xrg@linux.gr>
CC: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos> <2357788.X5UHX7WJZF@xorhgos3.pefnos> <545A419C.3090900@suse.cz> <3583067.00bS4AInhm@xorhgos3.pefnos>
In-Reply-To: <3583067.00bS4AInhm@xorhgos3.pefnos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 08:23 PM, P. Christeas wrote:
> On Wednesday 05 November 2014, Vlastimil Babka wrote:
>> Can you please try the following patch?
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1325,13 +1325,6 @@ unsigned long try_to_compact_pages(struct zonelist
>> -			compaction_defer_reset(zone, order, false);
> 
> NACK :(

Sigh.

> I just got again into a state that some task was spinning out of control, and 
> blocking the rest of the desktop.

Well this is similar to reports [1] and [2] except [1] points to
isolate_freepages_block() and your traces only go as deep as compact_zone. Which
probably inlines isolate_migratepages* but I would expect it cannot inline
isolate_freepages* due to invocation via pointer.

> You will see me trying a few things, apparently the first OOM managed to 
> unblock something, but a few seconds later the system "stepped" on some other 
> blocking task.
> 
> See attached log, it may only give you some hint; the problem could well be in 
> some other part of the kernel.

Well I doubt that but I'd like to be surprised :)

> In the meanwhile, I'm pulling linus/master ...

Could you perhaps bisect the most suspicious part? It's not a lot of commits
and you seem to be reproducing this quite easily?

commit 447f05bb488bff4282088259b04f47f0f9f76760 should be good
commit 6d7ce55940b6ecd463ca044ad241f0122d913293 should be bad

If that's true, then bisection should find the cause rather quickly.

Oh and did I ask in this thread for /proc/zoneinfo yet? :)

Thanks.

> kcrash.log
> 

[1]
http://article.gmane.org/gmane.linux.kernel.mm/124451/match=isolate_freepages_block+very+high+intermittent+overhead

[2] https://lkml.org/lkml/2014/11/4/904

