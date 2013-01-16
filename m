Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab3APRHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:07:19 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57622 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3APRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:07:15 -0500
MIME-Version: 1.0
In-Reply-To: <50F6DD4D.3070808@linux.intel.com>
References: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org> <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org> <50F6DD4D.3070808@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2013 09:06:54 -0800
X-Google-Sender-Auth: GzZU0hR3kjT8-JB34zbVrN0K_z8
Message-ID: <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 9:03 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>
> we can even try twice
>
> the first time right after we mount the initramfs
> the second time when the initramfs code exits, and before we exec init
> (the initramfs supposedly mounted the real root fs at this point)

Yes. This, together with "don't try request_module for the default
elevator", and the "warn if somebody does request_module from async
context" would, I think, be the right thing to do.

In the meantime, I've applied Tejun's patch. It possibly speeds things
up regardless of this particular deadlock thing, and while it's not
pretty it certainly isn't horribly nasty or very invasive either, so I
don't see any reason to delay it just because there might be a better
solution some day.

                  Linus
