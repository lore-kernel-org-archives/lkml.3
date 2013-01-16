Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3APQW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:22:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:36047 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737Ab3APQWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:22:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,480,1355126400"; 
   d="scan'208";a="274537025"
Message-ID: <50F6D3D2.3020407@linux.intel.com>
Date: Wed, 16 Jan 2013 08:22:42 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init
 iff async is used
References: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com> <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com> <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com> <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com> <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com> <20130116025251.GM2668@htj.dyndns.org> <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com> <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
In-Reply-To: <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But no, it's not just some trivial one-liner. Especially the question
> about "when to try to load the module that is given on the kernel
> command line" is not trivial. Do we require that the module is in the
> initrd and loadable basically immediate at boot? Do we try again after
> switching the root filesystem? Things like that..

to load it from the root fs you tend to need... an elevator ;-)


I think it's pretty fair to users to say that if you want something by default at boot time,
you need to build it in...
but for us to try a modprobe from the initrd is not too bad I suppose.
probably need to do this around the time we initialize the block layer

