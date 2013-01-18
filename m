Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3ARC7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 21:59:45 -0500
Received: from mail-gh0-f175.google.com ([209.85.160.175]:60846 "EHLO
	mail-gh0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3ARC7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 21:59:43 -0500
X-Greylist: delayed 29601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 21:59:43 EST
Date: Thu, 17 Jan 2013 18:59:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] workqueue, async: implement work/async_current_func()
Message-ID: <20130118025936.GJ16568@mtj.dyndns.org>
References: <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
 <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Thu, Jan 17, 2013 at 06:47:48PM -0800, Linus Torvalds wrote:
> On Thu, Jan 17, 2013 at 5:25 PM, Tejun Heo <tj@kernel.org> wrote:
> > Implement work/async_current_func() which query whether the current
> > task is a workqueue or async worker respectively and, if so, return
> > the current function being executed along with work / async item
> > related information.
> 
> So why the odd interface? The only user of it calls it with a

Yeah, I was doing something else in async and arguing between that and
current_is_async() and ended up keeping it as it was consistent with
the workqueue counterpart.

> NULL/NULL pair of arguments, and in general it's just way too complex
> to be an exported function at all. I *suspect* you chose that complex
> interface because you feel you may have some use for it inside of the
> async code itself, but why isn't that then not totally private to
> there?
> 
> IOW, why isn't the interface just
> 
>    static struct worker *current_worker(void)
>    {
>       if (current->flags & PF_WQ_WORKER)
>          return kthread_data(current);
>       return NULL;
>    }

I'd prefer to keep struct worker inside workqueue.c, so how about
keeping the workqueue part and make async part current_is_async()?

Thanks.

-- 
tejun
