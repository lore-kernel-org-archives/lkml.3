Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3L1S5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 13:57:52 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32884 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3L1S5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 13:57:50 -0500
MIME-Version: 1.0
In-Reply-To: <201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	<20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
	<201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
Date: Sat, 28 Dec 2013 19:57:50 +0100
X-Google-Sender-Auth: _J5bo39ucZncTtwRFYQvOQXJL4o
Message-ID: <CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 4:43 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Andrew Morton wrote:
>> which is painful, so we also provide the new vsprintf token as a
>> convenience:
>>
>>       pr_warn("%|: hair on fire\n");
>>
>> but I don't know what we can use in place of %|.
>
> We are using %pEXTENSION where EXTENSION is [A-Za-z0-9]* because compiler does
> not need to understand what EXTENSION does; compiler needs to care about what
> character follows the % character and check type of corresponding argument if
> __printf() attribute is given.

Indeed,

> If we introduce a character which compiler does not know that follows the %
> character, compiler would be confused when checking type of corresponding
> argument.
>
>> I wonder if there's some way in which we can invent a vsprintf token
>> which means "insert corrent->comm here" and which doesn't require that
>> the caller pass in the additional argument?
>
> Therefore, if we want to omit passing corresponding argument, we should not
> introduce new character which compiler does not know that follows the %
> character.
>
> Also, % is the only character which everybody knows that it is reserved for the
> beginning of format specifier and %% is the only characters which everybody
> knows that it is reserved for literal % character.
>
> Therefore, what we could do for printing current thread's attributes would be
> either reserve a new character and add EXTENSION like
>
>   pr_warn("$comm$: hair on fire\n");
>   pr_warn("Process $pid$: hair on fire\n");
>
> or add EXTENSION after the %% characters like
>
>   pr_warn("%%comm%%: hair on fire\n");
>   pr_warn("Process %%pid%%: hair on fire\n");

ESC sequences? So far printk() doesn't parse them (a bit unfortunate, as I
always liked the idea of printing error messages in red, warnings in yellow,
etc.).

Is any of the "\x" (backslash + character) unused and thus available?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
