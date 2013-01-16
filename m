Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab3APQsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:48:40 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59113 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3APQsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:48:37 -0500
Date: Wed, 16 Jan 2013 08:48:32 -0800
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
Message-ID: <20130116164832.GP2668@htj.dyndns.org>
References: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Jan 15, 2013 at 07:37:42PM -0800, Linus Torvalds wrote:
> I do want the same user-visible semantics, so it's not some one-liner.
> 
> The compiled-in elevator would be easy enough to handle in the Kconfig
> file (maybe we do already, I didn't even bother to check). The real
> problem is the "chosen_elevator" one, which is dynamic with the kernel
> command line. And we could handle that one by just trying to load the
> module early (but exactly _when_?) and then instead of looking things
> up by name, just keep a pointer to the default elevator around.
> 
> But no, it's not just some trivial one-liner. Especially the question
> about "when to try to load the module that is given on the kernel
> command line" is not trivial. Do we require that the module is in the
> initrd and loadable basically immediate at boot? Do we try again after
> switching the root filesystem? Things like that..

If the current user-visible semantics is defined as "the kernel shall
try to load the default iosched if not already available on each block
device discovery", nothing can be changed ever, but I'm not sure it
needs to be pushed that far.

As Arjan suggested, trying to load the default modules right after the
initial rootfs mount could be an acceptable compromise and it would be
really nice (for both code sanity and avoiding future problems) to be
able to declare module loading nested inside async unspported.

Thanks.

-- 
tejun
