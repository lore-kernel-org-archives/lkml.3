Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269Ab3IDRVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:21:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33876 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3IDRVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:21:45 -0400
Message-ID: <52276BF2.1050902@infradead.org>
Date: Wed, 04 Sep 2013 10:20:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>
CC: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, bernie@develer.com,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: do_div() silently truncates "base" to 32bit
References: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com> <52210D34.5030807@infradead.org> <CAOMFOmUav+3UqR9s5LF6n4c4oXZ-K5oBJrmLtz-PMY053vH8Rg@mail.gmail.com> <52212128.3000100@infradead.org> <1377905319.2070.38.camel@joe-AO722> <CAOMFOmVrNu2ZDrBrm7Rt_p-C3Po0d6HmyCQ2HvJSVT=cx+OjOw@mail.gmail.com> <CAOMFOmUEKWroSWRfFdHSTPfWT16s41=Qbh3FZnV4CcoaLchrLA@mail.gmail.com>
In-Reply-To: <CAOMFOmUEKWroSWRfFdHSTPfWT16s41=Qbh3FZnV4CcoaLchrLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 08:32, Anatol Pomozov wrote:
> Hi
> 
> On Fri, Aug 30, 2013 at 5:50 PM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
>> Hi, Joe
>>
>> On Fri, Aug 30, 2013 at 4:28 PM, Joe Perches <joe@perches.com> wrote:
>>> On Fri, 2013-08-30 at 15:48 -0700, Randy Dunlap wrote:
>>>> On 08/30/13 15:14, Anatol Pomozov wrote:
>>>>> But another question still remains: why compiler does not warn that
>>>>> size truncation happens? How to prevent bugs like CFQ one in the
>>>>> future? Should we add a compile-time assert to do_div() to prevent
>>>>> passing 64 numbers in "base" macro parameter?
>>>> That sounds like a fine idea to me.
>>>
>>> Geert thought so too and submitted a patch
>>>
>>> http://www.spinics.net/lists/linux-btrfs/msg26788.html
>>
>> Thanks it works!
>>
>> block/cfq-iosched.c: In function 'cfqg_prfill_avg_queue_size':
>> block/cfq-iosched.c:4423:3: error: size of unnamed array is negative
>> make[2]: *** [block/gfq-iosched.s] Error 1
>> make[1]: *** [block/gfq-iosched.s] Error 2
>> I see a number of other truncation errors. We need to fix them as well.
> 
> I looked at the places where do_div() passes incorrect parameters and
> it is quite a lot of them. It would be better to warn users until all
> the places are fixed. Is there any BUILD_WARN_ON() macro?
> 


Not that I know of or can find.

-- 
~Randy
