Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3APRD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:03:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:12101 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab3APRDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:03:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,480,1355126400"; 
   d="scan'208";a="277678629"
Message-ID: <50F6DD4D.3070808@linux.intel.com>
Date: Wed, 16 Jan 2013 09:03:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
References: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com> <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com> <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com> <20130116025251.GM2668@htj.dyndns.org> <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com> <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com> <20130116164832.GP2668@htj.dyndns.org>
In-Reply-To: <20130116164832.GP2668@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As Arjan suggested, trying to load the default modules right after the
> initial rootfs mount could be an acceptable compromise and it would be
> really nice (for both code sanity and avoiding future problems) to be
> able to declare module loading nested inside async unspported.

we can even try twice

the first time right after we mount the initramfs
the second time when the initramfs code exits, and before we exec init
(the initramfs supposedly mounted the real root fs at this point)

if you want your elevator to apply to your root filesystem storage, the rule
will then be "put the module in the initramfs"... but to be honest,
that's not a restriction that is unreasonable or unexpected.


for doing a module loading from inside an async handler..we can then just make
use of the normal "load this module async" way of requesting a module.

