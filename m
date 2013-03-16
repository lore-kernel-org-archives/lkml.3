Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3CPRsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:48:23 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48703 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab3CPRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:48:21 -0400
Message-ID: <5144B05E.9040307@gmail.com>
Date: Sun, 17 Mar 2013 01:48:14 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2, part3 01/12] mm: enhance free_reserved_area() to support
 poisoning memory with zero
References: <1363453413-8139-1-git-send-email-jiang.liu@huawei.com> <1363453413-8139-2-git-send-email-jiang.liu@huawei.com> <CAMuHMdUbg67zLqn7x_vpzEWpbuwjmxO5MYRNJQhxMpqtLxTVOg@mail.gmail.com>
In-Reply-To: <CAMuHMdUbg67zLqn7x_vpzEWpbuwjmxO5MYRNJQhxMpqtLxTVOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 01:37 AM, Geert Uytterhoeven wrote:
> On Sat, Mar 16, 2013 at 6:03 PM, Jiang Liu <liuj97@gmail.com> wrote:
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5130,13 +5130,13 @@ unsigned long free_reserved_area(unsigned long start, unsigned long end,
>>         pos = start = PAGE_ALIGN(start);
>>         end &= PAGE_MASK;
>>         for (pages = 0; pos < end; pos += PAGE_SIZE, pages++) {
>> -               if (poison)
>> +               if ((unsigned int)poison <= 0xFF)
> 
> "if (poison >= 0)"? No cast needed.
Hi Geert,
	We constraints valid inputs as [0, UCHAR_MAX], so the code follows the comment as below.
/*
 * Free reserved pages within range [PAGE_ALIGN(start), end & PAGE_MASK)
 * into the buddy system. The freed pages will be poisoned with pattern
 * "poison" if it's within range [0, UCHAR_MAX].
 * Return pages freed into the buddy system.
 */

Regards!
Gerry

> 
>>                         memset((void *)pos, poison, PAGE_SIZE);
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

