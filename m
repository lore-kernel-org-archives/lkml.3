Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3LJLuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:50:16 -0500
Received: from relay.parallels.com ([195.214.232.42]:52411 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:50:13 -0500
Message-ID: <52A6FFF0.6080207@parallels.com>
Date: Tue, 10 Dec 2013 15:50:08 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <dchinner@redhat.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <devel@openvz.org>,
        <glommer@openvz.org>, <glommer@gmail.com>,
        Glauber Costa <gloomer@openvz.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v13 13/16] vmscan: take at least one pass with shrinkers
References: <cover.1386571280.git.vdavydov@parallels.com> <5287164773f8aade33ce17f3c91546c6e1afaf85.1386571280.git.vdavydov@parallels.com> <20131210041826.GB31386@dastard>
In-Reply-To: <20131210041826.GB31386@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 08:18 AM, Dave Chinner wrote:
> On Mon, Dec 09, 2013 at 12:05:54PM +0400, Vladimir Davydov wrote:
>> From: Glauber Costa <glommer@openvz.org>
>>
>> In very low free kernel memory situations, it may be the case that we
>> have less objects to free than our initial batch size. If this is the
>> case, it is better to shrink those, and open space for the new workload
>> then to keep them and fail the new allocations.
>>
>> In particular, we are concerned with the direct reclaim case for memcg.
>> Although this same technique can be applied to other situations just as
>> well, we will start conservative and apply it for that case, which is
>> the one that matters the most.
> This should be at the start of the series.

Since Glauber wanted to introduce this only for memcg-reclaim first,
this can't be at the start of the series, but I'll move it to go
immediately after per-memcg shrinking core in the next iteration.

Thanks.
