Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaBWUzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:55:39 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62816 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaBWUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:55:38 -0500
MIME-Version: 1.0
In-Reply-To: <1393188288.11020.9.camel@joe-AO722>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
	<1393188288.11020.9.camel@joe-AO722>
Date: Sun, 23 Feb 2014 12:55:37 -0800
X-Google-Sender-Auth: yKvFzWnu4T8gGbMy9fdK9Tt6p1Y
Message-ID: <CA+55aFyeo4jsjFp+JJf8ZnhRF6pAbZv-sw=rP+Xg4CvKYcTRZw@mail.gmail.com>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 12:44 PM, Joe Perches <joe@perches.com> wrote:
>
> I'd rather see this as a vsprintf extension so
> that it is more difficult to interleave and
> doesn't need to be replicated for each arch.

We could easily get rid of printk_[stack_]address() by just inlining
it into the callers, and make them use the [<%p[SB]>] thing directly.

That's a separate issue from trying to get rid of the hex parts of the
address, though.

Also, note that even if you merged printk_stack_address into its
callers, you'd still have the actual stack walking ->address() and
->stack() calls as separate calls, so it's not like you'd really avoid
any interleaving if there are concurrent walkers.

                Linus
