Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3INXjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 19:39:10 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55330 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab3INXjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 19:39:08 -0400
Date: Sun, 15 Sep 2013 01:39:03 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: =?utf-8?Q?Cl=C3=A9ment?= Chauplannaz <chauplac@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: scripts/config: fix variable substitution command
Message-ID: <20130914233903.GD3444@free.fr>
References: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
 <CACW0xKV-jh2Zfz1-s0xX-NxYBixEF8Hf90jEbo0oouFE18CdyQ@mail.gmail.com>
 <CA+icZUW6Z+exg9wm_up3wta9qX6Wp5WUZa-n+1q8a98-Kt-7Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+icZUW6Z+exg9wm_up3wta9qX6Wp5WUZa-n+1q8a98-Kt-7Zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On 2013-09-14 16:43 +0200, Sedat Dilek spake thusly:
> On Sat, Sep 14, 2013 at 4:21 PM, Clément Chauplannaz <chauplac@gmail.com> wrote:
> > 2013/9/14 Sedat Dilek <sedat.dilek@gmail.com>:
[--SNIP--]
> >> So, can you point me/us to the correct commit with subject, please?!
> >
> > My apologies for that mistake. The initial commit, as present in Linus tree, is:
> > 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce - scripts/config: use sed's
> > POSIX interface
> >
> > Thus, the commit message for this patch should read:
> > scripts/config: fix variable substitution command
> >
> > Commit 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce ("scripts/config: use sed's
> > POSIX interface") accidentally changed the separator between sed `s' command
> > and its parameters from ':' to '/'.
> >
> > Revert this change.
> >
> > Reported-and-tested-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> >
> 
> What means "pending" [1]?

The current script had a latent bug that would trigger when the user want
to set a string that contains a colon ':'.

This behaviour was changed by Clément, and the bug was then about strings
with a '/' instead. This was a regression for some users.

The behaviour was then reverted to break on strings containing ':'.

What is pending is a final fix that will fix both cases.

> Pending in sense of "we are working on it" or in the sense of
> "exists-but-not-published".

The final fix is trivial and identified, so I guess that Clément has yet
had time to send the patch.

> I did not found a hint on the offline linux-kbuild ML.

That would be Michal's suggestion there:
    http://marc.info/?l=linux-kbuild&m=137907001305533&w=2

> BTW, the GIT repo of Yann is not browsable (which is sh*t for checking
> commits quickl, I don't want to be forced to checkout).

Yes, I know about that one. I've already notified the gitorious guys
about the issue, they supposedly fixed it, but it is broken again.

I will re-open my ticket in a moment.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
