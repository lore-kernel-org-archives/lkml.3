Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab3APDAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:00:54 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47873 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3APDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:00:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130116025251.GM2668@htj.dyndns.org>
References: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com> <20130116025251.GM2668@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 19:00:31 -0800
X-Google-Sender-Auth: aZg7FKMK9g10QeDMBT5atyoy5sU
Message-ID: <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 6:52 PM, Tejun Heo <tj@kernel.org> wrote:
>
> It makes me feel dirty but makes the problem go away and I can't think
> of anything better, so here is the implementation of "used async"
> workaround.

Ok, people, can we get a tested-by (or "Nope, doesn't work") from the
people who saw this?

That said, maybe we could just make the rule be that you can't pick a
default IO scheduler that is modular.

And I *would* like to see the warning we discussed. Maybe there are
other situations that can trigger this?

Because something like that

    WARN_ON_ONCE(wait && i_am_async() && system_state == SYSTEM_RUNNING);

in kernel/kmod.c (__request_module()) still sounds like a good idea to
verify that this is the only thing that triggers it (of course, we'd
need to somehow avoid the warning for the known case with the known
workaround).

             Linus
