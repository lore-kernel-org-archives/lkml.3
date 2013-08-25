Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3HYScs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:32:48 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:61434 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3HYScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130825052317.GZ27005@ZenIV.linux.org.uk>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
	<CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
	<20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
	<CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com>
	<20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
Date: Sun, 25 Aug 2013 11:32:45 -0700
X-Google-Sender-Auth: AnczSkhOQiYI0tq-qeVShF-Ciks
Message-ID: <CA+55aFy_W_rEeCyrTWMx55WNDh4HaOs5O-krQMqLUjOc=MxA3A@mail.gmail.com>
Subject: Re: /proc/pid/fd && anon_inode_fops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 10:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> We are really stuck with the current semantics here - switching to
> *BSD one would not only mean serious surgery on descriptor handling
> (it's one of the wartier areas in *BSD VFS, in large part because
> of magic-open-really-a-dup kludges they have to do), it would change
> a long-standing userland API that had been there for nearly 20 years
> _and_ one that tends to be used in corner cases of hell knows how many
> scripts.

Actually, I'm pretty sure we did have the "dup" semantics at one point
(long ago), and they were really nice (because you could use them to
see where in the stream the fd was etc). It just fit so horribly badly
into the VFS semantics that it got changed into the current "new file
descriptor" one. Afaik, nothing broke.

So I'm not really sure about the "we're stuck with it" for semantic
reasons, and it turns out that very few programs/scripts actually use
/proc/<pid>/fd/<nr> at all (random use of /dev/stdin is likely the
most common case). But I agree about the "serious surgery on
descriptor handling" part.

              Linus
