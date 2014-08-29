Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaH2JMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:12:23 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34412 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaH2JMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140829081211.GF12424@suse.de>
References: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
	<20140829081211.GF12424@suse.de>
Date: Fri, 29 Aug 2014 17:12:21 +0800
Message-ID: <CAL1ERfN9bjwGDr8=KXhSHGNCFZTw-A1+hY8Lbyr8nTmvwE3gxQ@mail.gmail.com>
Subject: Re: [PATCH] mm: page_alloc: avoid wakeup kswapd on the unintended node
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        rientjes@google.com, linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 4:12 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Fri, Aug 29, 2014 at 03:03:19PM +0800, Weijie Yang wrote:
>> When enter page_alloc slowpath, we wakeup kswapd on every pgdat
>> according to the zonelist and high_zoneidx. However, this doesn't
>> take nodemask into account, and could prematurely wakeup kswapd on
>> some unintended nodes.
>>
>> This patch uses for_each_zone_zonelist_nodemask() instead of
>> for_each_zone_zonelist() in wake_all_kswapds() to avoid the above situation.
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>
> Just out of curiousity, did you measure a problem due to this or is
> the patch due to code inspection? It was known that we examined useless
> nodes but assumed to not be a problem because the watermark check should
> prevent spurious wakeups.  However, we do a cpuset check and this patch
> is consistent with that so regardless of why you wrote the patch

It is a patch due to code review :-)

> Acked-by: Mel Gorman <mgorman@suse.de>
>
> --
> Mel Gorman
> SUSE Labs
