Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaJ0OkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:40:19 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:50751 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaJ0OkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:40:17 -0400
Message-ID: <544E58E3.9040100@imgtec.com>
Date: Mon, 27 Oct 2014 14:38:27 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC] mm: memblock: change default cnt for regions from 1 to
 0
References: <1414083413-61756-1-git-send-email-Zubair.Kakakhel@imgtec.com> <20141023121840.f88439912f23a3c2a01eb54f@linux-foundation.org> <20141027141730.GL4436@htj.dyndns.org>
In-Reply-To: <20141027141730.GL4436@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 27/10/14 14:17, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 23, 2014 at 12:18:40PM -0700, Andrew Morton wrote:
>> On Thu, 23 Oct 2014 17:56:53 +0100 Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com> wrote:
>>
>>> The default region counts are set to 1 with a comment saying empty
>>> dummy entry.
>>>
>>> If this is a dummy entry, should this be changed to 0?
> 
> My memory is hazy now but I'm pretty sure there's a bunch of stuff
> assuming that the array is never empty.
> 
>>> We have faced this in mips/kernel/setup.c arch_mem_init.
>>>
>>> cma uses memblock. But even with cma disabled.
>>> The for_each_memblock(reserved, reg) goes inside the loop.
>>> Even without any reserved regions.
> 
> Does that matter?  It's a zero-length reservation.
> 
>>> Traced it to the following, when the macro
>>> for_each_memblock(memblock_type, region) is used.
>>>
>>> It expands to add the cnt variable.
>>>
>>> for (region = memblock.memblock_type.regions; 		\
>>> 	region < (memblock.memblock_type.regions + memblock.memblock_type.cnt); \
>>> 	region++)
>>>
>>> In the corner case, that there are no reserved regions.
>>> Due to the default 1 value of cnt.
>>> The loop under for_each_memblock still runs once.
>>>
>>> Even when there is no reserved region.
>>>
>>> Is this by design? or unintentional?
> 
> It's by design.
> 
>>> It might be that this loop runs an extra time every instance out there?
> 
> The first actual entry replaces the dummy one and the last removal
> makes the entry dummy again, so the dummy one exists iff that's the
> only entry.  I don't recall the exact details right now but the choice
> was an intentional one.
> 
> Thanks.
> 

Thank-you for clarifying.

Regards
ZubairLK
