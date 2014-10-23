Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaJWSuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:50:51 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:49659 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJWSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:50:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141023112314.8d62733c202a527b4107eb11@linux-foundation.org>
References: <20141021202137.GA20114@www.outflux.net>
	<20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
	<CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
	<20141022190051.7c0d5df1.akpm@linux-foundation.org>
	<CAGXu5jL-6sGy2QSH39Qmu0-8MEg6aX5GCPvPKeWaheXcai0TDA@mail.gmail.com>
	<20141023112314.8d62733c202a527b4107eb11@linux-foundation.org>
Date: Thu, 23 Oct 2014 11:50:48 -0700
X-Google-Sender-Auth: UBI15LhFV5mZ1yg19EYm_gQM5QQ
Message-ID: <CAGXu5jJLhSQ0=cPm=zuYJH4gFZUHW2pgGQfUnO0+ciXQarr=QQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Wise <pabs3@bonedaddy.net>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:23 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 23 Oct 2014 09:39:09 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> > I wonder if the chances of damage would be lower if we were to continue
>> > to accept the \r, but turn it into something else ("\r"?) when it is
>> > read.
>>
>> I think that would complicate things more than help them.
>
> Why.

My thinking is that currently we're only aware of \r being used to
assist an attacker. If we "escape" \r's in our output, we might run
the risk of shells interpreting things differently than expected, etc.
Right now, both the "cat" of a sysctl, and the internal use of the
string (for say, a command line) just reads directly from the string
memory. If we add escaping to that on output, we're adding
complication to this system that I think exceeds the utility of the
protection.

More simply, I would rather leave \r as-is than introduce an escaping
mechanism for just \r. If there were other cases of equally
problematic inputs, there may be a benefit, but for just \r I think
adding complexity to the sysctl code would have a net negative result.

>> If there's a
>> legit use of \r, I'll let Paul Wise debate how to proceed. :)
>
> I don't know who Paul is.  Please take this seriously; we don't want to
> have to revert this after breaking a bunch of people's setups.

Paul is the author of the patch I forwarded. I am taking it seriously
-- the only case I can come up with for \r after continuing to ponder
this is that someone has done really strange things with a
command-line or core dump pattern. Disallowing \r would break that
case, but I cannot come up with any reason why someone would attempt
to inject \r into core files or command lines via sysctl.

If there is a legit use for \r, then we can ignore this patch
entirely. It seemed reasonable to me to send it upstream since the
only use I (and others) have seen is to obfuscate attacks. If it's an
easy fix, let's do it. If it's going to break people or add code
complexity, I don't want it.

-Kees

-- 
Kees Cook
Chrome OS Security
