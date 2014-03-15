Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaCOTWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:22:04 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65335 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaCOTWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140315191222.GA32499@redhat.com>
References: <20140224192734.GA15573@bender.morinfr.org>
	<CA+55aFyXCh8ETJH2XODzWM_Hj8_eTe4fjHt6v630YJB8OzS-Ew@mail.gmail.com>
	<20140315191222.GA32499@redhat.com>
Date: Sat, 15 Mar 2014 12:22:01 -0700
X-Google-Sender-Auth: iVn9fGf7DrcfTgwCmLF69TWz0ug
Message-ID: <CA+55aFwqNgO1S092SYk-zUgXgtn+Un76kkL5BNbwp+xhUfrx4w@mail.gmail.com>
Subject: Re: [PATCH] exit.c: call proc_exit_connector() after exit_state is set
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: matt.helsley@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 12:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> So I think the patch is fine, but let me repeat:
>
>         I hope that someone
>         can confirm that netlink_broadcast() is safe even if release_task(current)
>         was already called, so that the caller has no pids, sighand, is not visible
>         via /proc/, etc.
>
> not that I expect this should not work, but still.

Ok. I think people use netlink_broadcast from irq context (well,
strictly speaking looks lik ebottom half) judging by the GFP_ATOMIC
users, so that had better work regardless.

> Yes... BTW, Guillaume, I forgot to mention that perhaps you can use
> signalfd(SIGCHLD) instead of connector, this is epoll-able too. SIGCHLD
> doesn't queue, so it can't tell you which child has exited, but WNOHANG
> should work.

Yeah, that sounds like a good approach if SIGCHLD is the only thing needed.

Anyway, I see that the patch is apparently in -mm, and I think your
netlink_broadcast issue should be fine, so things are moving along.
It's not like this is a new issue or even so much an outright "bug" as
a misfeature.

             Linus
