Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3HLPJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:09:08 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:60172 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3HLPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:09:05 -0400
Date: Mon, 12 Aug 2013 11:09:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
Message-ID: <20130812150900.GJ15892@htj.dyndns.org>
References: <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <20130812070411.GA2878@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812070411.GA2878@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jonathan.

On Mon, Aug 12, 2013 at 12:04:11AM -0700, Jonathan Nieder wrote:
> My laptop fails to boot[1] with the message 'Volume group "data" not
> found'.  Bisects to v3.8-rc4~17 (the above commit).  Reverting that
> commit on top of current "master" (d92581fcad18, 2013-08-10) produces
> a working kernel.  dmesg output from that working kernel attached.
> More details, including .config, at [2].
> 
> Any ideas for tracking this down?

Which initrd / boot script are you using?  It looks like lvm assemble
scripts are running before sdX are detected leading to volume assembly
failure.  Before the patch, any module loading would end up
synchronizing async probes but after the patch modprobe invocations
which don't schedule them won't be.  Does your boot script happen to
run multiple modprobes in parallel and proceed to configure lvm
without waiting for modprobes of libata drivers to finish?

Thanks.

-- 
tejun
