Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3H0Tc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:32:29 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53564 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3H0Tc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
	<7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
Date: Tue, 27 Aug 2013 12:32:26 -0700
X-Google-Sender-Auth: lEFjgih0g8QNVEUMPLW6a636K6g
Message-ID: <CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This is an experiment to see if we can get nice semantics for all syscalls
> that either follow symlinks or allow AT_EMPTY_PATH without jumping through
> enormous hoops.  This converts truncate (although you can't tell using
> truncate from coreutils, because it actually uses open + ftruncate).

So this seems *way* too complex. I'd much rather see "nd->flags" get a
LOOKUP_READONLY flag, for example, that gets set by
proc_pid_follow_link() when it hits a read-only file descriptor (and
gets cleared by other lookups).

Wouldn't that be *much* more straightforward?

             Linus
