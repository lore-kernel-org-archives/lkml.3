Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3JCQs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:48:28 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754084Ab3JCQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:48:27 -0400
Message-ID: <524D9FD7.5050406@nod.at>
Date: Thu, 03 Oct 2013 18:48:23 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] UBI: fix refill_wl_user_pool()
References: <1380376516-30144-1-git-send-email-richard@nod.at>     <1380376516-30144-2-git-send-email-richard@nod.at>    <1380812414.27358.440.camel@sauron.fi.intel.com>  <524D8879.1030203@nod.at>  <1380814071.27358.444.camel@sauron.fi.intel.com>  <524D92E8.1030704@nod.at> <1380816035.27358.447.camel@sauron.fi.intel.com>  <524D9CE1.8040600@nod.at> <1380818515.18862.0.camel@sauron.fi.intel.com>
In-Reply-To: <1380818515.18862.0.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.10.2013 18:41, schrieb Artem Bityutskiy:
> On Thu, 2013-10-03 at 18:35 +0200, Richard Weinberger wrote:
>> Am 03.10.2013 18:00, schrieb Artem Bityutskiy:
>>> On Thu, 2013-10-03 at 17:53 +0200, Richard Weinberger wrote:
>>>> Am 03.10.2013 17:27, schrieb Artem Bityutskiy:
>>>>> On Thu, 2013-10-03 at 17:08 +0200, Richard Weinberger wrote:
>>>>>> Am 03.10.2013 17:00, schrieb Artem Bityutskiy:
>>>>>>> On Sat, 2013-09-28 at 15:55 +0200, Richard Weinberger wrote:
>>>>>>>> If no free PEBs are available refill_wl_user_pool() must not
>>>>>>>> return with -ENOSPC immediately.
>>>>>>>> It has to block till produce_free_peb() produced a free PEB.
>>>>>>>>
>>>>>>>> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
>>>>>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>>>>>
>>>>>>> What is pool size, I wonder?
>>>>>>
>>>>>> Currently it's 25 (UBI_FM_WL_POOL_SIZE).
>>>>>> If experience shows that 25 is too low/big we can change this constant.
>>>>>> Maybe it's also worth making them configurable...
>>>>>
>>>>> I if it is a possible scenario that this function will not return until
>>>>> 25 (or even 10) PEBs are erased? 
>>>>>
>>>>
>>>> Sure. It will try to gain up to 25 PEBs but return if it gets less.
>>>> That's why a pool has a current and a max size.
>>>
>>> So if erasing speed is say, 250ms, then it would take 6.25 seconds?
>>
>> Only in the very worst case if we have to call 25 times produce_free_peb().
>>
>> Of course we could add a check to return immediately if produce_free_peb()
>> got called a few times in series.
>> But I really would like to wait with such performance tweaks until fastmap
>> is more mature.
> 
> OK, but how about at least adding a comment talking about this unlikely
> scenario?

I'm fine with this. Will send a patch. :-)

Thanks,
//richard
