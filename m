Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3HVUPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:15:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35558 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3HVUPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:15:41 -0400
Date: Thu, 22 Aug 2013 22:15:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130822201530.GL31117@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:10:43PM -0700, Andy Lutomirski wrote:
> What's the point of nd_jump_link anyway?  The only way I can think of
> for a magic symlink in /proc to point to another symlink is to open a
> symlink with O_PATH | O_NOFOLLOW.  Actually trying to use the
> resulting link in /proc results in -ELOOP.  (Even just trying to open
> a normal symlink with O_NOFOLLOW and without O_PATH results in
> -ELOOP.)

It's not only that, it also supports sockets and pipes that you can access
via /proc/pid/fd and not via a real symlink which would try to open eg
"pipe:[23456]" instead of the real file. So you can't get rid of it
without breaking existing apps (starting with your shell for which
/dev/stdin is a link to /proc/self/fd/0 for example).

Willy

