Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaJZRhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 13:37:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36273 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 13:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141026171819.GQ7996@ZenIV.linux.org.uk>
References: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
 <20141026171819.GQ7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 26 Oct 2014 10:36:45 -0700
Message-ID: <CALCETrW0pqGznCOEoFT3ttEkmqNmpZVaNu-FPb=RUB3D7k+aQg@mail.gmail.com>
Subject: Re: [PATCH] all arches, signal: Move restart_block to struct task_struct
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 10:18 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 26, 2014 at 10:02:16AM -0700, Andy Lutomirski wrote:
>> If an attacker can cause a controlled kernel stack overflow,
>> overwriting the restart block is a very juicy exploit target.
>> Moving the restart block to struct task_struct prevents this type of
>> exploit.
>
> The hell it does.  In a _lot_ of cases current is current_thread_info()->task,
> which makes your variant just as vulnerable, in addition to being (slightly)
> more costly.

I never said it was the *only* juicy target, but we can fix the rest,
too.  Also, I suspect that overwriting task could be harder to
exploit.  First, you need to avoid crashing, and second, on systems
with SMAP or similar protection, you need to make task point somewhere
that contains a useful exploit payload.

We could probably get rid of thread_info's task pointer on x86, too --
it's not used by get_current() any more.

--Andy
