Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3JULDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:03:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49907 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3JULDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTmFOkw5n964zGuiON1oLSy1CsPQQ8TrGNho6L-+M5Z7SA@mail.gmail.com>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
	<CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
	<1381191145.2081.230.camel@joe-AO722>
	<CAGG-pUQJCGcY=hAobBodH-dTLLohUpe6KJbuMvwWkhdt3RSk+A@mail.gmail.com>
	<CAFkjPTmFOkw5n964zGuiON1oLSy1CsPQQ8TrGNho6L-+M5Z7SA@mail.gmail.com>
Date: Mon, 21 Oct 2013 09:03:46 -0200
Message-ID: <CAGG-pUTHAnPOiX0n6FjbkhtFeiOY-704_rEvrhkzo4uv1rQ=hA@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Joe Perches <joe@perches.com>, rminnich@sandia.gov,
        Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/20 Eric Van Hensbergen <ericvh@gmail.com>:
> Please resubmit a clean patch which includes the check of sscanf for exactly
> the correct number of arguments and handles errors properly in other cases.
> That last bit may be a bit problematic since right now the only errors are
> prints and we seem to be otherwise silently failing.  Of course, looks like
> nothing else is checking return values from that function for error.  We
> could set rdev to an ERR_PTR(-EIO), and then go through and do a check in
> all the places which matter (looks like there are a few places where rdev
> just gets discarded -- might even be a good idea to not parse rdev unless we
> need to by passing NULL to p9mode2unixmode.
>
> All in all, its a corner case which is only likely with a broken server, but
> the full clean up would seem to be:
>   a) switch to u32's
>   b) pass NULL when rdev just gets discarded and don't bother parsing when
> it is
>   c) check the sscanf return validity
>   d) on error set ERR_PTR in rdev and check on return before proceeding
>
> That's a lot of cleanup, I'll add it to my work queue if you don't have time
> to rework your patch.
>

Eric, I would like to try with your guidance.

> For the other patches, anyone you didn't see a response from me on today is
> being pulled into my for-next queue.  Thanks for the cleanups.
>
>       -eric

Thanks for accept them.

>
>
>
>
> On Mon, Oct 7, 2013 at 7:18 PM, Geyslan Gregório Bem <geyslan@gmail.com>
> wrote:
>>
>> Joe,
>>
>> Nice, I'll wait their reply, there are other p9 patches that I have
>> already sent and am awaiting Eric's.
>>
>> Thank you again.
>>
>> Geyslan Gregório Bem
>> hackingbits.com
>>
>>
>> 2013/10/7 Joe Perches <joe@perches.com>:
>> > On Mon, 2013-10-07 at 21:09 -0300, Geyslan Gregório Bem wrote:
>> >> Joe,
>> >>
>> >> Thank you for reply.
>> >>
>> >> What do you think about:
>> >>
>> >>                  strncpy(ext, stat->extension, sizeof(ext));
>> >> +                 if (sscanf(ext, "%c %u %u", &type, &major, &minor) <
>> >> 3) {
>> >> +                                  p9_debug(P9_DEBUG_ERROR,
>> >> +                                  "It's necessary define type, major
>> >> and minor values when using P9_DMDEVICE");
>> >> +                                  return res;
>> >> +                 }
>> >>                  switch (type) {
>> >>                  case 'c':
>> >>                          res |= S_IFCHR;
>> >>                          break;
>> >> ...
>> >>                  *rdev = MKDEV(major, minor);
>> >
>> > I think the plan 9 folk should figure out what's right.
>> >
>> >
>
>
