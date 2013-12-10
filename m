Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3LJVYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:24:09 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:48371 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LJVYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:24:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
	<CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
Date: Tue, 10 Dec 2013 13:24:06 -0800
X-Google-Sender-Auth: -X1Fm6XaFlq9LUNJye6sNt5vUlA
Message-ID: <CA+55aFzZ_pRt4CtMNLQZsNnCvNu-91ZBsEVH3QSTbYfNK998sw@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> to get a good profile for a minute, and then looking at the
> instruction-level profiles in futex_requeue() should be possible.

Ugh. Looking at kernel/futex.s even *without* debugging enabled is
pretty messy. Although much of it seems to be because the hash is
actually fairly complex. jhash2() really ends up expanding to a lot of
instructions.

But especially if that kernel was compiled with debug information,
then 'perf report' is pretty good about matching it up with the source
code, so it might not be *too* hard to try to figure out where the
loop is.

And if it's not in futex_requeue() (there are loops at other levels,
like futex_get_key()), then having the callchain information for the
costly operations will hopefully give a hint where the top loop is. So
profiling data can be very powerful for things like this.

              Linus
