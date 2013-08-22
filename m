Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3HVUyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:54:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63844 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3HVUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
	<CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
	<20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
	<CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
	<CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
	<CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
Date: Thu, 22 Aug 2013 13:54:15 -0700
X-Google-Sender-Auth: 90VJmWONhFCnN9JmcquNbldJn3g
Message-ID: <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Willy Tarreau <w@1wt.eu>, "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 1:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Sure.  But aren't they always last?

What do you mean? I'd say that the /proc lookup is always *innermost*.
Which means that it certainly cannot bail out, since there are many
levels of nesting outside of it.

> With the current code structure, trying to enforce some kind of
> security restriction in the middle of lookup seems really unpleasant.

If it's conditional (ie "linkat behaves differently from openat"), it
certainly means that we'd have to pass in that info in annoying ways.

But having unconditional rules like "you can only follow the proc link
if you have CAP_SEARCH _or_ you match the file->f_cred" doesn't sound
too painful.

              Linus
