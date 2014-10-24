Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaJXH2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:28:24 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:47151 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXH2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <20141024032422.GI7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
Date: Fri, 24 Oct 2014 09:28:20 +0200
X-Google-Sender-Auth: x9Hta_gT1NrCU3SQG4G_FIaugAM
Message-ID: <CAMuHMdXiR7WjjR0T=W3kQShykSsiF0kKMfz75+BNbB=xHvkC0w@mail.gmail.com>
Subject: Re: [GIT PULL] overlay filesystem v25
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Fri, Oct 24, 2014 at 5:24 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Oct 24, 2014 at 03:20:55AM +0100, Al Viro wrote:
>> Why the hell do you hold ->i_mutex across the entire opening of underlying
>> directory?  All you need is to serialize one assignment; the side that loses
>> the race will simply fput() what it opened...
>>
>> Oh, well - that goes under "weird pessimisations, easy to fix in followups"...
>
> OK, pulled into vfs.git, followups in question added.  Also there: fix for
> a long-standing leak in d_splice_alias() failure exits.  Guys, could you
> check that current vfs.git#for-linus survives your local tests?  Seems to
> survive here; if I don't hear of any problems by tomorrow morning, to Linus
> it goes...  FWIW, for that pull request stats would be

I think you forgot to merge your for-linus branch into for-next?

Anyway, as Stephen announced there will be no linux-next release
today, I'm afraid you'll have to delay your pull request to Tuesday.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
