Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3KHKoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:44:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32996 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab3KHKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:44:37 -0500
Message-ID: <527CC072.1000200@oracle.com>
Date: Fri, 08 Nov 2013 18:44:02 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        hughd@google.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <20131107070451.GA10645@bbox>
In-Reply-To: <20131107070451.GA10645@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 03:04 PM, Minchan Kim wrote:
> On Wed, Nov 06, 2013 at 07:05:11PM -0800, Greg KH wrote:
>> On Wed, Nov 06, 2013 at 03:46:19PM -0800, Nitin Gupta wrote:
>>  > I'm getting really tired of them hanging around in here for many years
>>>> now...
>>>>
>>>
>>> Minchan has tried many times to promote zram out of staging. This was
>>> his most recent attempt:
>>>
>>> https://lkml.org/lkml/2013/8/21/54
>>>
>>> There he provided arguments for zram inclusion, how it can help in
>>> situations where zswap can't and why generalizing /dev/ramX would
>>> not be a great idea. So, cannot say why it wasn't picked up
>>> for inclusion at that time.
>>>
>>>> Should I just remove them if no one is working on getting them merged
>>>> "properly"?
>>>>
>>>
>>> Please refer the mail thread (link above) and see Minchan's
>>> justifications for zram.
>>> If they don't sound convincing enough then please remove zram+zsmalloc
>>> from staging.
>>
>> You don't need to be convincing me, you need to be convincing the
>> maintainers of the area of the kernel you are working with.
>>
>> And since the last time you all tried to get this merged was back in
>> August, I'm feeling that you all have given up, so it needs to be
>> deleted.  I'll go do that for 3.14, and if someone wants to pick it up
>> and merge it properly, they can easily revert it.
> 
> I'm guilty and I have been busy by other stuff. Sorry for that.
> Fortunately, I discussed this issue with Hugh in this Linuxcon for a
> long time(Thanks Hugh!) he felt zram's block device abstraction is
> better design rather than frontswap backend stuff although it's a question
> where we put zsmalloc. I will CC Hugh because many of things is related
> to swap subsystem and his opinion is really important.
> And I discussed it with Rik and he feel positive about zram.
> 
> Last impression Andrw gave me by private mail is he want to merge
> zram's functionality into zswap or vise versa.
> If I misunderstood, please correct me.
> I understand his concern but I guess he didn't have a time to read
> my long description due to a ton of works at that time.
> So, I will try one more time.
> I hope I'd like to listen feedback than *silence* so that we can
> move forward than stall.
> 
> Recently, Bob tried to move zsmalloc under mm directory to unify
> zram and zswap with adding pseudo block device in zswap(It's
> very weired to me. I think it's horrible monster which is lying
> between mm and block in layering POV) but he was ignoring zram's
> block device (a.k.a zram-blk) feature and considered only swap
> usecase of zram, in turn, it lose zram's good concept. 
> I already convered other topics Bob raised in this thread[1]
> and why I think zram is better in the thread.
> 

I have no objections for zram, and I also think is good for zswap can
support zsmalloc and fake swap device. At least users can have more
options just like slab/slub/slob.

-- 
Regards,
-Bob
