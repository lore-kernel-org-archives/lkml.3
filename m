Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaJWQjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:39:11 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:58237 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaJWQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <20141022190051.7c0d5df1.akpm@linux-foundation.org>
References: <20141021202137.GA20114@www.outflux.net>
	<20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
	<CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
	<20141022190051.7c0d5df1.akpm@linux-foundation.org>
Date: Thu, 23 Oct 2014 09:39:09 -0700
X-Google-Sender-Auth: eiEx2OQPaFDTho29K8JP8A_9wds
Message-ID: <CAGXu5jL-6sGy2QSH39Qmu0-8MEg6aX5GCPvPKeWaheXcai0TDA@mail.gmail.com>
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

On Wed, Oct 22, 2014 at 7:00 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 22 Oct 2014 16:43:10 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> On Wed, Oct 22, 2014 at 4:26 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Tue, 21 Oct 2014 13:21:37 -0700 Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> From: Paul Wise <pabs3@bonedaddy.net>
>> >>
>> >> This partially mitigates a common strategy used by attackers for hiding
>> >> the full contents of strings in procfs from naive sysadmins who use cat,
>> >> more or sysctl to inspect the contents of strings in procfs.
>> >>
>> >> ...
>> >>
>> >> --- a/kernel/sysctl.c
>> >> +++ b/kernel/sysctl.c
>> >> @@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, int maxlen, int write,
>> >>               while ((p - buffer) < *lenp && len < maxlen - 1) {
>> >>                       if (get_user(c, p++))
>> >>                               return -EFAULT;
>> >> -                     if (c == 0 || c == '\n')
>> >> +                     if (c == 0 || c == '\n' || c == '\r')
>> >>                               break;
>> >>                       data[len++] = c;
>> >>               }
>> >
>> > There are no valid uses of \r in a procfs write?
>>
>> I struggle to imagine one; everything I found that uses proc_dostring
>> seems to be names, paths, and commands.
>>
>
> You're insufficiently pessimistic.

Haha, I haven't had that accusation made about me before; I'll keep
this quote around! :)

> I wonder if the chances of damage would be lower if we were to continue
> to accept the \r, but turn it into something else ("\r"?) when it is
> read.

I think that would complicate things more than help them. If there's a
legit use of \r, I'll let Paul Wise debate how to proceed. :)

-Kees

-- 
Kees Cook
Chrome OS Security
