Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaLBOi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:38:27 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:41030 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaLBOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:38:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAPs88r_6V_O_j8SrXAdkRZgLn=0BfZksK3e9=9xQGsjrqSZ+Zw@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-3-git-send-email-oakad@yahoo.com>
	<CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
	<547DA592.7090900@monstr.eu>
	<CAPs88r_6V_O_j8SrXAdkRZgLn=0BfZksK3e9=9xQGsjrqSZ+Zw@mail.gmail.com>
Date: Tue, 2 Dec 2014 15:38:24 +0100
X-Google-Sender-Auth: RZmFi55-Mi_pYTmwjCmVo_dsY90
Message-ID: <CAMuHMdXg7avxH3q3SZG3gR9KWy8HFhKaoQkM-QtNTEO56AqeEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Wire up sendfd() syscall (all architectures)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Tue, Dec 2, 2014 at 3:31 PM, Alex Dubov <alex.dubov@gmail.com> wrote:
> On Tue, Dec 2, 2014 at 10:42 PM, Michal Simek <monstr@monstr.eu> wrote:
>> On 12/02/2014 09:01 AM, Geert Uytterhoeven wrote:
>>> This really needs a CC to linux-arch (added).
>>>
>>> On Tue, Dec 2, 2014 at 5:35 AM, Alex Dubov <alex.dubov@gmail.com> wrote:
>>>> Signed-off-by: Alex Dubov <oakad@yahoo.com>
>>>> ---
>
>> The same for microblaze here
>> arch/microblaze/include/asm/unistd.h
>
> This invites the question as to why the __NR_syscalls macro is not
> defined in uapi/asm/unistd.h on those architectures, where it will be
> easier to spot? After all, asm/unistd.h includes uapi/asm/unistd.h
> unconditionally.

Because it's not part of the ABI?

There may be multiple ABIs, with multiple syscall ranges.
Userspace only needs to know if a syscall is available, not what the
valid syscall number range is.
The kernel does need to know the size of the full syscall table.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
