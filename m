Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3HZRiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 13:38:00 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33229 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3HZRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 13:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyXq9kry7EtcnXOd_DWDVkDvVRWKLAfLOYHVsdY4RRJ8A@mail.gmail.com>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
	<CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
	<CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
	<CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
	<20130823010726.GP27005@ZenIV.linux.org.uk>
	<20130825033741.GX27005@ZenIV.linux.org.uk>
	<CA+55aFxaKGcpdxKXK_axqyFz_oCvFm1Q=_fJLq8di97x_-cCig@mail.gmail.com>
	<20130825200605.GC27005@ZenIV.linux.org.uk>
	<CA+55aFyXq9kry7EtcnXOd_DWDVkDvVRWKLAfLOYHVsdY4RRJ8A@mail.gmail.com>
Date: Mon, 26 Aug 2013 10:37:57 -0700
X-Google-Sender-Auth: XvZf5wBZ_IRVYgmYcRF_l_5LcK4
Message-ID: <CA+55aFzcPFXei5j-i49+3kXZ5L9S-v66vrzU091EuXkSeg1G7A@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 1:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'll just go back to square one, and wonder if we could/should just
> make the rule be that in order to be in that LAST_BIND case, you
> really have to have f_cred match your own credentials. Or have
> CAP_SEARCH.

Nope. That doesn't work. It breaks the chrome sandboxing.

Right now, following a /proc fd symlink requires ptrace access to the
process. Which is actually pretty strict, and makes sense. But it does
mean that there are other capabilities than CAP_DAC_READ_SEARCH at
play.

I'm playing with a patch that then in addition to the ptrace check
*also* requires that the file was opened with the same credentials as
the follower _or_ the task being followed. I'll see if that works out.

                Linus
