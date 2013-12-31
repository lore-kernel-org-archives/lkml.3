Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3LaJg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:36:27 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60742 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3LaJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:36:25 -0500
MIME-Version: 1.0
In-Reply-To: <52C21CE3.3020402@lwfinger.net>
References: <52C21CE3.3020402@lwfinger.net>
Date: Tue, 31 Dec 2013 10:36:25 +0100
X-Google-Sender-Auth: lKBpbXMccpx9Y4fGYw28Ox8CKMk
Message-ID: <CAMuHMdVkLBBhz0Q7ae4TRww2k7foMeiff=fE1yruohQGr2u7-g@mail.gmail.com>
Subject: Re: Question on compiler warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 2:24 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In his regular article entitled Build regressions/improvements in v3.13-rc6"
> (http://lkml.indiana.edu/hypermail/linux/kernel/1312.3/01550.html), Geert
> Uytterhoeven reports the following warning regression:
>
> + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr'
> may be used uninitialized in this function [-Wuninitialized]: => 178:21
>
> This warning does not show up on any of my compilers, and it should not as
> the initialization and usage of that variable both take place in conditional
> branches that are testing exactly the same pointer.

It depends on the compiler version. Some versions of gcc are not smart enough
to notice all usage sites depends on the same condition.

> Despite the fact that the warning is bogus, should a patch be submitted to
> clear it? I lean toward "no" as an answer because that would mask the
> warning if there were some future change that screwed up the flow; however,
> I wanted to check with the community.

If it's clearly bogus, there's no reason to submit a patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
