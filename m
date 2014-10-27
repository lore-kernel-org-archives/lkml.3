Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaJ0KL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:11:56 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:60437 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJ0KLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:11:54 -0400
MIME-Version: 1.0
In-Reply-To: <20141027095626.GD9807@amd>
References: <20141021202137.GA20114@www.outflux.net>
	<20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
	<CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
	<20141027095626.GD9807@amd>
Date: Mon, 27 Oct 2014 11:11:53 +0100
X-Google-Sender-Auth: TCf29o5OqcT47Lj8noIaYARD3fo
Message-ID: <CAMuHMdVeFGjti-6ghv_u6_r2HkKHwWj70TGzQ0yGkuTmu7zBLQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Wise <pabs3@bonedaddy.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:56 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2014-10-22 16:43:10, Kees Cook wrote:
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
>
> Well, filename can contain \r, right?

Even \n. AFAIK, the only thing a filename cannot contain is the nul character
and a forward slash, as that's used to separate path components (so slash
is valid for a path name).

Still, we can hide stuff using ANSI ESC sequences, and e.g. backspaces,
right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
