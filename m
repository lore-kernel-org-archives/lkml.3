Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbbALTC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:02:57 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:49996 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbbALTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-7-git-send-email-john.stultz@linaro.org>
	<20150111124146.GA15387@localhost.localdomain>
	<CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
Date: Tue, 13 Jan 2015 08:02:53 +1300
X-Google-Sender-Auth: jJ2MXdLjwvVArEzP16pTl0y1luU
Message-ID: <CA+55aFxwtAG243YL5xJwCy1tJOOONx_ZqYBFsJwwbaFTmKWfLg@mail.gmail.com>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 7:54 AM, John Stultz <john.stultz@linaro.org> wrote:
>
> So I disagree this is papering over the problem.

Indeed. It's making things more robust in the face of _known_ issues.
Even with a perfectly designed timer (which we so far have never
seen), interrupts get delayed etc, so trying to stretch it to the
limit of the timer is simply not a good idea. Quite the reverse.

More importantly, if the timer is actually any good, the safety margin
won't actually matter, since the timer cycle is so long that 50% of
essentially infinite is still essentially infinite.

And if the timer isn't very good, then some slop for safety is just
being robust.

At no point is it "papering over" anything at all.

           Linus
