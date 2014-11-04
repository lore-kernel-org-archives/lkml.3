Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaKDB0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:26:04 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:39543 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaKDB0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:26:01 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com> <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 17:25:38 -0800
Message-ID: <CALCETrUAkXKyXzZy4xaYcW2f65Lh=APrU4cFU1zm-qmc6EwB8g@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 5:11 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Mon, Nov 3, 2014 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Nov 3, 2014 at 4:28 PM, Pawel Moll <pawel.moll@arm.com> wrote:
>>> From: Pawel Moll <mail@pawelmoll.com>
>>> Thomas suggested solution which gets down to my original proposal for
>>> sched/monotonic clock correlation - an additional sample type so events
>>> can be "double stamped" using different clock sources providing
>>> synchronisation points for later time approximation. I've just extended
>>> the implementation with configuration value to select the clock source.
>>> If the first patch (making perf timestamps monotonic) gets accepted,
>>> there will be no immediate need for this one, but I'd like to gain some
>>> feedback anyway.
>>>
>>
>> I have nothing intelligent to add to the potentional Thomas/Ingo
>> showdown, but I do have a related thought. :)
>>
>> If you're going to add double-stamped packets, can you also add a
>> syscall to read multiple clocks at once, atomically?  Or can you
>> otherwise add a non-perf mechanism to get at this data?
>>
>> Because the realtime to monotonic offset is really quite useful for
>> things like this, and it seems silly to make people actually open a
>> perf_event to get at it.
>
> So this comes up periodically, but I don't think I've seen a interface
> proposal that was decent yet.
>
> Also, if you want to read multiple clocks at once, do you stop at two,
> or three, or... there's possibly quite a few.  Additionally some
> clocks may not be possible to read atomically (perf/sched clock and
> system time for example may be based on different underlying
> clocksources). The general idea feels like its creeping towards some
> "atomically expose all timekeeping state" mega-interface.
>
> I've got some thoughts on what a possible interface that wouldn't be
> awful could look like, but I'm still hesitant because I don't really
> know if exposing this sort of data is actually a good idea long term.

My only real thought here is that, if perf is going to try to do this,
then presumably it should be reasonably integrated w/ the core timing
code.  I.e. if perf does this, then presumably the core code should
know about it and there should be a core interface to it.

--Andy

>
> thanks
> -john



-- 
Andy Lutomirski
AMA Capital Management, LLC
