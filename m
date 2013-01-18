Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3ARDrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:47:25 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49695 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3ARDrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:47:24 -0500
Date: Thu, 17 Jan 2013 19:47:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] workqueue, async: implement work/async_current_func()
Message-ID: <20130118034718.GX2668@htj.dyndns.org>
References: <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
 <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
 <20130118025936.GJ16568@mtj.dyndns.org>
 <20130118030407.GK16568@mtj.dyndns.org>
 <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 07:18:26PM -0800, Linus Torvalds wrote:
> I'm not sure I understand what you mean? Do you mean trying to limit
> work_current_func() to only be accessible to the async code? You'd
> have to make some kind of private header file under kernel/ for that,
> but I guess that would work fine. We already do something similar
> inside filesystems etc, where they have their own local headers.

Yeap, and I'm unsure whether it's worth introducing a new internal
header file.

> Yes, yes, some globally optimizing compiler could sort it all out, but
> I'd personally be inclined to just move all the structure definitions
> into kernel/worker.h, and make the code be inline functions. The only
> actual current *user* would also be in the kernel/ subdirectory, and
> we don't know if we'd ever want to really expand it past there.
> 
> Hmm?

If we're gonna make it kernel/ internal thing with internal header, we
definitely can go all the way.  It's a bit meh because the code path
involved is very cold.  Hmm... I'll make it that way.  I like how it
keeps the thing apparently internal.

Thanks.

-- 
tejun
