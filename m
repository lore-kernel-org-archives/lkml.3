Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbaKDA65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:58:57 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33310 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKDA6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:58:53 -0500
MIME-Version: 1.0
In-Reply-To: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 16:58:32 -0800
Message-ID: <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
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

On Mon, Nov 3, 2014 at 4:28 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> From: Pawel Moll <mail@pawelmoll.com>
> Thomas suggested solution which gets down to my original proposal for
> sched/monotonic clock correlation - an additional sample type so events
> can be "double stamped" using different clock sources providing
> synchronisation points for later time approximation. I've just extended
> the implementation with configuration value to select the clock source.
> If the first patch (making perf timestamps monotonic) gets accepted,
> there will be no immediate need for this one, but I'd like to gain some
> feedback anyway.
>

I have nothing intelligent to add to the potentional Thomas/Ingo
showdown, but I do have a related thought. :)

If you're going to add double-stamped packets, can you also add a
syscall to read multiple clocks at once, atomically?  Or can you
otherwise add a non-perf mechanism to get at this data?

Because the realtime to monotonic offset is really quite useful for
things like this, and it seems silly to make people actually open a
perf_event to get at it.

--Andy
