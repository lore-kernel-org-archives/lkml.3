Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3GOBiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 21:38:52 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50854 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3GOBiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 21:38:51 -0400
Message-ID: <51E3529F.6070909@gmail.com>
Date: Mon, 15 Jul 2013 09:38:39 +0800
From: Sam Ben <sam.bennn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Robin Holt <holt@sgi.com>,
        Robert Richter <rric@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: boot tracing
References: <1373594635-131067-1-git-send-email-holt@sgi.com> <20130712082756.GA4328@gmail.com> <20130712084712.GD24008@pd.tnic> <20130712085341.GC4328@gmail.com>
In-Reply-To: <20130712085341.GC4328@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 04:53 PM, Ingo Molnar wrote:
> * Borislav Petkov <bp@alien8.de> wrote:
>
>> On Fri, Jul 12, 2013 at 10:27:56AM +0200, Ingo Molnar wrote:
>>> Robert Richter and Boris Petkov are working on 'persistent events'
>>> support for perf, which will eventually allow boot time profiling -
>>> I'm not sure if the patches and the tooling support is ready enough
>>> yet for your purposes.
>> Nope, not yet but we're getting there.
>>
>>> Robert, Boris, the following workflow would be pretty intuitive:
>>>
>>>   - kernel developer sets boot flag: perf=boot,freq=1khz,size=16MB
>> What does perf=boot mean? I assume boot tracing.
> In this case it would mean boot profiling - i.e. a cycles hardware-PMU
> event collecting into a perf trace buffer as usual.
>
> Essentially a 'perf record -a' work-alike, just one that gets activated as
> early as practical, and which would allow the profiling of memory
> initialization.
>
> Now, one extra complication here is that to be able to profile buddy
> allocator this persistent event would have to work before the buddy
> allocator is active :-/ So this sort of profiling would have to use
> memblock_alloc().

Could perf=boot be used to sample the performance of memblock subsystem? 
I think the perf subsystem is too late to be initialized and monitor this.

>
> Just wanted to highlight this usecase, we might eventually want to support
> it.
>
> [ Note that this is different from boot tracing of one or more trace
>    events - but it's a conceptually pretty close cousin. ]
>   
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

