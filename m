Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936388Ab3DIUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:52:49 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50967 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936140Ab3DIUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:52:48 -0400
Message-ID: <51647F94.6000907@linux.vnet.ibm.com>
Date: Tue, 09 Apr 2013 15:52:36 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        Shuah Khan <shuah@gonehiking.org>
Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from
 zram in-memory)
References: <1365400862-9041-1-git-send-email-minchan@kernel.org> <f3c8ef05-a880-47db-86dd-156038fc7d0f@default> <20130409012719.GB3467@blaptop> <20130409013606.GC3467@blaptop>
In-Reply-To: <20130409013606.GC3467@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040920-9264-0000-0000-0000037C339A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 08:36 PM, Minchan Kim wrote:
> On Tue, Apr 09, 2013 at 10:27:19AM +0900, Minchan Kim wrote:
>> Hi Dan,
>>
>> On Mon, Apr 08, 2013 at 09:32:38AM -0700, Dan Magenheimer wrote:
>>>> From: Minchan Kim [mailto:minchan@kernel.org]
>>>> Sent: Monday, April 08, 2013 12:01 AM
>>>> Subject: [PATCH] mm: remove compressed copy from zram in-memory
>>>
>>> (patch removed)
>>>
>>>> Fragment ratio is almost same but memory consumption and compile time
>>>> is better. I am working to add defragment function of zsmalloc.
>>>
>>> Hi Minchan --
>>>
>>> I would be very interested in your design thoughts on
>>> how you plan to add defragmentation for zsmalloc.  In
>>
>> What I can say now about is only just a word "Compaction".
>> As you know, zsmalloc has a transparent handle so we can do whatever
>> under user. Of course, there is a tradeoff between performance 
>> and memory efficiency. I'm biased to latter for embedded usecase.
>>
>> And I might post it because as you know well, zsmalloc
> 
> Incomplete sentense,
> 
> I might not post it until promoting zsmalloc because as you know well,
> zsmalloc/zram's all new stuffs are blocked into staging tree.
> Even if we could add it into staging, as you know well, staging is where
> every mm guys ignore so we end up needing another round to promote it. sigh.

Yes. The lack of compaction/defragmentation support in zsmalloc has not
been raised as an obstacle to mainline acceptance so I think we should
wait to add new features to a yet-to-be accepted codebase.

Also, I think this feature is more important to zram than it is to
zswap/zcache as they can do writeback to free zpages.  In other words,
the fragmentation is a transient issue for zswap/zcache since writeback
to the swap device is possible.

Thanks,
Seth

