Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaKDBL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:11:57 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35767 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaKDBLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:11:54 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
Date: Mon, 3 Nov 2014 17:11:53 -0800
Message-ID: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
From: John Stultz <john.stultz@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
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

On Mon, Nov 3, 2014 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Nov 3, 2014 at 4:28 PM, Pawel Moll <pawel.moll@arm.com> wrote:
>> From: Pawel Moll <mail@pawelmoll.com>
>> Thomas suggested solution which gets down to my original proposal for
>> sched/monotonic clock correlation - an additional sample type so events
>> can be "double stamped" using different clock sources providing
>> synchronisation points for later time approximation. I've just extended
>> the implementation with configuration value to select the clock source.
>> If the first patch (making perf timestamps monotonic) gets accepted,
>> there will be no immediate need for this one, but I'd like to gain some
>> feedback anyway.
>>
>
> I have nothing intelligent to add to the potentional Thomas/Ingo
> showdown, but I do have a related thought. :)
>
> If you're going to add double-stamped packets, can you also add a
> syscall to read multiple clocks at once, atomically?  Or can you
> otherwise add a non-perf mechanism to get at this data?
>
> Because the realtime to monotonic offset is really quite useful for
> things like this, and it seems silly to make people actually open a
> perf_event to get at it.

So this comes up periodically, but I don't think I've seen a interface
proposal that was decent yet.

Also, if you want to read multiple clocks at once, do you stop at two,
or three, or... there's possibly quite a few.  Additionally some
clocks may not be possible to read atomically (perf/sched clock and
system time for example may be based on different underlying
clocksources). The general idea feels like its creeping towards some
"atomically expose all timekeeping state" mega-interface.

I've got some thoughts on what a possible interface that wouldn't be
awful could look like, but I'm still hesitant because I don't really
know if exposing this sort of data is actually a good idea long term.

thanks
-john
