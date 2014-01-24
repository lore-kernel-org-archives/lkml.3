Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaAXX1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:27:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaAXX1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:27:01 -0500
Message-ID: <52E2F6B7.3050304@redhat.com>
Date: Fri, 24 Jan 2014 18:26:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] mm: reduce reclaim stalls with heavy anon and dirty
 cache
References: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org> <20140124143003.2629e9c2c8c2595e805c8c25@linux-foundation.org> <20140124225156.GG4407@cmpxchg.org>
In-Reply-To: <20140124225156.GG4407@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 05:51 PM, Johannes Weiner wrote:
> On Fri, Jan 24, 2014 at 02:30:03PM -0800, Andrew Morton wrote:
>> On Fri, 24 Jan 2014 17:03:02 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
>>
>>> Tejun reported stuttering and latency spikes on a system where random
>>> tasks would enter direct reclaim and get stuck on dirty pages.  Around
>>> 50% of memory was occupied by tmpfs backed by an SSD, and another disk
>>> (rotating) was reading and writing at max speed to shrink a partition.
>>
>> Do you think this is serious enough to squeeze these into 3.14?
> 
> We have been biasing towards cache reclaim at least as far back as the
> LRU split and we always considered anon dirtyable, so it's not really
> a *new* problem.  And there is a chance of regressing write bandwidth
> for certain workloads by effectively shrinking their dirty limit -
> although that is easily fixed by changing dirty_ratio.
> 
> On the other hand, the stuttering is pretty nasty (could reproduce it
> locally too) and the workload is not exactly esoteric.  Plus, I'm not
> sure if waiting will increase the test exposure.
> 
> So 3.14 would work for me, unless Mel and Rik have concerns.

3.14 would be fine, indeed.

On the other hand, if there are enough user reports of the stuttering
problem on older kernels, a -stable backport could be appropriate
too...

-- 
All rights reversed
