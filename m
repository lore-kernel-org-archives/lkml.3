Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbbALUiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:38:04 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62094 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbbALUiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:38:03 -0500
Date: Mon, 12 Jan 2015 21:37:57 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
Message-ID: <20150112203757.GC4233@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
 <20150111124146.GA15387@localhost.localdomain>
 <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
 <CA+55aFxwtAG243YL5xJwCy1tJOOONx_ZqYBFsJwwbaFTmKWfLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwtAG243YL5xJwCy1tJOOONx_ZqYBFsJwwbaFTmKWfLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 08:02:53AM +1300, Linus Torvalds wrote:
> Indeed. It's making things more robust in the face of _known_ issues.
> Even with a perfectly designed timer (which we so far have never
> seen), interrupts get delayed etc, so trying to stretch it to the
> limit of the timer is simply not a good idea. Quite the reverse.

So is this patch supposed to fix the case when a tick just missed the
range of the clock?  Or is this to deal with really broken sources?

> More importantly, if the timer is actually any good, the safety margin
> won't actually matter, since the timer cycle is so long that 50% of
> essentially infinite is still essentially infinite.
> 
> And if the timer isn't very good, then some slop for safety is just
> being robust.

Here "isn't very good" means that the clock rolls over too frequently.
Well, if you cannot be sure to sample the clock in time, then you
shouldn't use that clock source at all.

Thanks,
Richard
