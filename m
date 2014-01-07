Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaAGS3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:29:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40542 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGS2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140107175656.GB18316@amd.pavel.ucw.cz>
References: <201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	<1388945392.5808.19.camel@joe-AO722>
	<201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
	<1389029698.2433.3.camel@joe-AO722>
	<201401070641.HAC18733.VOFMFOLOJQSFHt@I-love.SAKURA.ne.jp>
	<1389047143.2433.14.camel@joe-AO722>
	<20140107001604.GD24243@amd.pavel.ucw.cz>
	<1389056635.2433.22.camel@joe-AO722>
	<20140107083740.GA5683@amd.pavel.ucw.cz>
	<1389116048.32137.14.camel@joe-AO722>
	<20140107175656.GB18316@amd.pavel.ucw.cz>
Date: Tue, 7 Jan 2014 19:28:54 +0100
X-Google-Sender-Auth: I5b_T6TeeR9fvWPGMmMjrtaoUoM
Message-ID: <CAMuHMdV13i8VicysHjKMmQtf+ZXCcCV+KiBVEnBONuf4=1w9_Q@mail.gmail.com>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Joe Perches <joe@perches.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 6:56 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> The additional cost of using current vs NULL is ~zero.
>
> The additional cost of current vs NULL is cca 8 bytes per caller. Test
> for NULL is cca 4 bytes, maybe 20 bytes total. I believe it is worth
> it.

It depends (typical answer ;-)

On architectures that keep current in a register, the cost of using it is
usually zero, as there's typically no difference between pushing a register
or a zero on the stack, or moving a register or a zero to another register.

current_thread_info()->task is more expensive.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
