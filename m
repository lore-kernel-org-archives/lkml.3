Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaCGFmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:42:46 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62944 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaCGFmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:42:42 -0500
MIME-Version: 1.0
In-Reply-To: <8761nqzo4z.fsf@rustcorp.com.au>
References: <1394152324-26304-1-git-send-email-keescook@chromium.org>
	<1394152324-26304-3-git-send-email-keescook@chromium.org>
	<8761nqzo4z.fsf@rustcorp.com.au>
Date: Thu, 6 Mar 2014 21:42:41 -0800
X-Google-Sender-Auth: VfMHVCbrv8gt4muUsDnaugvz9lk
Message-ID: <CAGXu5jJKZbiOhnLTWw5YppCxjNWKSdjGd6Gt6Qz-zV1gkjg1Mg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kallsyms: handle special absolute symbols
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 7:25 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> This forces the entire per_cpu range to be reported as absolute without
>> losing their linker symbol types. Without this, the variables are
>> incorrectly shown as relocated under kASLR.
>
> I like these patches, thanks!

Oh good! Glad this is getting closer. :)

> This one's a bit broken, since the zero-based __per_cpu_start/end thing
> is an x86-64-ism.  You really do want them relocated on other
> platforms, so I think you'll need do make this conditional via
> a --per-cpu-absolute flag to kallsyms (which x86-64 would set).

Ah, hm. Can this maybe just be dynamically detected (e.g. if
__per_cpu_start == 0?), I'd hate to have another arch run into this
glitch when we could "notice" it and deal with it instead.

> Dumb Q: why don't we actually present these symbols as absolute in
> /proc/kallsyms?  Seems like it would be clearer...

You mean set "sym[0] = 'A'" instead of the force_absolute thing I
added? It seemed like I shouldn't mess with existing information, and
as you say, they're not absolute on all platforms.

-Kees

-- 
Kees Cook
Chrome OS Security
