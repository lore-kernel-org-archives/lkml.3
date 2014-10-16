Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaJPV3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:29:22 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:62432 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:29:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141016141727.4a9e0af30568f6cf0e5bad8e@linux-foundation.org>
References: <1412514377-19387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1412514377-19387-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141015151511.ea81b39adcee0954518bf5f3@linux-foundation.org>
 <CAFo99gZqNwwQMknCSW8uQSfJS2Lheq0gwQKNSBp1XTQGd3nQ=w@mail.gmail.com> <20141016141727.4a9e0af30568f6cf0e5bad8e@linux-foundation.org>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 16 Oct 2014 23:28:59 +0200
Message-ID: <CAFo99gapEYHVqB=-4o8QND19t1UjRnbJiy6APL90uM4d=-VL_w@mail.gmail.com>
Subject: Re: [PATCH v2] lib: string.c: Added a funktion function strzcpy
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-16 23:17 GMT+02:00 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 16 Oct 2014 23:09:00 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> 2014-10-16 0:15 GMT+02:00 Andrew Morton <akpm@linux-foundation.org>:
>> > On Sun,  5 Oct 2014 15:06:17 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>> >
>> >> Added a function strzcpy which works the same as strncpy,
>> >> but guaranteed to produce the trailing null character.
>> >>
>> >> There are many places in the code where strncpy used although it
>> >> must be zero terminated, and switching to strlcpy is not an option
>> >> because the string must nonetheless be fyld with zero characters.
>> >
>> > As I mentioned last time, I think this patch would be better if it came
>> > with follow-on patches which convert at least some of those callsites.
>> > As it stands, this function has no callers and hence it won't get
>> > tested.  Plus those follow-on patches will demonstrate the value of
>> > this patch and will provide example usages.
>>
>>
>> Hi
>>
>> Sure I can do that! I have saved some patches just to be able to use
>> this new feature.
>> But should I submit everything as one patch then?
>> Or is there some kind of dependency thing I can use...
>
> [patch 1/N] lib/string.c: add strzcpy()
> [patch 2/N] foo/bar/zot.c: use strzcpy()
> [patch 3/N] fooz/barz/zot.c: use strzcpy()
> ...
>
>> I have also e-mailed with Dan about this, he pointed out the same as
>> some of my tests indicate that strzcpy maybe just should use strncpy
>> and add a null character instead because strncpy is optimized
>> depending on the hardware it runs on.
>> What do you think about that?
>
> Sounds like strzcpy() should be used in places where the entire buffer
> will be copied out to userspace, or in other situations where we want to
> zero it out for security reasons?


Hi

So that's how you write it, ok I will send them this weekend when I
have some more time.

Yes it was the safety aspect I was most yelled at when I start
swapping strncpy with strlcpy, although much of it was justified!

Even Linus was getting into the debate.  See more:
https://plus.google.com/111049168280159033135/posts/1amLbuhWbh5


Kind regards
Rickard Strandqvist
