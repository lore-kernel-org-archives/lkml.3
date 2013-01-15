Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3AOW16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:27:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50632 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3AOW1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:27:55 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2 1/2] nconf:  add keybindings for vi-style menu navigation, rewrite help texts
Date: Tue, 15 Jan 2013 23:27:48 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, Dmitry Voytik <dvv.kernel@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp> <20130115161031.GA5513@mobil.systemanalysen.net> <20130115162632.GB5513@mobil.systemanalysen.net>
In-Reply-To: <20130115162632.GB5513@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301152327.49010.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, All,

On Tuesday 15 January 2013 Roland Eggner wrote:
> >From: Roland Eggner <edvx1@systemanalysen.net>

OK, now I've had time to test it. Works OK.

However, this patch mixes different things: feature changes, help-texts
rewrite...

Could you split it into multiple patches, each do a single, well-defined
change? See below.

> •  Implemented vi-style navigation <k> <j> <l> <h>, based on initial work by
>    Dmitry Voytik.  Using <?> <H> instead of <?> <h> for help related to current
>    menu entry avoids conflict.
> 
> •  Added keybindings <C-n> <C-p> additionally to <C-f> <C-b> for moving pagewise
>    down and up.  <C-f> <C-b> is used for characterwise right and left movement
>    by libreadline (bash, xfsprogs, bc, gdb, python, ruby, hunspell, mysql,
>    sqlite, gnupg, xine-ui, parted …).  Thus pagewise movement by <C-n> <C-p> is
>    less confusing than by <C-f> <C-b> for my fingers.

I think we should only retain the more "natural" key bindings: <C-f> and
<C-b> for left/right. <C-p> and <C-n> are not for PAge-Up/Down, but for
previous-in-history and next-in-history (which, IMHO, is not the same
meaning).

However, I wonder how many such *-like keys we should have.

The up/down and Page-Up/Down keys are really trivially understood. It's
been a long while ago they were introduced in vim (rather than using the
oldish hjkl). Readline also understands those arrow-keys keys. So, really,
I wonder what the point of having these new keys is.

> •  Rewrote all help texts.  During several years lazy (incomplete) updates had
>    left behind a rather thick layer of dust.  Intentions:
>    (1)  Global help called by <F1> should document all  _currently_  implemented
>         keybindings.
>    (2)  Different help texts called by <F3> resp. <F8><F1> should be consistent
>         with (1) and with implementation:
>         •  on plain menu entry
>         •  in radiolist window
>         •  in input windows for text, decimal or hexadecimal values
>         •  in filename selection windows <F6> <F7>
>         •  SymSearch specific help called by <F8> followed by <F1>

This one does indeed give an easier to read, more precise and more complete
help. This should be a separate patch.

> •  Function keys line:  “Help 2” instead of “Insts” and “ShowAll” instead of
>    “Config” should be more intuitiv.

Ditto, a separate patch.

I'd suggest that you add the least controversial patches first, and submit
them as four patches:
  - help rewrite
  - labels rewrite (update help accordingly)
  - vi-like keys
  - readline-like keys

(Or the other way around for the last two patches.)

With this patch ordering, each patch is easier to review, the fixes ones
(help and labels rewrites) can be easily applied, and we can discuss the
last two separately.

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
