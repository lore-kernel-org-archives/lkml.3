Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3APDZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:25:09 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:37835 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab3APDZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:25:07 -0500
Date: Tue, 15 Jan 2013 19:25:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
Message-ID: <20130116032502.GN2668@htj.dyndns.org>
References: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Tue, Jan 15, 2013 at 07:00:31PM -0800, Linus Torvalds wrote:
> That said, maybe we could just make the rule be that you can't pick a
> default IO scheduler that is modular.

This is definitely much more preferable but it would affect use case
where everything is built modular and the elevator is selected via
kernel param.  This is way outside the usual usage and we can warn
about the new behavior but it still is an observable behavior change.
Do you think this would be okay?

> And I *would* like to see the warning we discussed. Maybe there are
> other situations that can trigger this?
> 
> Because something like that
> 
>     WARN_ON_ONCE(wait && i_am_async() && system_state == SYSTEM_RUNNING);
> 
> in kernel/kmod.c (__request_module()) still sounds like a good idea to
> verify that this is the only thing that triggers it (of course, we'd
> need to somehow avoid the warning for the known case with the known
> workaround).

And then this warning can be added without introducing
request_module_but_dont_warn_about_being_called_from_async().

Thanks.

-- 
tejun
