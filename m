Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaDBSql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:46:41 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63611 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaDBSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140402172639.994587272@goodmis.org>
References: <20140402172639.994587272@goodmis.org>
Date: Wed, 2 Apr 2014 11:46:38 -0700
X-Google-Sender-Auth: _m7IVoUKlHJPP1esSu_WOWkON_o
Message-ID: <CA+55aFwzD0azkqLQLKz+9XOwDbY937z+Ym02diu91AZR7XT6Dw@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86: Fix perf deadlock caused by dumpstack cleanup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 10:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Here are two patches that fix the deadlock that you discovered.
>
> The first patch is the real culprit, but as I was looking at the code
> I realized that the irq stack part was a bit off too. That part didn't
> cause the lock up, but needs to be fixed regardless.
>
> Note, I'm hoping to use these clean ups to make x86_64 and i386 code
> a bit closer to each other, so I hope the original change does not
> get reverted.

I'll apply them.

That said, I'm not *AT*ALL* convinced that a "cleanup" that involves
having helper functions with multiple bugs and now seven (7!)
arguments passed into it is a "cleanup" at all.

The cleanup was claimed to help improve readability. Really? Somebody
needs to reconsider their goals in life if they think that a
7-argument helper functions where the caller needs to pass in
addresses to variables because the helper function will change them is
a good idea. Just the *call* is spread out over two lines because
calling that function is so complex.

I suspect that maybe creating some kind of "struct stack_information"
structure might help somewhat. Because right now I'm very doubtful
about the whole "this clarifies/simplifies" argument. The very fact
that the "cleaned-up" function was a buggy pile of sh*t should make
you question the cleanup itself.

            Linus
