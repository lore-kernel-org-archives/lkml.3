Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab3L1TZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 14:25:46 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39698 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3L1TZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 14:25:45 -0500
MIME-Version: 1.0
In-Reply-To: <20131228112509.8a62548c.akpm@linux-foundation.org>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	<20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
	<201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
	<CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
	<20131228112509.8a62548c.akpm@linux-foundation.org>
Date: Sat, 28 Dec 2013 20:25:45 +0100
X-Google-Sender-Auth: 7DKxvOgMaigmrj-RYkwxZ-nJcgY
Message-ID: <CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 8:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> Is any of the "\x" (backslash + character) unused and thus available?
>
> I guess control characters would work.
>
> #define PRINTK_COMM     "\001"

Not that one, cfr. include/linux/kern_levels.h ;-)

> #define PRINTK_PID      "\002"
> #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
>
>         printk(PRINTK_TASK_ID ": hair on fire\n");
>
> It's certainly compact.  I doubt if there's any existing code which
> deliberately prints control chars?

But the rest looks OK to me.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
