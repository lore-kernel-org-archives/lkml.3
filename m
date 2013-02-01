Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3BAJJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:09:18 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33693 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3BAJJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:09:07 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
References: <CA+icZUW5tBotrZT9QtNPao-3rEccohBW8a4diS2nJ+ONgTWLaQ@mail.gmail.com>
	<CAKMK7uEFCm5JPD9bg4uO9K_q-w0=9GWzRLoB9H-_=ZR7NxA9=A@mail.gmail.com>
Date: Fri, 1 Feb 2013 10:09:05 +0100
Message-ID: <CA+icZUVDGmbozG4mrvJm2gKKQvddhsZ_hym=DpzhX1t-dKxExg@mail.gmail.com>
Subject: Re: Revert "console: implement lockdep support for console_lock"
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 9:42 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Fri, Feb 1, 2013 at 9:21 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> people having the fbcon-locking-fixes [1] in their local GIT tree can
>> revert this change?
>
> Yeah, if you have all the fixes reverting this is fine and appreciated
> to increase testing. Dave will probably push the revert himself to
> drm-next soon.

[ CCing Ingo ]

The revert is now in -rc6.

Hmmm, I have here...

     CONFIG_LOCKDEP_SUPPORT=y

Excerpts from the revert [1]:
[...]
-#ifdef CONFIG_LOCKDEP
-static struct lockdep_map console_lock_dep_map = {
-       .name = "console_lock"
-};
-#endif
[...]

Checking for CONFIG_LOCKDEP ...

[ lib/Kconfig.debug ]
...
config LOCKDEP
        bool
        depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
        select STACKTRACE
        select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390
&& !MICROBLAZE
        select KALLSYMS
        select KALLSYMS_ALL
...

---> No help text.
---> Missing pointer to <file:Documentation/lockdep-design.txt>.

[ arch/x86/Kconfig ]
...
config LOCKDEP_SUPPORT
        def_bool y
...

I would have expected a check for CONFIG_LOCKDEP_SUPPORT.
This is BTW with Linux v3.8-rc5!

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=ff0d05bf73620eb7dc8aee7423e992ef87870bdf
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/lockdep-design.txt

> -Daniel
>
>>
>> commit ff0d05bf73620eb7dc8aee7423e992ef87870bdf
>> Refs: v3.8-rc5-194-gff0d05b
>> Author:     Dave Airlie <airlied@gmail.com>
>> AuthorDate: Thu Jan 31 14:27:03 2013 +1100
>> Commit:     Dave Airlie <airlied@gmail.com>
>> CommitDate: Thu Jan 31 15:46:56 2013 +1100
>>
>>     Revert "console: implement lockdep support for console_lock"
>>
>>     This reverts commit daee779718a319ff9f83e1ba3339334ac650bb22.
>>
>>     I'll requeue this after the console locking fixes, so lockdep
>>     is useful again for people until fbcon is fixed.
>>
>>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>>
>> Thanks!
>>
>> Regards,
>> - Sedat
>>
>> [1] http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
>
>
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
