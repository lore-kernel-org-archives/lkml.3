Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3JNPee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:34:34 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39907 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3JNPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:34:33 -0400
Message-ID: <525C0EFE.2010409@gmail.com>
Date: Mon, 14 Oct 2013 23:34:22 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <5258E560.5050506@cn.fujitsu.com> <525B19C3.9040907@gmail.com> <20131014133835.GG4722@htj.dyndns.org> <525BFCF3.5010908@gmail.com> <20131014142719.GI4722@htj.dyndns.org> <525C02DC.4050706@gmail.com> <20131014145131.GJ4722@htj.dyndns.org> <525C0866.2010808@gmail.com> <20131014151902.GL4722@htj.dyndns.org>
In-Reply-To: <20131014151902.GL4722@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tejun,

On 10/14/2013 11:19 PM, Tejun Heo wrote:
> Hey,
> 
> On Mon, Oct 14, 2013 at 11:06:14PM +0800, Zhang Yanfei wrote:
>> a little difference here, consider a 16-GB node. If we parse SRAT earlier,
>> and still use the top-down allocation, and kernel image is loaded at 16MB,
>> we reserve other nodes but this 16GB node that kernel resides in is used
>> for boot-up allocation. So the page table is allocated from 16GB to 0.
>> The page table is allocated on top of the the memory as possible.
>>
>> But if we use this approach, no matter how large the page table is, we 
>> allocate the page table in low memory which is the case that hpa concerns
>> about the DMA.
> 
> Yeah, sure there will be cases where parsing SRAT would be better.
> 
>  4k mapping is in use, which is mostly for debugging && memory map is
>  composed such that the highest non-hotpluggable address is high
>  enough.
> 
> It's going in circles again but my point has always been that the
> above in itself don't seem to be substantial enough to justify
> putting, say, initrd loading before page table init.
> 
> Later some argued that bringing SRAT parsing earlier could help
> implementing finer grained hotplug, which would be an acceptable path
> to follow; however, that doesn't turn out to be true either.
> 
> * Again, it matter if and only if 4k mapping is in use.  Do we even
>   care?
> 
> * SRAT isn't enough.  The whole device tree needs to be parsed to put
>   page tables into local device.  It's a lot of churn, including major
>   updates to page table allocation, just to support debug 4k mapping
>   cases.  Doesn't make much sense to me.
> 
> So, SRAT's usefulness seems extremely limited - it helps if the user
> wants to use debug features along with memory hotplug on an extreme
> large machine with devices which have low DMA limit, and that's it.
> To me, it seems to be a poor argument.  Just declaring memory hotplug
> works iff large kernel mapping is in use feels like a pretty good
> trade-off to me, and I have no idea why I have to repeat all this,
> which I've written multiple times already, in a private thread again.
> 
> If the thread is to make progress, one has to provide counter
> arguments to the points raised.  It feels like I'm going in circle
> again.  The exact same content I wrote above has been repeated
> multiple times in the past discussions and I'm getting tired of doing
> it without getting any actual response.
> 
> When replying, please restore cc's and keep the whole body.
> 

Thanks for the whole explanation again. I was just raising some argument
that other guys raised before. I agree with what you said above and already
put some of them into the patch 4 description in v7 version.

Now could you please help reviewing the part2? As I said before, no matter
how we implement the part1, part2 is kind of independent.

-- 
Thanks.
Zhang Yanfei
